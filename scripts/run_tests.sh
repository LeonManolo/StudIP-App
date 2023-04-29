#!/bin/bash

function run_flutter_test() {
    flutter test test
}

function check_and_run_build_runner() {
    local pubspec_file="$1"
    if grep -q "build_runner:" "$pubspec_file"; then
        dart run build_runner build
    fi
}

function process_directory() {
    local dir="$1"
    if [ -f "$dir/pubspec.yaml" ]; then
        cd "$dir"
        check_and_run_build_runner "pubspec.yaml"
        run_flutter_test
        cd ..
    fi
}

cd ..

# Tests im root verzeichnis starten
check_and_run_build_runner "pubspec.yaml"
run_flutter_test

# In das 'packages'-Verzeichnis wechseln
cd packages

# Für jeden Ordner im 'packages'-Verzeichnis die tests runnen
for dir in */ ; do
    process_directory "$dir"
done
