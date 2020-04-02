#!/bin/bash

set -euo pipefail
set -o xtrace

terraform apply ./deploy
