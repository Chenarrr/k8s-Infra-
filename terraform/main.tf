
terraform {
  required_providers {
    multipass = {
      source  = "camptocamp/multipass"
      version = ">= 0.1.0"
    }
  }
}

provider "multipass" {}

resource "multipass_instance" "k8s-master" {
  name   = "k8s-master"
  cpus   = var.cpus
  memory = var.memory
  disk   = var.disk
  image  = var.image
}

resource "multipass_instance" "k8s-worker1" {
  name   = "k8s-worker1"
  cpus   = var.cpus
  memory = var.memory
  disk   = var.disk
  image  = var.image
}

resource "multipass_instance" "k8s-worker2" {
  name   = "k8s-worker2"
  cpus   = var.cpus
  memory = var.memory
  disk   = var.disk
  image  = var.image
}
