resource "aws_ecr_repository" "tf-created-ecr" {
  name                 = "tf_created_ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
