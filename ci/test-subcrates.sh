#!/usr/bin/env bash

set -e

for crate in $@ ; do
    pushd $crate

    cargo test --all-features
    cargo check --all-features --benches

    popd
done

# Remove any existing patch statements
mv Cargo.toml Cargo.toml.bck
sed -n '/\[patch.crates-io\]/q;p' Cargo.toml.bck > Cargo.toml

# Patch all crates
cat ci/patch.toml >> Cargo.toml

# Print `Cargo.toml` for debugging
echo "~~~~ Cargo.toml ~~~~"
cat Cargo.toml
echo "~~~~~~~~~~~~~~~~~~~~"

for crate in $@ ; do
    pushd $crate

    cargo test --all-features

    popd
done
