#!/bin/bash

set -euo pipefail
set -o xtrace

# init both the state and the resources dir, and prep the plans folder
terraform init ./deploy/state
terraform init ./deploy/resources
mkdir -p ./deploy/plans

# plan the apply the state dir
# the "state dir" holds the resources for the "resources dir"
# in general the state dir only needs to be deployed once
terraform plan -out ./deploy/plans/state ./deploy/state
terraform apply ./deploy/plans/state

# plan the resources dir
terraform plan -out ./deploy/plans/resources ./deploy/resources
