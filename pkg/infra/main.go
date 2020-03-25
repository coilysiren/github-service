package infra

import (
	"github.com/pulumi/pulumi-aws/sdk/go/aws/eks"
	"github.com/pulumi/pulumi/sdk/go/pulumi"
)

// SetupInfra setups up the infrastructure for our repo
func SetupInfra(ctx *pulumi.Context) (err error) {
	// Create an EKS cluster
	cluster, err := eks.NewCluster(ctx, "github-stats", nil)
	if err != nil {
		return err
	}

	// Export the name of the bucket
	ctx.Export("cluster-id", cluster.ID())
	return nil
}
