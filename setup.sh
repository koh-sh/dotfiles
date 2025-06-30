#!/usr/bin/env bash
set -eu

EXCLUDE_FILES=("README.md" "setup.sh" ".gitignore")

is_excluded() {
    local file="$1"
    for excluded in "${EXCLUDE_FILES[@]}"; do
        if [[ "$file" == "./$excluded" ]]; then
            return 0
        fi
    done
    return 1
}

create_directories() {
    for dir in $(find . -type d -not -path "./.git*" -not -path "." | cut -c 3-)
    do
        mkdir -p "$HOME/$dir"
    done
}

copy_files() {
    for file in $(find . -type f -not -path "./.git/*" | cut -c 3-)
    do
        if is_excluded "./$file"; then
            continue
        fi
        
        if [ ! -r "$HOME/$file" ]; then
            cp -i "$file" "$HOME/$file"
        elif ! diff "$file" "$HOME/$file"; then
            cp -i "$file" "$HOME/$file" || :
        fi
    done
}

main() {
    create_directories
    copy_files
}

main
