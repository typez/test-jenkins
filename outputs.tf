output "jenkins_master_private_ips" {
  value = "${join(", ", flatten(aws_network_interface.jenkins_nics.*.private_ips))}"
}

output "jenkins_url" {
  value = "http://${aws_network_interface.jenkins_nics.0.private_ip}:8080"
}
