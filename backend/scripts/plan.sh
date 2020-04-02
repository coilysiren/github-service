#!/bin/bash

set -euo pipefail
set -o xtrace

pulumi preview --stack dev
