package infra

import (
	"github.com/pulumi/pulumi-aws/sdk/go/aws/eks"
	"github.com/pulumi/pulumi/sdk/go/pulumi"
)

// ConfigureInfra configures the infrastructure for our repo
func ConfigureInfra(ctx *pulumi.Context) (err error) {
	// Create an EKS cluster
	cluster, err := eks.NewCluster(ctx, "github-stats", &eks.ClusterArgs{})
	if err != nil {
		return err
	}

	// Export the name of the cluster
	ctx.Export("cluster-id", cluster.ID())
	return nil
}
