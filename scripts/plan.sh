#!/bin/bash

set -euo pipefail
set -o xtrace

# setup basic local configuration
name=$(yq r config.yml name)
stateBucketRegion="us-west-2"
stateBucketName="$name-state-bucket"
export TF_VAR_STATE_BUCKET_NAME="$stateBucketName"
export TF_VAR_STATE_BUCKET_REGION="$stateBucketRegion"
export TF_VAR_NAME="$name"

# setup the plans dir
mkdir -p ./deploy/plans

function bootstapLocalState {
  # plan and apply the state dir
  # the "state dir" holds the resources for the "resources dir"
  # in general the state dir only needs to be deployed once
  terraform init \
    -backend-config="bucket=$stateBucketName" \
    -backend-config="path=./deploy/state/terraform.tfstate" \
    ./deploy/state
  terraform plan -out ./deploy/plans/state ./deploy/state
  terraform apply ./deploy/plans/state
}

# if the local state bucket has not been setup, then set it up
aws s3 ls "$stateBucketName" || bootstapLocalState

# plan the resources dir
terraform init \
  -backend-config="bucket=$stateBucketName" \
  -backend-config="region=$stateBucketRegion" \
  -backend-config="key=terraform.tfstate" \
  ./deploy/resources
terraform plan -out ./deploy/plans/resources ./deploy/resources
