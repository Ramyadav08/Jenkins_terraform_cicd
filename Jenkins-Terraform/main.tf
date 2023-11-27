resource "aws_instance" "webserver1" {
  ami           = var.imageid
  instance_type = var.instancetype
  key_name      = aws_key_pair.terraform-key.key_name

  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  user_data =  file("${path.module}/install.sh")


  tags = {
    Name = "Jenkins"
  }

  root_block_device {
    volume_size = 30
  }
}