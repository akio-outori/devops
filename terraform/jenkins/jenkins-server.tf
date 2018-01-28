resource "aws_instance" "jenkins-server" {
  ami             = "${var.ami["centos6"]}"
  instance_type   = "t2.micro"
  subnet_id       = "${var.aws_subnet["east-1a"]}"
  security_groups = ["${aws_security_group.jenkins-server.id}"]
  key_name        = "${var.aws_keypair}"

  provisioner "remote-exec" {
    connection {
      user        = "${var.aws_user}"
      agent       = true
      private_key = "${file("~/.ssh/${var.aws_keypair}")}"
    }

    inline = [
      "sudo yum remove java -y",
      "sudo yum install epel-release -y",
      "sudo yum install wget java-1.7.0-openjdk -y",
      "sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo",
      "sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key",
      "sudo yum install jenkins",
      "sudo service jenkins start",
      "sudo chkconfig jenkins on",
    ]
  }

}

resource "aws_eip" "jenkins-server_ip" {
  instance = "${aws_instance.jenkins-server.id}"
}

output "ip" {
  value = "${aws_eip.jenkins-server_ip.public_ip}"
}
