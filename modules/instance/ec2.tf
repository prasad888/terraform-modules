provider "aws" {
    region = var.region
  
}

resource "aws_security_group" "test" {
    name = "${var.name}-sg"
    description = "Security group for ${var.name} instances"
    vpc_id = var.vpc_id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }


 egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }   

tags = {
        Name = "${var.name}-sg"
    }
}   


#key pair
resource "aws_key_pair" "bastion_key" {
  key_name   = "${var.envname}-bastion-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC3uF6iGyC5imeutgr7rQfAv3H7ITywzQspXwLfGEwfQrR11oTpEr6Lde3Xk28bCJteecpP2CAq3sCqGosKtiC7T3krKYEM3ETKjV3wKgL0CVm4pK6L3glCBaB6nWjbbDp9B85sp9H1Ll2zoUamOyCROCIWNt1qN87Kv0Ut8qnarm3XEh98VeXkvhYtH/DgHqfyL2Ns1s50h9bBwlFBfr/8EgqoLMvBUSFoHbqOh9CgnRK4wRftQ/qWmkaq+ylhlTm8NKWUjDkLwxUlJ6Pl2vIOEqNilIGm3szjR2kWZa3TzdWNRIIujxNOwr7Dm8WbW+VQ0AlacGBl3DEgQQHKw17exTpoRWsH7KmCmnzRSgdmA5lIuxFDLpWucgASdfkaYOEpSOTmrDY0aONvN+3LjG7NCWL2I3S5d3SU8P8YxXix3qeKweKVE80Pp7Zb0lN39BQI3icNCYVoVtzv+k8x5a+57kNP9VEoudezkg2h0EOZP82YN3q57XkDW61gpOW7pks= c2210733@AMBIN08654"
}

#ec2 instance
resource "aws_instance" "test" {
  ami           = var.ami
  instance_type = var.type
  subnet_id     = var.subnet_id
  key_name      = aws_key_pair.bastion_key.key_name
  security_groups = [aws_security_group.test.id]    
  count = 2
   tags = {
        Name = "${var.envname}-instance-${count.index + 1}"
    }
}
