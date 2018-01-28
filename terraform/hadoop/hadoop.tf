resource "aws_instance" "hadoop" {
  ami             = "${var.ami["centos6"]}"
  instance_type   = "t2.micro"
  subnet_id       = "${var.aws_subnet["east-1a"]}"
  security_groups = ["${aws_security_group.hadoop.id}"]
  key_name        = "${var.aws_keypair}"
}

resource "aws_eip" "hadoop_ip" {
  instance = "${aws_instance.hadoop.id}"
}

output "ip" {
  value = "${aws_eip.hadoop_ip.public_ip}"
}
