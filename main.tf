terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

variable "do_token" {
  default = ""
}

provider "digitalocean" {
  version = "2.0.0"
  token   = var.do_token
}

resource "digitalocean_kubernetes_cluster" "k8s" {
  name    = "k8s"
  region  = "nyc3"
  version = "1.25.4-do.0"

  node_pool {
    name       = "default"
    size       = "s-2vcpu-4gb"
    node_count = 3
  }
}

resource "local_file" "kubeconfig" {
  content  = digitalocean_kubernetes_cluster.k8s.kube_config.0.raw_config
  filename = "digitalocean_k8s_kubeconfig.yaml"
}