#!/bin/bash

set -euo pipefail
set -o xtrace

TF_VAR_AWS_ACCOUNT_ID="$AWS_ACCOUNT_ID" \
TF_VAR_AWS_REGION="$AWS_REGION" \
  terraform plan
