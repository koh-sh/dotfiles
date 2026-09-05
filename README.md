# dotfiles

## New machine setup

```bash
xcode-select --install
curl https://mise.run | sh
mkdir -p ~/github
~/.local/bin/mise x chezmoi@latest -- chezmoi init koh-sh --source ~/github/dotfiles --apply
```

Grant Full Disk Access to the terminal, put machine-specific packages in `~/.config/mise/config.local.toml`, then:

```bash
~/.local/bin/mise bootstrap --yes
```

## commands

```bash
# add new file
chezmoi add [file]

# apply git managed files to local
chezmoi diff -v
chezmoi apply

# chezmoi config
chezmoi dump-config
```
