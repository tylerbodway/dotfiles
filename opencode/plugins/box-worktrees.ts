// Git worktrees for work repos, set up with pco-box.
//
// Replaces OpenCode's built-in git worktree strategy, which checks out the
// main checkout's HEAD (often a stale local main). This one:
//
//   - create: fetches origin and starts from its default branch, then runs
//     `box worktree setup` in apps with a devbox.json. A failed setup removes
//     the worktree, so a created worktree always has its gems, node packages,
//     and keys.
//   - remove: stops the worktree's `box worktree server`, if one is running,
//     before removing it. Branches are kept; they may hold unpushed work.
//
// Loaded only for ~/Code via ~/Code/.opencode/plugins (see install.conf.yaml).
import { execFile } from "node:child_process";
import { existsSync, readFileSync } from "node:fs";
import { homedir } from "node:os";
import { join, resolve } from "node:path";
import { promisify } from "node:util";
import { Plugin } from "@opencode/plugin";

const exec = promisify(execFile);

const BOX_DIR = process.env.PCO_BOX_DIR ?? join(homedir(), "pco-box");
const BOX = join(BOX_DIR, "bin/box");
const PORTS_FILE = join(BOX_DIR, "worktree_ports.json");
const CODE_DIR = join(homedir(), "Code");

async function run(
  command: string,
  args: string[],
  options: { cwd?: string; signal: AbortSignal; env?: NodeJS.ProcessEnv },
) {
  try {
    const { stdout } = await exec(command, args, {
      cwd: options.cwd,
      signal: options.signal,
      env: { ...process.env, ...options.env },
      maxBuffer: 64 * 1024 * 1024,
    });
    return stdout.trim();
  } catch (error) {
    const { stdout = "", stderr = "", message } = error as {
      stdout?: string;
      stderr?: string;
      message: string;
    };
    const output = `${stdout}\n${stderr}`.trim() || message;
    throw new Error(`\`${[command, ...args].join(" ")}\` failed:\n${tail(output)}`);
  }
}

const git = (args: string[], signal: AbortSignal) =>
  run("git", args, { signal, env: { GIT_TERMINAL_PROMPT: "0" } });

function tail(output: string, lines = 30) {
  return output.replace(/\x1b\[[0-9;]*[A-Za-z]/g, "").split("\n").slice(-lines).join("\n");
}

async function startingRef(source: string, signal: AbortSignal) {
  await git(["-C", source, "fetch", "--quiet", "origin"], signal).catch(() => {});
  return git(["-C", source, "symbolic-ref", "--short", "refs/remotes/origin/HEAD"], signal).catch(
    () => "HEAD",
  );
}

async function removeWorktree(directory: string, force: boolean, signal: AbortSignal) {
  const commonDir = resolve(
    directory,
    await git(["-C", directory, "rev-parse", "--git-common-dir"], signal),
  );
  await git(
    ["-C", commonDir, "worktree", "remove", ...(force ? ["--force"] : []), "--", directory],
    signal,
  );
}

function alive(pid: number) {
  try {
    process.kill(pid, 0);
    return true;
  } catch {
    return false;
  }
}

// Stopping puma ends `box worktree server`, which then stops sidekiq and
// deregisters the server itself.
async function stopServers(directory: string) {
  if (!existsSync(PORTS_FILE)) return;
  const servers: Record<string, { path?: string; pid?: number }> = JSON.parse(
    readFileSync(PORTS_FILE, "utf8"),
  );
  const pids = Object.values(servers)
    .filter((server) => server.path && resolve(CODE_DIR, server.path) === directory)
    .flatMap((server) => (server.pid && alive(server.pid) ? [server.pid] : []));

  for (const pid of pids) process.kill(pid, "SIGTERM");
  for (let waited = 0; waited < 10_000 && pids.some(alive); waited += 250) {
    await new Promise((done) => setTimeout(done, 250));
  }
}

export default Plugin.define({
  id: "box.worktrees",
  async setup(ctx) {
    await ctx.worktree.transform((editor) => {
      editor.add({
        id: "box",

        async create({ sourceDirectory, directory, branch }, { signal }) {
          const ref = branch ?? (await startingRef(sourceDirectory, signal));
          await git(
            ["-C", sourceDirectory, "worktree", "add", "--detach", "--", directory, ref],
            signal,
          );

          if (existsSync(join(directory, "devbox.json")) && existsSync(BOX)) {
            try {
              await run(BOX, ["worktree", "setup"], {
                cwd: directory,
                signal,
                env: { NON_INTERACTIVE: "1" },
              });
            } catch (error) {
              await removeWorktree(directory, true, AbortSignal.timeout(30_000)).catch(() => {});
              throw error;
            }
          }

          return { directory };
        },

        async remove({ directory, force }, { signal }) {
          await stopServers(directory);
          await removeWorktree(directory, force, signal);
        },

        async list(sourceDirectory, { signal }) {
          const output = await git(
            ["-C", sourceDirectory, "worktree", "list", "--porcelain"],
            signal,
          );
          return output
            .split("\n")
            .filter((line) => line.startsWith("worktree "))
            .map((line, index) => ({
              directory: line.slice("worktree ".length),
              type: index === 0 ? ("root" as const) : ("worktree" as const),
            }));
        },
      });
    });
  },
});
