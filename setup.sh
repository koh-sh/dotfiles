#!/usr/bin/env bash
set -eu

# Files to exclude from copying
EXCLUDE_FILES=("README.md" "$(basename "$0")" ".gitignore")

# Check if a file should be excluded from copying
is_excluded() {
    local file="$1"
    for excluded in "${EXCLUDE_FILES[@]}"; do
        if [[ "$file" == "$excluded" ]]; then
            return 0
        fi
    done
    return 1
}

# Get list of directories containing tracked files
get_directories() {
    git ls-files | xargs -n1 dirname | sort | uniq
}

# Get list of all tracked files
get_files() {
    git ls-files
}

# Copy a single file to the home directory if needed
copy_single_file() {
    local file="$1"
    local target_file="$HOME/$file"

    # Copy if target doesn't exist or files are different
    if [ ! -r "$target_file" ]; then
        echo "Adding: $file"
        cp -i "$file" "$target_file"
    elif ! diff "$file" "$target_file"; then
        cp -i "$file" "$target_file" || :
    fi
}

# Create directory structure in home directory
create_directories() {
    for dir in $(get_directories)
    do
        mkdir -p "$HOME/$dir"
    done
}

# Copy all non-excluded files to home directory
copy_files() {
    for file in $(get_files)
    do
        if is_excluded "$file"; then
            continue
        fi

        copy_single_file "$file"
    done
}

# Main execution function
main() {
    create_directories
    copy_files
}

main
