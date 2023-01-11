output "gitlab_server_instance" {
    value = aws_instance.gitlab_server_instance.public_ip
}
output "eip_public" {
    value = aws_eip.gitlab_server_instance_eip.public_ip
}
