#!/bin/bash

cd ../
if which swiftlint >/dev/null; then
    count=0
    for file_path in $(git ls-files -om --exclude-from=.gitignore | grep ".swift$"); do
	export SCRIPT_INPUT_FILE_$count=$file_path
	count=$((count + 1))
    done
    for file_path in $(git diff --cached --name-only | grep ".swift$"); do
	export SCRIPT_INPUT_FILE_$count=$file_path
	count=$((count + 1))
    done
    if [[ $count -gt 0 ]]; then
	export SCRIPT_INPUT_FILE_COUNT=$count
	swiftlint autocorrect --use-script-input-files
	swiftlint lint --use-script-input-files
    else
	echo "You haven't changed any file"
    fi
else
    echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi