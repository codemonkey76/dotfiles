#!/usr/bin/env bash

address="${1#mailto:}"
wezterm start -- neomutt "$address"
