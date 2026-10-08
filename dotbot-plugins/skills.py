import hashlib
import json
import os
import subprocess

import dotbot
import yaml


class Skills(dotbot.Plugin):
    """
    Install third-party agent skills via the skills CLI from a manifest.

    Reads declarative entries (repo, optional skills, optional agents) and
    runs `skills add <repo> -g` so the CLI installs each skill to the right
    per-agent location. Re-runs are idempotent; upgrade everything with
    `skills update -g -y`.
    """

    _directive = "skills"

    DEFAULT_AGENTS = ["opencode"]
    # Where the skills CLI installs for the opencode agent. Used to detect
    # whether a skill is new, upgraded, or unchanged between installs.
    INSTALL_DIR = os.path.expanduser("~/.agents/skills")

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
        installed = 0
        upgraded = 0
        unchanged = 0

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
                counts = self._install_entry(entry, cwd)
                if counts is None:
                    success = False
                    continue
                installed += counts["installed"]
                upgraded += counts["upgraded"]
                unchanged += counts["unchanged"]

        total = installed + upgraded + unchanged
        if success:
            self._log.action(f"Skills complete! {total} external skills now installed ")
        else:
            self._log.error("Some external skills were not successfully installed")

        return success

    def _install_entry(self, entry, cwd):
        """Install one manifest entry. Returns per-skill counts, or None on failure."""
        if not isinstance(entry, dict) or "repo" not in entry:
            self._log.error(f"Invalid manifest entry: {entry}")
            return None

        command = ["skills", "add", entry["repo"], "-g", "-y", "--json"]
        for agent in entry.get("agents") or self.DEFAULT_AGENTS:
            command += ["-a", agent]

        skills = entry.get("skills")
        if skills:
            for skill in skills:
                command += ["--skill", skill]
        else:
            command += ["--skill", "*"]

        before = self._snapshot(skills)

        self._log.info(f"Installing from {entry['repo']}")
        result = subprocess.run(command, cwd=cwd, capture_output=True, text=True)

        if result.returncode != 0:
            self._log.error(f"Failed to install {entry['repo']}")
            if result.stdout.strip():
                self._log.error(result.stdout.strip())
            if result.stderr.strip():
                self._log.error(result.stderr.strip())
            return None

        counts = {"installed": 0, "upgraded": 0, "unchanged": 0}
        try:
            payload = json.loads(result.stdout[result.stdout.index("[") :])
        except (ValueError, json.JSONDecodeError):
            self._log.action(f"Installed skills from {entry['repo']}")
            return counts

        for skill in payload:
            name = skill.get("name")
            was = before.get(name)
            now = self._dir_hash(skill.get("path", ""))
            if was is None:
                self._log.action(f"Installing {name}")
                counts["installed"] += 1
            elif was == now:
                print(f"Using {name}")
                counts["unchanged"] += 1
            else:
                self._log.action(f"Upgrading {name}")
                counts["upgraded"] += 1

        return counts

    # change detection

    def _snapshot(self, skills):
        """Hash the current state of each skill dir before an install."""
        names = skills
        if names is None:
            # '*' — snapshot every installed skill dir
            names = (
                os.listdir(self.INSTALL_DIR) if os.path.isdir(self.INSTALL_DIR) else []
            )
        return {
            name: self._dir_hash(os.path.join(self.INSTALL_DIR, name)) for name in names
        }

    def _dir_hash(self, path):
        """Content hash of a skill directory, or None if it doesn't exist."""
        if not os.path.isdir(path):
            return None
        digest = hashlib.sha256()
        for root, dirs, files in os.walk(path):
            dirs.sort()
            for name in sorted(files):
                file_path = os.path.join(root, name)
                digest.update(os.path.relpath(file_path, path).encode())
                with open(file_path, "rb") as f:
                    for chunk in iter(lambda: f.read(65536), b""):
                        digest.update(chunk)
        return digest.hexdigest()
