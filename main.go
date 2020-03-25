package main

import (
	"github.com/lynncyrin/github-stats/pkg/infra"
	"github.com/pulumi/pulumi/sdk/go/pulumi"
)

func main() {
	pulumi.Run(infra.SetupInfra)
}
