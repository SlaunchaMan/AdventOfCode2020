#!/bin/bash
set -e

SWIFT_LINT="swift run swiftlint"

if [[ $* == *--all* ]]; then
    ${SWIFT_LINT} autocorrect
    ${SWIFT_LINT} lint
    exit 0
fi

count=1

# Changed files not added to stage area yet
for file_path in $(git diff --diff-filter=d --name-only | grep ".swift$"); do
    export SCRIPT_INPUT_FILE_$count=$file_path
    count=$((count + 1))
done

# Changed files added to stage area
for file_path in $(git diff --diff-filter=d --name-only --cached | grep ".swift$"); do
    export SCRIPT_INPUT_FILE_$count=$file_path
    count=$((count + 1))
done

# Newly added untracked files
for file_path in $(git ls-files --others --exclude-standard | grep ".swift$"); do
    export SCRIPT_INPUT_FILE_$count=$file_path
    count=$((count + 1))
done

if [ "$count" -ne 0 ]; then
    export SCRIPT_INPUT_FILE_COUNT=$count
    $SWIFT_LINT autocorrect --use-script-input-files --force-exclude
    $SWIFT_LINT lint --use-script-input-files --force-exclude
else
    exit 0
fi
