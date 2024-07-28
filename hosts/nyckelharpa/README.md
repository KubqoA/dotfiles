![Nyckelharpa](./nyckelharpa.jpg)

# nyckelharpa

## Setup
1. Install [`nix`](https://nix.dev/install-nix)
```sh
curl -L https://nixos.org/nix/install | sh
```

2. Install [homebrew](https://brew.sh)
```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

3. Clone the repository
```sh
git clone git@github.com:KubqoA/dotfiles.git
```

4. Install [`nix-darwin`](https://github.com/LnL7/nix-darwin?tab=readme-ov-file#flakes)
```sh
nix run nix-darwin -- switch --flake ~/dotfiles
```

TODO: Add more instructions
