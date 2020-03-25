#!/bin/bash

set -euo pipefail
set -o xtrace

GOOS=${1:-linux}

GOPROXY=direct GOPRIVATE="*" CGO_ENABLED=0 GOOS=$GOOS GOARCH=amd64 go build \
  -o dist/server \
  ./cmd/server/main.go
