#!/bin/bash

set -euo pipefail
set -o xtrace

terraform init ./deploy
terraform plan ./deploy
