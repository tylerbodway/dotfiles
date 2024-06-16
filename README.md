# 💻 Tyler's Dotfiles

This repo holds my setup and configration files for any machine. I'm using
[dotbot][] for bootstrapping installation because it's nifty 😊

## System Requirements

- [`zsh`][zsh]
- [`git`][git]
- [`brew`][brew]

## Profiles

Global setup that should apply to any environment lives at the top-level of this repo, with
the base configuration at [`install.conf.yaml`][install].

Each OS/machine setup is stored in its own `profiles/` folder, which contains any specialized
dotfiles and a `install.conf.yaml` configuration.

> [!IMPORTANT]
> You can prefix the path in any `install.conf.yaml` with the `@` symbol, which will automatically
> be replaced with the selected profile's directory path.

## Usage

### Installing
There is a convention for each profile to contain a `setup.sh` script which will automatically
install any system requirements for that environment and run the installation. Here is an example:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/tylerbodway/dotfiles/main/profiles/mac/setup.sh)"
```

### Updating
The installation script is meant to be idempotent, meaning you can run it on initial setup as well
as any time you make a change to the configuration.
```bash
cd $DOTFILES
./install mac
```

## License

Copyright © Tyler Bodway. Released under the MIT License. See [LICENSE.md][license] for details.

[dotbot]: https://github.com/anishathalye/dotbot
[zsh]: https://www.zsh.org/
[git]: https://www.git-scm.com/
[brew]: https://brew.sh/
[install]: install.conf.yaml
[license]: LICENSE.md
