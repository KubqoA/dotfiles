![Nyckelharpa](./nyckelharpa.jpg)

# nyckelharpa

## Setup
1. Install prerequisites - [`nix`](https://nix.dev/install-nix) and [homebrew](https://brew.sh)
```sh
curl -L https://nixos.org/nix/install | sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

2. Clone the repository
```sh
git clone git@github.com:KubqoA/dotfiles.git ~/.config/dotfiles
```

3. Enter the dev shell and initialize the configs
```sh
nix develop
# Runs nix-darwin and home-manager
os nyckelharpa
hm jakub-macos
```

4. To apply further updates, run
```sh
os switch
hm switch
```
