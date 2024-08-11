#!/usr/bin/env bash
set -eu

# mkdir and cp files
for dir in $(find . -type d -not -path "./.git*" -not -path "."| cut -c 3- )
do
    mkdir -p "$HOME/$dir"
done

# cp FILES
for file in $(find . -type f -not -path "./.git/*" -not -path "./README.md" -not -path "./setup.sh" | cut -c 3-)
do
    if ! diff "$file" "$HOME/$file"; then
        cp -i "$file" "$HOME/$file" || :
    fi
done
