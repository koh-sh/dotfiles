# dotfiles

## install

```bash
brew install chezmoi
mkdir -p github
chezmoi init koh-sh -S github/dotfiles
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
