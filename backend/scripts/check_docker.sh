#!/bin/bash

# check if `docker` is installed

set -euo pipefail

command -v docker >/dev/null 2>&1 || { echo >&2 "docker needs to be installed, please install it on mac with via the directions here => https://docs.docker.com/docker-for-mac/install/"; exit 1; }
