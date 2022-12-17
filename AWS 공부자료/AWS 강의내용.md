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
- subnet (CIDR), 크게 2가지로 인터넷 접근이 가능한 퍼블릭 서브넷, 불가능한 프라이빗 서브넷으로 나누어짐
- 인터넷 게이트웨이 (VPC 내부 인스턴스들이, 외부 인터넷과 소통이 필요할때 쓰는 매게체)
- network access control list/security group (나클)
- route table
- nat(network address translation instance/nat gateway)
- vpc endpoint

![](vscode-remote://ssh-remote%2Bmrjaehong.synology.me/home/mrjaehong/Terraform_AWS/md_image/Screenshot%20from%202022-12-16%2016-21-18.png)

-------------------------------------------------------
AWS vpc

이때까지 생성된 인스턴스들은 AWS에서 제공하는 defalut VPC로 생성되었다.
VPC는 네트워크 레벨상의 인스턴스들을 격리합니다, 이것은 클라우드에서 개인 네트워크와 같은 개념이다
% 디지털 오션 같은 클라우드 업체는 VPC서비스가 없고, 하나의 큰 네트워크만 제공된다.

왜 VPC설정이 중요한가?
-> 하나의 큰 네트워크에서 어떤 일부 서비스에 엑세스 해서는 안되는 경우에도 엑세스 한다던지, 충돌 등 문제가 발생 할 수 있음

기본적으로 or 아무 조건이 없는 상태라는 가정 -> A라는 VPC에서 시작된 인스턴스는 개인 ip 주소를 사용해서 다른 VPC의 인스턴스와 소통할 수 없음
-> 권장되지 않는 공용 IP를 통해서 소통이 가능, 또는 두 VPC를 연결 하는 방법(VPC 피어링)

AWS에서는 인스턴스나, DB를 생성시 VPC를 생성해서 시작함

VPC를 설정 할때마다, 사용할 수 있는 IP주소를 서브넷이라고 함
-> 서브넷  또는 IP주소는 인터넷에서 사용할 수 없다 (외부에서 접근 불가능)
-> 서브넷이란? 말그대로, 서브 + 넷, 가용할 수 있는 인터넷 주소 범위를 잘라서 쓰겟다임

퍼블릭 서브넷은 공통적인 인터넷 게이트 웨이를 가진다 (외부에 노출할 수 있는 IP를 가질수 있다)
프라이빗 서브넷은 인터넷 게이트웨이와 연결이 안되므로, 외부에서 연결할수 없음 (내부에서 같은 zone, 이건 그림 참조해야됨)



-----------------------------------------------------------
route 테이블
트래픽이 어디로 가야할지 알려주는 테이블
![](vscode-remote://ssh-remote%2Bmrjaehong.synology.me/home/mrjaehong/Terraform_AWS/md_image/Screenshot%20from%202022-12-16%2016-38-41.png)

타겟이 로컬이다 (VPC 내부로 가라)
local 뺴고 나머지는 인터넷으로 가라

-----------------------------------------------------
NACL/보안 그룹
둘다 다름

![](vscode-remote://ssh-remote%2Bmrjaehong.synology.me/home/mrjaehong/Terraform_AWS/md_image/Screenshot%20from%202022-12-16%2016-41-57.png)

nacl은 stateless한 보안이다
security group(sg)는 stateful한 보안이다

access block이란 
특정 ip 대역을 인바운드 아웃드는 nacl에서만 가능하다
그림에서 보안그룹이 안보이는 이유는... VPC의 자체 설정값이라 보면 된다.

----------------------------------------------------------------------------------
NAT (network address translation) instance / gateway


프라이빗 서브넷에 올려진 프로그램이나 역활은 주로 노출되지 말아야할 DB가 들어간다
그런데 DB를 업데이트 해야되는데.... 프라이빗 서브넷은 인터넷이 안되므로 업데이트나 다운을 못함

예시) 프라이빗 서브넷에서 인터넷을 하기위해 퍼블릭서브넷 내에 어떠한 인스턴스(대리인)을 통해 통신

그래서 nat 인스턴스나 게이트웨이를 통해 통신하는 서비스, 둘의 차이라면, nat게이트 웨이는 aws에서 제공하는 편리한 소프트웨어고, 인스턴스는 직접 ec2를 올려서 중계해주는 셋팅을 해줘야한다.

![](vscode-remote://ssh-remote%2Bmrjaehong.synology.me/home/mrjaehong/Terraform_AWS/md_image/Screenshot%20from%202022-12-16%2016-47-47.png)

![](vscode-remote://ssh-remote%2Bmrjaehong.synology.me/home/mrjaehong/Terraform_AWS/md_image/Screenshot%20from%202022-12-16%2016-54-41.png)


-----------------------------------------------------
bastion host (베스치안 호스트)

-> 외부에서 private 서브넷에 접근하기 위한 개념 (nat랑 반대되는개념)
-> 퍼블릭에 존재하는 ec2임 
![](vscode-remote://ssh-remote%2Bmrjaehong.synology.me/home/mrjaehong/Terraform_AWS/md_image/Screenshot%20from%202022-12-16%2016-57-54.png)

---------------------------------------------------
vpc endpoint

AWS 공식 설명
![](vscode-remote://ssh-remote%2Bmrjaehong.synology.me/home/mrjaehong/Terraform_AWS/md_image/Screenshot%20from%202022-12-16%2016-59-31.png)
![](vscode-remote://ssh-remote%2Bmrjaehong.synology.me/home/mrjaehong/Terraform_AWS/md_image/Screenshot%20from%202022-12-16%2017-01-14.png)

private 서브넷은 원래 인터넷 밖으로도 못나감, -> 그래서 AWS 다양한 서비스와도 연결이 안됨
하지만! vpc 엔드 포인트를 이용하면, AWS 제품만 연결 할 수 있도록 지원하는 서비스


인터페이스 엔드포인트 예시
![](vscode-remote://ssh-remote%2Bmrjaehong.synology.me/home/mrjaehong/Terraform_AWS/md_image/Screenshot%20from%202022-12-16%2017-04-05.png)

게이트 웨이 엔드포인트 예시
![](vscode-remote://ssh-remote%2Bmrjaehong.synology.me/home/mrjaehong/Terraform_AWS/md_image/Screenshot%20from%202022-12-16%2017-04-19.png)

---------------------------
실습

VPC를 생성시.. (VPC와,라우팅 테이블,네트워크ACL만 생성된다)
-> 네트워크 억세스 컨트롤 리스트가 왜 자동으로 생성되나? VPC에 대한 아주 최소의 설정파일이니까...

서브넷, 인터넷 게이트웨이,엔드포인트 등은 자동적으로 만들어 주지 않는다 (왜? 둘다 설정값이 들어가야 하기 때문에)

라우팅 테이블이 2개로 설정함
VPC 생성 -> 서브넷 생성 -> 인터넷 게이트웨이 생성 & VPC와 연결 ->  라우팅 테이블 생성 & 서브넷과 라우팅테이블 연결 -> 라우팅 편집

<!-- CH01_08. (VPC) Internet Gateway과 라우팅 테이블 생성 -->
다시보자














