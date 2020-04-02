#!/bin/bash

set -euo pipefail
set -o xtrace

env PORT=8080 go run main.go
