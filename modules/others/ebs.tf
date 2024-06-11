resource "aws_volume_attachment" "this" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.this.id
  instance_id = module.ec2.id
}

resource "aws_ebs_volume" "this" {
  availability_zone = module.ec2.availability_zone
  size              = 1

  tags = {
    Dev-EBS: "EBS created via Terraform"
  }
}
