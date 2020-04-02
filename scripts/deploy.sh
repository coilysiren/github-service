#!/bin/bash

set -euo pipefail
set -o xtrace

terraform apply -state=./deploy/state/terraform.tfstate ./deploy/plans/plan
