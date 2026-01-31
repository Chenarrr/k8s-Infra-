output "master_ip" {
  description = "IP address of the master node"
  value       = multipass_instance.k8s-master.ipv4[0]
}

output "worker1_ip" {
  description = "IP address of worker1 node"
  value       = multipass_instance.k8s-worker1.ipv4[0]
}

output "worker2_ip" {
  description = "IP address of worker2 node"
  value       = multipass_instance.k8s-worker2.ipv4[0]
}

output "master_ssh_user" {
  description = "SSH username for master node"
  value       = "ubuntu"
}

output "worker_ssh_user" {
  description = "SSH username for worker nodes"
  value       = "ubuntu"
}

output "node_roles" {
  description = "Roles of each node"
  value = {
    master  = "control-plane"
    worker1 = "worker"
    worker2 = "worker"
  }
}
