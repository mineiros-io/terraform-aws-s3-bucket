package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestSecureS3Bucket(t *testing.T) {
	t.Parallel()

	awsRegion := aws.GetRandomRegion(t, nil, nil)

	terraformOptions := &terraform.Options{
		// The path to where your Terraform code is located
		TerraformDir: "./secure-s3-bucket",
		Vars: map[string]interface{}{
			"aws_region": awsRegion,
		},
		Upgrade: true,
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApplyAndIdempotent(t, terraformOptions)
}
