eks 서브넷
https://pseonghoon.github.io/post/eks-subnet/

https://docs.aws.amazon.com/eks/latest/userguide/network_reqs.html

https://aws.github.io/aws-eks-best-practices/networking/subnets/


https://aws.github.io/aws-eks-best-practices/networking/subnets/
-------------------------------------------------------------------------

EKS는 기본적으로 CNI(컨테이너 네트워크 인터페이스)가 설칙가 되어 있다.
-> 칼리코,플라넬처럼 쿠버네티스에서 따로 설치할 필요가 없다!!!


VPC 설계를 시작하거나 기존 VPC에 클러스터를 배포하기 전에 EKS 컨트롤 플레인 통신 메커니즘을 이해하는 것이 좋습니다.
EKS 클러스터는 두 개의 VPC로 구성됩니다.

Kubernetes 컨트롤 플레인을 호스팅하는 AWS 관리 VPC. 이 VPC는 ​​고객 계정에 나타나지 않습니다.
-> EKS 마스터 서버의 VPC는 AWS에서 관리하며, 계정에서도 볼수 없음

여기에서 컨테이너는 물론 클러스터에서 사용하는 로드 밸런서와 같은 기타 고객 관리형 AWS 인프라도 실행됩니다. (퍼블릭)
VPC를 제공하지 않으면 eksctl이 VPC를 생성합니다.

![](vscode-remote://ssh-remote%2Bmrjaehong.synology.me/home/mrjaehong/Terraform_AWS/md_image/Screenshot%20from%202023-01-13%2018-10-11.png)


노드는 (a) EKS 퍼블릭 엔드포인트 또는 (b) EKS에서 관리하는 교차 계정 탄력적 네트워크 인터페이스 (X-ENI) 를 통해 EKS 컨트롤 플레인에 연결됩니다 . (자동 연결인듯)
EKS는 클러스터 생성 중에 지정된 각 서브넷(클러스터 서브넷이라고도 함)에 X-ENI를 배치합니다. Kubernetes API 서버는 이러한 교차 계정 ENI를 사용하여 고객 관리형 클러스터 VPC 서브넷에 배포된 노드와 통신합니다.

노드가 시작되면 EKS 부트스트랩 스크립트가 실행되고 Kubernetes 노드 구성 파일이 설치됩니다. 각 인스턴스의 부팅 프로세스의 일부로 컨테이너 런타임 에이전트, kubelet 및 Kubernetes 노드 에이전트가 시작됩니다.


엔드포인트의 뜻은 2가지 이다.
https://aws.amazon.com/ko/what-is/endpoint-security/
엔드포인트는 네트워크에 연결하고 네트워크를 통해 통신하는 모든 디바이스를 말합니다. 다른 컴퓨팅 디바이스를 네트워크에 연결하는 스위치와 라우터도 엔드포인트로 간주됩니다.

Endpoint란 API가 서버에서 자원(resource)에 접근할 수 있도록 하는 URL입니다.


퍼블릭 엔드포인트¶
이는 새 Amazon EKS 클러스터의 기본 동작입니다. 클러스터에 대한 퍼블릭 엔드포인트만 활성화된 경우 클러스터의 VPC 내에서 발생하는 Kubernetes API 요청(예: 제어 플레인 통신에 대한 작업자 노드)은 Amazon 네트워크가 아닌 VPC를 떠납니다. 노드가 컨트롤 플레인에 연결하려면 퍼블릭 IP 주소와 인터넷 게이트웨이에 대한 경로 또는 NAT 게이트웨이의 퍼블릭 IP 주소를 사용할 수 있는 NAT 게이트웨이에 대한 경로가 있어야 합니다.

퍼블릭 및 프라이빗 엔드포인트¶
퍼블릭 엔드포인트와 프라이빗 엔드포인트가 모두 활성화되면 VPC 내에서 Kubernetes API 요청이 VPC 내 X-ENI를 통해 컨트롤 플레인과 통신합니다. 클러스터 API 서버는 인터넷에서 액세스할 수 있습니다.

프라이빗 엔드포인트¶
프라이빗 엔드포인트만 활성화된 경우 인터넷에서 API 서버에 대한 퍼블릭 액세스가 없습니다. 클러스터 API 서버에 대한 모든 트래픽은 클러스터의 VPC 또는 연결된 네트워크 내에서 나와야 합니다. 노드는 VPC 내의 X-ENI를 통해 API 서버와 통신합니다. 클러스터 관리 도구는 개인 끝점에 대한 액세스 권한이 있어야 합니다. Amazon VPC 외부에서 프라이빗 Amazon EKS 클러스터 엔드포인트에 연결하는 방법에 대해 자세히 알아보십시오 .

-> 퍼블릭 앤드포인트 접근, 쿠버네티스 마스터 서버에 공인 IP를 이용해서 접속,
-> 프라이빗 엔드포인트 , X-ENI를 사용하여 쿠버네티스 마스터 노드와 통신


Amazon EKS는 지정한 서브넷에 최대 4개의 교차 계정(x-account 또는 x-ENI) ENI를 생성합니다. x-ENI는 항상 배포되며 로그 전달, exec 및 프록시와 같은 클러스터 관리 트래픽에 사용됩니다.

Kubernetes 작업자 노드는 클러스터 서브넷에서 실행할 수 있지만 권장되지 않습니다. 노드 및 Kubernetes 리소스를 실행하기 위한 전용 새 서브넷을 생성할 수 있습니다. 노드는 퍼블릭 또는 프라이빗 서브넷에서 실행할 수 있습니다. 




