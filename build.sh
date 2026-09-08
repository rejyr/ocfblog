#!/usr/bin/env bash

set -euo pipefail

nix build

mkdir -p public
rm -drf public/*
cp -rL result/* public/
chmod 755 -R public/
