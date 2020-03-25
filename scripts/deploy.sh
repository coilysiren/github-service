#!/bin/bash

set -euo pipefail
set -o xtrace

pulumi up --stack dev
