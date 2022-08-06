terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_kubernetes_cluster" "k8s_kubenews" {
  name   = var.k8s_name
  region = var.k8s_region
  version = "1.22.8-do.1"

  node_pool {
    name       = "default"
    size       = "s-2vcpu-2gb"
    node_count = 1
  }
}

resource "digitalocean_kubernetes_node_pool" "node_deafult" {
  cluster_id = digitalocean_kubernetes_cluster.foo.id
  name       = "default"
  size       = "c-2"
  node_count = 1
}

variable "do_token" {}
variable "k8s_name" {}
variable "k8s_region" {}

output "kube_config" {
  value = digitalocean_kubernetes_cluster.k8s_kubenews.kube_config.0.raw_config
}

resource "local_file" "kube_config" {
    content = digitalocean_kubernetes_cluster.k8s_kubenews.kube_config.0.raw_config
    filename = "kube_config.yaml"
  
}