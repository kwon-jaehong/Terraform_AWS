


resource "aws_vpc" "eks_vpc" {
  # vpc 사이더 블럭 설정
  cidr_block = "192.168.0.0/16"

  # VPC로 시작된 인스턴스에 대한 테넌시 옵션입니다. 기본값은 default이 VPC에서 시작된 EC2 인스턴스가 EC2 인스턴스가 시작될 때 지정된 EC2 인스턴스 테넌시 속성을 사용하도록 하는 입니다.
  instance_tenancy = "default"

  # EKS에 필요합니다. VPC에서 DNS 지원을 활성화/비활성화합니다.
  enable_dns_support = true

  # EKS에 필요합니다. VPC에서 DNS 호스트 이름을 활성화/비활성화합니다.
  enable_dns_hostnames = true

  # VPC에 대해 ClassicLink를 활성화/비활성화합니다.
  # enable_classiclink = false

  # VPC에 대한 ClassicLink DNS 지원을 활성화/비활성화합니다.
  # enable_classiclink_dns_support = false

  # VPC에 대한 접두사 길이가 ipv6인 Amazon 제공 IPv6 CIDR 블록을 요청합니다.
  assign_generated_ipv6_cidr_block = false

  # 리소스에 할당할 태그 맵입니다.
  tags = {
    Name = "eks"
  }
}

output "vpc_id" {
  value       = aws_vpc.eks_vpc.id
  description = "VPC ID print"
  # 출력 값을 민감하게 설정하면 Terraform이 계획 및 적용에서 해당 값을 표시하지 않습니다.
  sensitive = false
}