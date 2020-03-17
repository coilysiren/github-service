#!/bin/bash

set -euo pipefail
set -o xtrace

go test -v ./...
