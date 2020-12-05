#!/bin/bash
SWIFT_LINT="swift run swiftlint"

if [[ $* == *--all* ]]; then
    ${SWIFT_LINT} autocorrect
    ${SWIFT_LINT} lint
    exit 0
fi

count=0

# Changed files added to stage area
file_paths=$(git diff --diff-filter=d --name-only --cached | grep ".swift$")

if [ -n "$file_paths" ]; then
    ${SWIFT_LINT} lint $file_paths
    exit $?
fi
