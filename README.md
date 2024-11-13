# 💻 Tyler's Dotfiles

This repo holds my setup and configration files for my MacBook. I'm using
[dotbot][] for bootstrapping installation because it's nifty 😊

## Usage

### Installing
In the project root, there is a `setup.sh` script which will automatically
install any system requirements run the installation.
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/tylerbodway/dotfiles/main/setup.sh)"
```

### Updating
The installation script is meant to be idempotent, meaning you can run it on initial setup as well
as any time you make a change to the configuration.
```bash
cd ~/.dotfiles
./install
```

## License

Copyright © Tyler Bodway. Released under the MIT License. See [LICENSE.md][license] for details.

[dotbot]: https://github.com/anishathalye/dotbot
[license]: LICENSE.md
