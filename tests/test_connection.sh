#!/usr/bin/env bash
# Checks if WireGuard interface is up and ping through tunnel
if ! wg show wg0 >/dev/null; then
  echo "WireGuard not running" >&2
  exit 1
fi

ping -c 3 10.0.10.1
