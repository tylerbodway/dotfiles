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

## Profiles

Global configurations that should apply to any machine live at the top level of this repo, and
installation instructions live in `install.conf.yaml`.

Any OS or machine specific customizations can live in a respective `profiles/<name>` folder
with it's own files and `install.conf.yaml`.

> [!NOTE]
> Prefix paths in the profile's `install.conf.yaml` with the `@` symbol. The installation
> script will automatically replace it with the actual path.

Both the global and profile-specific configurations will be installed.

## License

Copyright © Tyler Bodway. Released under the MIT License. See [LICENSE.md][license] for details.

[dotbot]: https://github.com/anishathalye/dotbot
[license]: LICENSE.md
