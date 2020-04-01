# velero-bucket
Creates a velero s3 bucket with a standard naming convention and tagging, also has the option of creating
an IAM user or creating an IAM role for service accounts.

Naming convention are as follows:

 - bucket: `<bucket_name>-<cluster_name>-<aws account id>`
 - IAM User: `<backup user name>-<cluster_name>`
 - IAM Role: `<backup user name>-<cluster_name>-role`

## Usage:
```
module "velero"  {
  source       = "github.com/mozilla-it/terraform-modules//aws/velero-bucket?ref=master
  cluster_name = "my-cluster"
  create_role  = true
}
```

Currently both `create_user` is configured to default to `false` and the preferred method of granting IAM
access to the S3 bucket is via a role. Newer versions of EKS now has the ability to annotate a Service Account
with an IAM role to grant the pod or deployment IAM access to the S3 bucket. However if you don't wish to do
grant access this way you can set `create_user` to `true` and `create_role` to `false` and it will create an
IAM access key pair for you to use for the deployment.

## Other documentation
[IAM Roles for Service Accounts](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html)
[Velero Helm Chart](https://github.com/vmware-tanzu/helm-charts/tree/master/charts/velero)
