resource "aws_instance" "rpm-build" {
  ami             = "${var.ami}"
  instance_type   = "t2.micro"
  subnet_id       = "${var.aws_subnet}"
  security_groups = ["${var.security_groups}"]
  key_name        = "${var.aws_key}"

  provisioner "remote-exec" {
    connection {
      user        = "ec2-user"
      agent       = true
      private_key = "/Users/akio_outori/.ssh/${var.aws_key}"
    }
    inline = [
      "sudo rm -rf ~/*",
      "sudo rm -rf /data",
      "sudo mkdir -p /data && sudo chown ec2-user:ec2-user /data",
      "sudo yum -y update",
      "sudo yum -y install epel-release",
      "sudo yum groupinstall 'Development Tools' -y",
      "sudo yum install readline-devel openssl-devel expat-devel ncurses-devel unzip pcre-devel rpm-build -y",
      "yum install -y https://packages.chef.io/stable/el/6/chefdk-0.16.28-1.el6.x86_64.rpm",
      "yum install -y gmp-devel xmlstarlet",
      "ln -s /usr/lib64/libgmp.so.3  /usr/lib64/libgmp.so.10",
      "cd ~/",
      "wget https://haskell.org/platform/download/7.10.2/haskell-platform-7.10.2-a-unknown-linux-deb7.tar.gz",
      "tar xvzf ~/haskell-platform-7.10.2-a-unknown-linux-deb7.tar.gz",
      "~/install-haskell-platform.sh",
      "cabal update",
      "cabal install shellcheck",
      "cp ~/.cabal/bin/shellcheck /usr/local/bin"
    ]
  }

  tags {
    Name = "DF RPM Build"
  }
}

resource "aws_eip" "rpm-build_eip" {
  instance = "${aws_instance.rpm-build.id}"
}

output "rpm-build_eip" {
  value = "${aws_eip.rpm-build_eip.public_ip}"
}
