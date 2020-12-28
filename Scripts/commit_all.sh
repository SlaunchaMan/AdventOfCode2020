#!/usr/bin/env bash

swift run swiftlint autocorrect --quiet
swift run swiftlint lint --quiet --strict

if [ $? -eq 0 ]; then
	swift test --generate-linuxmain
	git add --all
	git commit --no-verify
fi
