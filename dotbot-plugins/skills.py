import os
import subprocess

import dotbot
import yaml


class Skills(dotbot.Plugin):
    """
    Install third-party agent skills via the gh skill CLI from a manifest.

    Reads declarative entries (repo, optional skills, optional dir, optional
    pin) and runs `gh skill install` for each. Skills land in `dir` as plain
    directories the agents already scan. --force overwrites in place with the
    latest ref, so re-running ./install doubles as an upgrade.
    """

    _directive = "skills"

    DEFAULT_AGENT = "opencode"
    DEFAULT_DIR = os.path.expanduser("~/.agents/skills")

    def can_handle(self, directive):
        return directive == self._directive

    def handle(self, directive, data):
        if directive != self._directive:
            raise ValueError(f"Skills cannot handle directive {directive}")
        return self._process_manifests(data)

    def _process_manifests(self, files):
        """Process a list of manifest files containing skill entries."""
        cwd = self._context.base_directory()
        success = True

        for manifest in files:
            full_path = os.path.join(cwd, manifest)

            if not os.path.exists(full_path):
                self._log.warning(f"Manifest not found: {manifest}")
                success = False
                continue

            try:
                with open(full_path, "r") as f:
                    entries = yaml.safe_load(f) or []
            except yaml.YAMLError as e:
                self._log.error(f"Invalid YAML in {manifest}: {e}")
                success = False
                continue

            if not isinstance(entries, list):
                self._log.error(f"Manifest must be a list of entries: {manifest}")
                success = False
                continue

            for entry in entries:
                if not self._install_entry(entry, cwd):
                    success = False

        if success:
            self._log.action("External skills installed")
        else:
            self._log.error("Some external skills were not successfully installed")

        return success

    def _install_entry(self, entry, cwd):
        """Install one manifest entry. Returns True on success."""
        if not isinstance(entry, dict) or "repo" not in entry:
            self._log.error(f"Invalid manifest entry: {entry}")
            return False

        target = os.path.expanduser(entry.get("dir") or self.DEFAULT_DIR)
        command = [
            "gh",
            "skill",
            "install",
            entry["repo"],
            "--agent",
            self.DEFAULT_AGENT,
            "--dir",
            target,
            "--force",
        ]
        if entry.get("pin"):
            command += ["--pin", entry["pin"]]

        # gh takes at most one skill per invocation, so a `skills` list becomes
        # one command per name; omitting it installs the whole repo via --all.
        skills = entry.get("skills")
        if skills:
            commands = [command + [skill] for skill in skills]
        else:
            commands = [command + ["--all"]]

        self._log.action(f"Installing {entry['repo']} -> {target}")
        ok = True
        for cmd in commands:
            result = subprocess.run(cmd, cwd=cwd)
            if result.returncode != 0:
                self._log.error(f"Failed to install {entry['repo']}")
                ok = False
        return ok
