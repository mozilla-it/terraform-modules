# flux
Installs fluxcd and flux helm operator using terraform,  to make this module work you will need to include a couple of providers
in order for this to work

## Usage
In order to get helm chart installed on your charts installed you need to use the helm provider and here is an example on
how to set this up for AWS and GCP

Example setup for AWS
```hcl
data "aws_eks_cluster" "cluster" {
  name = "your-cluster-name"
}

data "aws_eks_cluster_auth" "cluster" {
  name = "your-cluster-name"
}

provider "helm" {
  version = "~> 1"

  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
    load_config_file       = false
  }
}

module "flux" {
  source = "github.com/mozilla-it/terraform-modules//helm/flux?ref=master
  flux_settings = {
    "git.url"  = "git@github.com:username/repo"
    "git.path" = "folder"
  }
}
```

Example setup for GCP
```hcl
data "google_container_cluster" "cluster" {
  name  = "my-cluster-name"
}

data "google_client_config" "current" {
}

provider "helm" {
  version = "~> 1"

  kubernetes {
    host                   = data.google_container_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.google_container_cluster.cluster.master_auth.0.cluster_ca_certificate)
    client_key             = base64decode(data.google_container_cluster.cluster.master_auth.0.client_key)
    client_certificate     = base64decode(data.google_container_cluster.cluster.master_auth.0.client_certificate)
    token                  = data.google_client_config.current.access_token
    load_config_file       = false
  }
}

module "flux" {
  source = "github.com/mozilla-it/terraform-modules//helm/flux?ref=master
  flux_settings = {
    "git.url"  = "git@github.com:username/repo"
    "git.path" = "folder"
  }
}
 ```

## Inputs
Default values of each input can be found in the [locals.tf](https://github.com/mozilla-it/terraform-modules/blob/master/helm/flux/locals.tf) file and if you want to override
the default settings all you have to create a map of the value you to override as an example

Example of overriding namespace:
```hcl
locals {
  flux_settings = {
    "namespace" = "kube-system"
    "git.url"   = "git@github.com:username/repo"
    "git.path"  = "folder"
  }
}

module "flux" {
  source        = "github.com/mozilla-it/terraform-modules//helm/flux?ref=master
  flux_settings = local.flux_settings
}
```

## Other links
* [Flux helm operator chart configuration values](https://github.com/fluxcd/helm-operator/tree/master/chart/helm-operator#configuration)
* [Flux chart configuration values](https://github.com/fluxcd/flux/tree/master/chart/flux#configuration)
