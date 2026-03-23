import os
import subprocess
import json
import dotbot


class OpenPackage(dotbot.Plugin):
    """
    Install OpenPackage (opkg) packages from a manifest file.
    """

    _directive = "opkg"

    def can_handle(self, directive):
        return directive == self._directive

    def handle(self, directive, data):
        if directive != self._directive:
            raise ValueError(f"OpenPackage cannot handle directive {directive}")
        return self._process_files(data)

    def _process_files(self, files):
        """Process list of manifest files."""
        cwd = self._context.base_directory()
        success = True
        total_packages = 0

        for manifest_file in files:
            full_path = os.path.join(cwd, manifest_file)

            if not os.path.exists(full_path):
                self._log.warning(f"Manifest file not found: {manifest_file}")
                success = False
                continue

            self._log.info(f"Installing openpackage packages from {manifest_file}")

            try:
                with open(full_path, "r") as f:
                    data = json.load(f)

                packages = data.get("packages", [])

                if not packages:
                    self._log.warning(f"No packages found in {manifest_file}")
                    continue

                total_packages = len(packages)

                for package in packages:
                    if not self._process_package(package, cwd):
                        success = False

            except json.JSONDecodeError:
                self._log.error(f"Invalid JSON in {manifest_file}")
                success = False
            except Exception as e:
                self._log.error(f"Error processing {manifest_file}: {str(e)}")
                success = False

        if success:
            self._log.action(
                f"`opkg install` complete! {total_packages} openpackage dependencies now installed."
            )
        else:
            self._log.error("Some openpackage packages were not successfully processed")

        return success

    def _process_package(self, package, cwd):
        """Install a single openpackage package."""
        with open(os.devnull, "w") as devnull:
            self._log.action(f"Installing {package}")
            install_cmd = [
                "opkg",
                "install",
                package,
                "--global",
                "--platforms",
                "opencode",
                "--force",
            ]
            ret = subprocess.call(install_cmd, stdout=devnull, stderr=devnull, cwd=cwd)
            if ret != 0:
                self._log.error(f"Failed to install {package}")
                return False

        return True
