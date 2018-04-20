
/*
 * EIPs are here just to make the task a bit nore interesting.
 *
 * Second EIP is assigned to an instance just to show a basic example of how TF
 * counts could be used.
 *
 * It totally makes sense to create a Route53 CNAME for the Jenkins instance
 * IP, but creating a Hosted Zone for the test seems to be too much :)
 */
resource "aws_network_interface" "jenkins_nics" {

  count = 2

  subnet_id = "${var.subnet_id}"
  security_groups = ["${aws_security_group.jenkins_master.id}"]

  tags {
    ResourceGroupName = "${var.rg_name}-resource-group"
  }
}

resource "aws_instance" "jenkins_master" {

  ami = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_name}"

  root_block_device {
    volume_type = "gp2"
    volume_size = "${var.root_volume_size_gb}"
  }

  network_interface {
     network_interface_id = "${aws_network_interface.jenkins_nics.*.id[0]}"
     device_index = 0
  }

  network_interface {
     network_interface_id = "${aws_network_interface.jenkins_nics.*.id[1]}"
     device_index = 1
  }

  tags {
    Name = "myTestJeninsMaster"
    ResourceGroupName = "${var.rg_name}-resource-group"
  }

  user_data = "${file("${path.module}/provision_jenkins.sh")}"

}
