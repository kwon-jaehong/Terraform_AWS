AWS 네트워킹 서비스

aws Route 53
-> DNS 웹서비스

AWS ELB (엘라스틱 로드벨런스)
-> 부하분산(로드밸런싱 서비스)

AWS VPC
-> 가상 네트워크를 클라우드 내에 생성/구성

AWS Direct connect
-> 온프라미스 인프라와 AWS를 연결하는 네트워킹 서비스

![](vscode-remote://ssh-remote%2Bmrjaehong.synology.me/home/mrjaehong/Terraform_AWS/md_image/Screenshot%20from%202022-12-16%2014-46-48.png)

----------------------------------------------------------
VPC 기초

특징
- 계정생성시 default로 VPC를 만들어줌
- EC2,RDS,s3등 서비스 활용 및 연결 가능
- 서브넷 구성
- 보안 설정(ip 블럭, 인바운드,아웃바운드 설정 등)
- vpc peering(vpc간의 연결)
- IP 대역 지정 가능?
- VPC는 하나의 리전에만 속 할 수 있음(다른 리전으로 확장 불가능)


그림은 VPC예시이다, VPC안에서 서브넷으로 나눈 2영이 보일 것이다(퍼블릭,프라이빗)

![](vscode-remote://ssh-remote%2Bmrjaehong.synology.me/home/mrjaehong/Terraform_AWS/md_image/Screenshot%20from%202022-12-16%2016-06-02.png)
ROute Table(루트테이블)은 VPC내에 존재하는 객체들끼리 통신하기위한 테이블 (일종의 해쉬테이블 인듯?)
NACL(나클)은 VPC 서브넷의 보안을 담당함


VPC 구성 요소
- availability zone (가용 영역)
- subnet (CIDR)
- 인터넷 게이트웨이
- network access control list/security group (나클)
- route table
- nat(network address translation instance/nat gateway)
- vpc endpoint



































