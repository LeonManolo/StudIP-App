#!/bin/bash

function run_flutter_test() {
    flutter test test
}

function process_directory() {
    local dir="$1"
    if [ -f "$dir/pubspec.yaml" ]; then
        cd "$dir"
        run_flutter_test
        cd ..
    fi
}

cd ..

# Tests im root verzeichnis starten
run_flutter_test

# In das 'packages'-Verzeichnis wechseln
cd packages

# Für jeden Ordner im 'packages'-Verzeichnis die tests runnen
for dir in */ ; do
    process_directory "$dir"
done
