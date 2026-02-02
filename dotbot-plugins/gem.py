import os
import subprocess
import re
import dotbot


class Gem(dotbot.Plugin):
    """
    Install Ruby gems from Gemfile files.
    """

    _directive = "gem"

    def can_handle(self, directive):
        return directive == self._directive

    def handle(self, directive, data):
        if directive != self._directive:
            raise ValueError(f"Gem cannot handle directive {directive}")
        return self._process_files(data)

    def _process_files(self, files):
        """Process list of Gemfile files."""
        cwd = self._context.base_directory()
        success = True
        total_gems = 0

        for gem_file in files:
            full_path = os.path.join(cwd, gem_file)

            if not os.path.exists(full_path):
                self._log.warning(f"Gem file not found: {gem_file}")
                success = False
                continue

            self._log.info(f"Installing gems from {gem_file}")

            try:
                gems = self._parse_gemfile(full_path)

                if not gems:
                    self._log.warning(f"No gems found in {gem_file}")
                    continue

                total_gems = len(gems)

                for gem in gems:
                    if not self._process_gem(gem, cwd):
                        success = False

            except Exception as e:
                self._log.error(f"Error processing {gem_file}: {str(e)}")
                success = False

        if success:
            self._log.action(f"`gem install` complete! {total_gems} Gemfile dependencies now installed.")
        else:
            self._log.error("Some gems were not successfully processed")

        return success

    def _parse_gemfile(self, file_path):
        """Parse gems from a Gemfile."""
        gems = []

        with open(file_path, 'r') as f:
            for line in f:
                line = line.strip()

                # Skip comments and empty lines
                if not line or line.startswith('#'):
                    continue

                # Match gem 'name' or gem "name"
                # Supports: gem 'name', gem "name", gem 'name', version: '1.0'
                match = re.match(r"gem\s+['\"]([^'\"]+)['\"]", line)
                if match:
                    gems.append(match.group(1))

        return gems

    def _process_gem(self, gem, cwd):
        """Install or update a single gem."""
        with open(os.devnull, 'w') as devnull:
            # Check if gem is installed
            check_cmd = f"gem list -i '^{gem}$'"
            is_installed = subprocess.call(
                check_cmd,
                shell=True,
                stdout=devnull,
                stderr=devnull,
                cwd=cwd
            )

            if is_installed == 0:
                # Check if outdated
                outdated_cmd = f"gem outdated {gem}"
                result = subprocess.run(
                    outdated_cmd,
                    shell=True,
                    stdout=subprocess.PIPE,
                    stderr=devnull,
                    cwd=cwd,
                    text=True
                )

                if gem in result.stdout:
                    self._log.action(f"Upgrading {gem}")
                    update_cmd = f"gem update {gem}"
                    ret = subprocess.call(update_cmd, shell=True, stdout=devnull, cwd=cwd)
                    if ret != 0:
                        self._log.error(f"Failed to install {gem}")
                        return False
                else:
                    print(f"Using {gem}")
            else:
                self._log.action(f"Installing {gem}")
                install_cmd = f"gem install {gem}"
                ret = subprocess.call(install_cmd, shell=True, stdout=devnull, cwd=cwd)
                if ret != 0:
                    self._log.error(f"Failed to install {gem}")
                    return False

        return True
