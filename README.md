# 💻 Tyler's Dotfiles

This repo holds my setup and configration files for any machine. I'm using
[dotbot][] for bootstrapping installation because it's nifty 😊

## Usage

Clone the repository:
```bash
git clone https://github.com/tylerbodway/dotfiles.git ~/.dotfiles
```

To install a profile, run the install script with a profile name (default is `mac`):
```bash
./install mac
```
> [!NOTE]
The installation script is meant to be idempotent. You can run it upon intial set up, and/or any
time you make a change.
>

## Profiles

Global configurations that should apply to any machine live at the top level of this repo, and
installation instructions live in `install.conf.yaml`.

Separate OS or machine setups can be stored in a distinct `profiles/` folder
with their own configuration files and `install.conf.yaml`.

> [!IMPORTANT]
> Prefix paths in any profile's `install.conf.yaml` with the `@` symbol. The installation
> script will automatically replace it with the profile's actual directory path.

Both the global and profile-specific configurations will be installed.

## License

Copyright © Tyler Bodway. Released under the MIT License. See [LICENSE.md][license] for details.

[dotbot]: https://github.com/anishathalye/dotbot
[license]: LICENSE.md
