#!/bin/sh
set -eu

# Release assets can change; pin the tested bytes rather than trust the filename.
model_name=wanxiang-lts-zh-hans.gram
model_sha256=e3f958d2557a2c027543e874c802dcce9022b9b6fe1673d97c0bd1ef30592264
model_url=https://github.com/amzxyz/RIME-LMDG/releases/download/LTS/wanxiang-lts-zh-hans.gram
rime_target=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
model_target="$rime_target/$model_name"

verify_model() {
  printf '%s  %s\n' "$model_sha256" "$1" | shasum -a 256 -c -
}

if [ -f "$model_target" ]; then
  if verify_model "$model_target"; then
    printf '%s\n' 'Model already installed and verified.'
    exit 0
  fi
  printf '%s\n' 'Existing model differs from the pinned version; preserved unchanged.' >&2
  exit 1
fi

model_tmp_dir=$(mktemp -d)
trap 'rm -rf "$model_tmp_dir"' EXIT HUP INT TERM
curl --fail --location --retry 3 --connect-timeout 20 \
  --output "$model_tmp_dir/$model_name" "$model_url"
verify_model "$model_tmp_dir/$model_name"
cp "$model_tmp_dir/$model_name" "$model_target"
printf '%s\n' 'Model installed. Redeploy Rime to load it.'

