resource "aws_eip" "gitlab_server_instance_eip" {
  instance = aws_instance.gitlab_server_instance.id
  vpc = true
  
}
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.gitlab_server_instance.id
  allocation_id = aws_eip.gitlab_server_instance_eip.id
}
