# 💻 Tyler's Dotfiles

This repo manages my macOS applications, command-line tools, dependencies, configurations, etc.
The goal is to deterministically set up a new machine to my preferred state quickly.
It also allows me to iterate on configuration within the safety of version control.
It is bootstrapped by [dotbot][] because it's nifty ✨

## Usage

### Initialization

To set up a fresh macOS install, the `./init` script will automatically
install system requirements, clone the repo, and run the `./install` script.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/tylerbodway/dotfiles/main/init)"
```

### Installation

The installation script is meant to be idempotent-ish, meaning you can run it on initialization as well
as any time you make a change to the configuration.

```zsh
cd ~/.dotfiles
./install
```

See dotbot [docs](https://github.com/anishathalye/dotbot?tab=readme-ov-file#command-line-arguments) for more command-line options.

## License

Copyright © Tyler Bodway. Released under the MIT License. See [LICENSE.md][license] for details.

[dotbot]: https://github.com/anishathalye/dotbot
[license]: LICENSE.md
