# terraform-eks
This is an opinionated way of setting up an EKS cluster using terraform. This module installs several helm packages
by default, packages installed listed below:

 - `aws-node-termination-handler` - Drains node when a node is terminated
 - `metrics-server` - metrics server we all know and love
 - `cluster-autoscaler` - Cluster autoscaler
 - `flux` - This is an optional package and installs the flux package
 - `helm-operator` - This is an optional package and installs the flux helm operator
 - `kubernetes-external-secrets` - This is an optional package for transforming ASM secrets into Kubernetes secrets
 - `prometheus` - Optional package to install prometheus metric server

## Usage
Example usage:

```bash
locals {
  cluster_name    = "my-cluster"
  cluster_version = "1.18"

  node_groups = {
    default-ng = {
      desired_capacity = 2
      max_capactiy     = 5
      min_capacity     = 2
      instance_type    = "t3.small"
      subnets          = data.terraform_remote_state.vpc.outputs.private_subnets

      k8s_labels = {
        Environment = "test"
        Node        = "managed"
      }
    }
  }
}

data "aws_caller_identity" "current" {}

# Every account that has a vpc deployed should have
# a vpc id and subnets outputed somewhere to a remote state
# so we are just grabbing the subnet id's and vpc id
data terraform_remote_state "vpc" {
  backend = "s3"

  config = {
    bucket         = "itsre-state-517826968395"
    key            = "terraform/deploy.tfstate"
    dynamodb_table = "itsre-state-517826968395"
    region         = "eu-west-1"
  }
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

module "eks" {
  source          = "github.com/mozilla-it/terraform-modules//aws/eks?ref=master"
  cluster_name    = local.cluster_name
  cluster_version = local.cluster_version
  vpc_id          = data.terraform_remote_state.vpc.outputs.vpc_id
  cluster_subnets = data.terraform_remote_state.vpc.outputs.public_subnets
  node_groups     = local.node_groups
  admin_users_arn = ["arn:aws:iam::0123456789:role/maws-admin", "arn:aws:iam::0123456789:role/itsre-admin"]
}
```

## Cluster Add-ons
### Kubernetes External Secrets
[kubernetes-external-secrets](https://github.com/godaddy/kubernetes-external-secrets) allows mapping secrets stored in AWS Secrets Manager to Kubernetes secrets.

In order to allow the process to fetch secrets from the cloud secret store, the setting `external_secrets_prefixes` has to have a list of prefix values where your secrets are stored. This value is then used to create a IAM role with the right permissions.

For example when deploying a cluster for a stage environment, it's a good practice to namespace all the secrets used by the applications in that environment with `/stage/`, so an application could store its secrets in `/stage/my-application/secrets`. In this case the `external_secrets_prefixes` variable should be set to `["/stage/*"]`.

If not set, this will take the default value `*` which will allow kubernetes-external-secrets fetch all secrets in the cluster region.

*Formerly, this variable was a string value in `external_secrets_settings.secrets_path`, but that argument has been deprecated.*

## Inputs

| Name                           | Description                                                                                          | Default      |
|--------------------------------|------------------------------------------------------------------------------------------------------|--------------|
| `region`                       | Region to deploy EKS cluster to                                                                      | `us-west-2`  |
| `cluster_name`                 | Name of cluster identifier (This is required)                                                        | `n/a`        |
| `cluster_version`              | Kubernetes version                                                                                   | `1.14`       |
| `vpc_id`                       | VPC ID to deploy EKS to                                                                              | `n/a`        |
| `cluster_subnets`              | A list of subnets to place the EKS cluster and workers within.                                       | `n/a         |
| `map_roles`                    | Additional IAM roles to add to the aws-auth configmap                                                | `[]`         |
| `map_users`                    | Additional IAM users to add to the aws-auth configmap                                                | `[]`         |
| `map_accounts`                 | Additional AWS account numbers to add to the aws-auth configmap                                      | `[]`         |
| `node_groups`                  | Map of map of node groups to create                                                                  | `{}`         |
| `worker_groups`                | A list of maps defining worker group configurations to be defined using AWS Launch Configurations.   | `{}`         |
| `enable_flux`                  | Enable or disable flux helm operator                                                                 | `false`      |
| `enable_logging`               | Enable kubernetes cluster logging                                                                    | `false`      |
| `enable_velero`                | Creates bucket and sets up velero app on cluster                                                     | `true`       |
| `cluster_autoscaler_settings`  | Map to customize or override default helm chart values for cluster autoscaler                        | `{}`         |
| `velero_settings`              | Map to customize or override default helm chart values for velero                                    | `{}`         |
| `flux_helm_operator_settings`  | Map to customize or override default helm chart values for flux helm operator                        | `{}`         |
| `flux_settings`                | Map to customize or override default helm chart values for flux                                      | `{}          |
| `log_retention`                | Number of days to retain log events                                                                  | `30`         |
| `tags`                         | A map of tags to add to all resources.                                                               | `{}`         |
| `admin_users_arn`              | A list of ARNs to be mapped as global cluster admins.                                                | `[]`         |

## Other documentation

* [terraform-aws-eks-modules](https://github.com/terraform-aws-modules/terraform-aws-eks/)
* [IRSA](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html)
* [Terraform Helm](https://www.terraform.io/docs/providers/helm/r/release.html)
* [Node groups accepted values](https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/modules/node_groups/README.md)
