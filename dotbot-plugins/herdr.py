import os
import re
import subprocess

import dotbot
import yaml


class Herdr(dotbot.Plugin):
    """
    Install herdr plugins from manifest files.

    Reads declarative entries (repo, optional ref) and runs
    `herdr plugin install <owner/repo[/subdir]> --yes` for anything not
    already installed. Re-runs are idempotent; there is no `herdr plugin
    update` in v1, so reinstalling from GitHub is how plugins refresh.
    """

    _directive = "herdr"

    def can_handle(self, directive):
        return directive == self._directive

    def handle(self, directive, data):
        if directive != self._directive:
            raise ValueError(f"Herdr cannot handle directive {directive}")
        return self._process_manifests(data)

    def _process_manifests(self, files):
        """Process a list of manifest files containing plugin entries."""
        cwd = self._context.base_directory()
        success = True

        for manifest in files:
            full_path = os.path.join(cwd, manifest)

            if not os.path.exists(full_path):
                self._log.warning(f"Manifest not found: {manifest}")
                success = False
                continue

            self._log.info(f"Installing herdr plugins from {manifest}")

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
            self._log.action("Herdr plugins installed via herdr CLI.")
        else:
            self._log.error("Some herdr plugins were not successfully installed")

        return success

    def _install_entry(self, entry, cwd):
        """Install one manifest entry by shelling out to the herdr CLI."""
        if not isinstance(entry, dict) or "repo" not in entry:
            self._log.error(f"Invalid manifest entry: {entry}")
            return False

        repo = entry["repo"]
        ref = entry.get("ref")

        installed_ref = self._installed_ref(repo)
        if installed_ref is not None and (ref is None or installed_ref == ref):
            print(f"Using {repo}")
            return True

        command = ["herdr", "plugin", "install", repo, "--yes"]
        if ref:
            command += ["--ref", ref]

        self._log.action(f"Installing herdr plugin {repo}")
        return subprocess.call(command, cwd=cwd) == 0

    def _installed_ref(self, repo):
        """Return the installed ref for a GitHub repo, or None when absent."""
        try:
            result = subprocess.run(
                ["herdr", "plugin", "list"],
                stdout=subprocess.PIPE,
                stderr=subprocess.DEVNULL,
                text=True,
            )
        except OSError:
            return None
        if result.returncode != 0:
            return None
        match = re.search(rf"github:{re.escape(repo)}@(\S+)", result.stdout)
        return match.group(1) if match else None
