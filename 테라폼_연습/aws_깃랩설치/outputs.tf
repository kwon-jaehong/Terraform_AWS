## 깃랩 서버 퍼블릭 ip 출력
output "gitlab_server_instance" {
    value = aws_instance.gitlab_server_instance.public_ip
}

# ## 깃랩 엘라스틱 ip 출력
# output "eip_public" {
#     value = aws_eip.gitlab_server_instance_eip.public_ip
# }

## 깃랩 러너 퍼블릭 ip 출력
output "gitlab_runner_instance" {
    value = aws_instance.gitlab_runner_instance.*.public_ip
}


## 템플릿 파일 이용해서 깃랩 관련 인스턴스 ip 출력
# https://stackoverflow.com/questions/45489534/best-way-currently-to-create-an-ansible-inventory-from-terraform
resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/script/inventory.tpl",
    {
        gitlab_server_ip = "${ aws_instance.gitlab_server_instance.public_ip}"
        gitlab_runner_ip = aws_instance.gitlab_runner_instance.*.public_ip
    }
  )
  filename = "./aws.inv"
}



# data "template_file" "inventory" {
#     template = "${file("script/inventory.tpl")}"

#     vars =  {
#         gitlab_server_ip = "${ aws_instance.gitlab_server_instance.public_ip}"
#         gitlab_runner_ip = aws_instance.gitlab_runner_instance.*.public_ip

#     }
# }
# resource "null_resource" "update_inventory" {
#     triggers = {
#         template = "${data.template_file.inventory.rendered}"
#     }
#     provisioner "local-exec" {
#         command = "echo '${data.template_file.inventory.rendered}' > ./aws.inv"
#     }
# }