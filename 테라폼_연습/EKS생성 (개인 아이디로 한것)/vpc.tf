resource "aws_vpc" "main" {
  # vpc 사이더 블럭 설정
  cidr_block = "192.168.0.0/16"

  # 인스턴스를 호스트에서 공유합니다.
  instance_tenancy = "default"

  # EKS에 필요합니다. VPC에서 DNS 지원을 활성화/비활성화합니다.
  enable_dns_support = true

  # EKS에 필요합니다. VPC에서 DNS 호스트 이름을 활성화/비활성화합니다.
  enable_dns_hostnames = true

  # VPC에 대해 ClassicLink를 활성화/비활성화합니다.
  enable_classiclink = false

  # VPC에 대한 ClassicLink DNS 지원을 활성화/비활성화합니다.
  enable_classiclink_dns_support = false

  # VPC에 대한 접두사 길이가 /56인 Amazon 제공 IPv6 CIDR 블록을 요청합니다.
  assign_generated_ipv6_cidr_block = false

  # 리소스에 할당할 태그 맵입니다.
  tags = {
    Name = "main"
  }
}

output "vpc_id" {
  value       = aws_vpc.main.id
  description = "VPC id."
  # 출력 값을 민감하게 설정하면 Terraform이 계획 및 적용에서 해당 값을 표시하지 않습니다.
  sensitive = false
}