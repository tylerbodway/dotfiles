# 💻 Tyler Bodway's Dotfiles

This holds my configuration files to help easily set up development environments.
Bootstrapping is meant to be idempotent, meaning it can be run more than once.
I'm using the tool [Dotbot][dotbot] for installation cause it's nifty.

## Setup

### Requirements

Being a developer mainly on macOS, this assumes [zsh][zsh] as the default shell,
and also be sure to have [brew][brew] installed for OS packages and applications.

### Install
Clone the repository, and run the `./install` script. You can also re-run the
script to apply any future updates.
```
cd ~
git clone https://github.com/tylerbodway/dotfiles && cd dotfiles
./install
```

To upgrade submodules to their latest versions, run:
```
git submodule update --init --remote
```

[dotbot]: https://github.com/anishathalye/dotbot
[zsh]: https://www.zsh.org/
[brew]: https://brew.sh/
