#!/usr/bin/env bash


nix shell nix-home\#mur.adguard-hostlist-compiler -c hostlist-compiler -c config_allow_adguard.json -o build/allowlist_adguard.txt --verbose
nix shell nix-home\#mur.adguard-hostlist-compiler -c hostlist-compiler -c config_allow_hosts.json -o build/allowlist_hosts.txt --verbose
