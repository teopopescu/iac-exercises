/* 
ELB with 3 instances in existing VPC

*/


# load_balancer.tf
resource "aws_lb" "main" {
  name               = "tf-exercise-lb" 
  internal           = false
  load_balancer_type = "application" 
  security_groups    = [module.security_group.security_group_id] 
  subnets            =  aws_subnet.my_subnet[*].id
}

resource "aws_lb_target_group" "main" {
  name     = "tf-exercise-elb-tg-test" 
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn 
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

# ec2_instances.tf
resource "aws_instance" "example" {
  count         = 3
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = element(aws_subnet.my_subnet[*].id, count.index)
  security_groups = [module.security_group.security_group_id]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              sudo systemctl start httpd
              sudo systemctl enable httpd
              echo "Hello World from $(hostname -f)" > /var/www/html/index.html
              EOF

  tags = {
    Name = "example-instance-${count.index}"
  }
}

# Attach instances to the target group
resource "aws_lb_target_group_attachment" "example" {
  count            = 3
  target_group_arn = aws_lb_target_group.main.arn #  change
  target_id        = element(aws_instance.example[*].id, count.index) #  change
  port             = 80
}
