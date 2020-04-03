#!/bin/bash

set -euo pipefail
set -o xtrace

name=$(yq r config.yml name)

aws eks update-kubeconfig --name "$name"
