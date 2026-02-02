import os
import subprocess
import json
import dotbot


class Npm(dotbot.Plugin):
    """
    Install npm packages from package.json files.
    """

    _directive = "npm"

    def can_handle(self, directive):
        return directive == self._directive

    def handle(self, directive, data):
        if directive != self._directive:
            raise ValueError(f"Npm cannot handle directive {directive}")
        return self._process_files(data)

    def _process_files(self, files):
        """Process list of package.json files."""
        cwd = self._context.base_directory()
        success = True
        total_packages = 0

        for package_file in files:
            full_path = os.path.join(cwd, package_file)

            if not os.path.exists(full_path):
                self._log.warning(f"Package file not found: {package_file}")
                success = False
                continue

            self._log.info(f"Installing npm packages from {package_file}")

            try:
                with open(full_path, 'r') as f:
                    data = json.load(f)

                # Get packages from dependencies and devDependencies
                packages = []
                if 'dependencies' in data:
                    packages.extend(data['dependencies'].keys())
                if 'devDependencies' in data:
                    packages.extend(data['devDependencies'].keys())

                if not packages:
                    self._log.warning(f"No packages found in {package_file}")
                    continue

                total_packages = len(packages)

                for package in packages:
                    if not self._process_package(package, cwd):
                        success = False

            except json.JSONDecodeError:
                self._log.error(f"Invalid JSON in {package_file}")
                success = False
            except Exception as e:
                self._log.error(f"Error processing {package_file}: {str(e)}")
                success = False

        if success:
            self._log.action(f"`npm install` complete! {total_packages} package.json dependencies now installed.")
        else:
            self._log.error("Some npm packages were not successfully processed")

        return success

    def _process_package(self, package, cwd):
        """Install or update a single npm package."""
        with open(os.devnull, 'w') as devnull:
            # Check if package is installed
            check_cmd = f"npm list -g --depth=0 {package}"
            is_installed = subprocess.call(
                check_cmd,
                shell=True,
                stdout=devnull,
                stderr=devnull,
                cwd=cwd
            )

            if is_installed == 0:
                # Check if outdated
                outdated_cmd = f"npm outdated -g {package}"
                result = subprocess.run(
                    outdated_cmd,
                    shell=True,
                    stdout=subprocess.PIPE,
                    stderr=devnull,
                    cwd=cwd,
                    text=True
                )

                if package in result.stdout:
                    self._log.action(f"Upgrading {package}")
                    install_cmd = f"npm install -g {package}@latest"
                    ret = subprocess.call(install_cmd, shell=True, stdout=devnull, cwd=cwd)
                    if ret != 0:
                        self._log.error(f"Failed to install {package}")
                        return False
                else:
                    print(f"Using {package}")
            else:
                self._log.action(f"Installing {package}")
                install_cmd = f"npm install -g {package}@latest"
                ret = subprocess.call(install_cmd, shell=True, stdout=devnull, cwd=cwd)
                if ret != 0:
                    self._log.error(f"Failed to install {package}")
                    return False

        return True
