#!/bin/bash

set -euo pipefail
set -o xtrace

terraform init ./deploy
mkdir -p ./deploy/plans
mkdir -p ./deploy/state
terraform plan -out ./deploy/plans/plan -state=./deploy/state/terraform.tfstate ./deploy
