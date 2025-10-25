# apply command

apply dotfiles changes to local machine with chezmoi

1. run `chezmoi diff` to check if there is any changes to local configs
   if any, ask users to keep local settings or overwrite with current dotfiles in thie project
2. run `chezmoi apply --force` to apply
