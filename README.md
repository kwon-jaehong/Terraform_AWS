프로비저닝 : 사용자의 요구에 맞게 시스템 자원을 할당, 배치, 배포해 두었다가 필요 시 시스템을 즉시 사용할 수 있는 상태로 미리 준비해 두는 것을 말한다.

내 공인 ip 알기 
nslookup myip.opendns.com resolver1.opendns.com
Server:         resolver1.opendns.com
Address:        208.67.222.222#53

Non-authoritative answer:
Name:   myip.opendns.com
Address: 118.176.134.211 (이거임)

----------------------------------------
테라폼 상태파일 내 오브젝트 현황 확인
terraform state list

테라폼 콘솔 접속
terraform console
-> var.myvar(변수이름) or "${var.myvar}"

테라폼은 map,list 방식의 변수를 선언할 수 있고, 슬라이싱도 가능함(1.tf 파일 참조)

terraform.tfvars 파일을 이용해서 변수를 미리 선언해 줄수 있음, 그리고 apply할때는 참조 파일 써주면 됨
terraform apply -var-file="terraform.tfvars"


Terraform은 현재 디렉토리에 있는 모든 .tf 파일을 읽는다.
-> 이름따위는 상관없음


aws 공급자를 이용하기 위해서는 맨처음 초기화를 먼저 해줘야 한다
-> 플러그인, 새로운 공급자들을 사용할 떄마다 초기화를 무조건 시켜 줘야함
terraform init

테라폼 적용 & 파괴는
terraform apply
terraform destroy

------------------------------------------
테라폼 변수 유형

string
number
bool

list(type)
-> [1,9,5,2]
-> ! 리스트 항상 반환은 큰숫자 부터 반환됨 [9,5,2,1]

키:벨류로 구성
map(type)
->{"key"="value"}

set(type)
-> 은 리스트와 비슷하지만 유니크한 값들만 저장됨(파이썬 셋 객체랑 같음)
-> [5,1,1,1,2]라면 [1,2,5]가 반환됨, 리스트와 다르게 정렬이 되진 않음

object
-> 는 그냥 배열 같은 것임
{
    name="jahong"
    pthon_numer =010223142
}


tuple([])
-> 리스트와 같지만, 서로 다른 타입의 자료를 가질 수 있음
[0,"sting",false]

-----------------------------------------------
map 에서 키를 찾는 lookup함수
variable "availability_zones" {
  type = "map"
  default = {
    "eu-west-1" = "eu-west-1a,eu-west-1b,eu-west-1c"
    "us-west-1" = "us-west-1b,us-west-1c"
    "us-west-2" = "us-west-2a,us-west-2b,us-west-2c"
    "us-east-1" = "us-east-1c,us-west-1d,us-west-1e"
  }
}
> lookup(var.availability_zones, "us-east-1")
us-east-1c,us-west-1d,us-west-1e
------------------------------------------------------
소프트웨어 프로비저닝 -> 이미지에서 소프트웨어 설치
provisioner로 설정한다
예시)
resource "aws_instance" "example1" {
    ## ami는 ec2를 생성할때 사용할 이미지
    ami = "ami-003bb1772f36a39a3"
    instance_type = "t2.micro"
    ## aws 키페어 리소스에서 키네임을 가져오겠다
    key_name = "&{aws_key_pair.jaehong-key.key_name}"
    provisioner "file" {
    source = "script.sh"
    destination = "/opt/script.sh"
    connetion {
        user = "${var.instance_username}"
        password = "${file(${var.path_to_private_key})}"
    }}
}
인스턴스를 생성할때 provisioner를 통해 커넥션하고 파일을 옮기고, 함
-> 생성할때 커넥트 키설정 등 다 할수 있고, 윈도우도 소프트웨어 프로비저닝 가능함

-------------------------------------------------------------
속성 출력

아웃풋을 이용해 출력 할 수도 있고
output "ip" {
  value = "${aws_instance.example1.pulic_ip}"
}

provicioner를 이용해 출력 할 수도 있다
provisioner "local-exec" {
  command = "echo ${aws_instance.example1.private_ip} >> private.txt"
}
내 로컬 컴퓨터(테라폼 실행)에 private.txt 파일이 생성됨 

------------------------------------------------------
원격상태
원격 상태는 terraform.tfstate에 저장된다, terraform apply를 실행할때 state와 backup이 디스크에 생성된다
이 파일들을 이용해 원격상태를 추적한다 -> 왜? 협업할때 git이랑 비슷, 한 테라폼파일을 가지고 충돌이 일어날수 있기 떄문

협업할떄이므로 이강의는 좀 패스
-------------------------------------------------------

데이터 리소스
예) AMIs 리스트라던지, AWS 사용가능한 존 목록 등
응용) 특정 IP 필터링 

securitygroup.tf 를 어플라이 하면 보안그룹이 생성됨
![](vscode-remote://ssh-remote%2Bmrjaehong.synology.me/home/mrjaehong/Terraform_AWS/md_image/Screenshot%20from%202022-12-16%2010-27-12.png)

---------------------------------------------------
모듈-> 다른 테라폼 폴더 연계, 클래스 또는 파이썬 패키지와 비슷

module "module-exmaple" {
  ## 모듈 로드할 주소
  source = "깃헙 주소 폴더"
  또는 source = "../tf2"

  ## 모듈에 인수 전달
  region = "us-west-2"
  ip-range = "10.2.2.2/8"
  기타 등등
}

모듈 변수 사용 예시
output "some-output" {
  value = "$module.module-exmaple.모듈에서 제공하는 output객체"
}


--------------------------------------------------
테라폼 명령어 개요 
apply -> 테라폼 실행
destroy -> 실행한것들 파괴
fmt -> 테라폼 구성 파일을 표준 형식 및 스타일로 다시 작성
--> 예시) terraform fmt eoeo.tf  칸띄우기,

get -> 모듈 다운이나 업데이트
graph -> 시각적 표현을 하기 위함, 인프라내 종속성을 이해하기 편리함
--> png .dot형식으로도 볼수 있음

output [옵션] [이름] -> 리소스 출력,출력형태
plan -> dry apply (진짜 실행이 아니라 실행전 한번 검토)
show -> 테라폼의 상태 또는 계획에서 사람이 읽을 수 있는 출력물을 보여줌 (반드시 apply를 한상태, 살아있는 상태여야함)
state -> 태라폼 상태 체크

taint -> 테라폼 리소스에 문제가 있는 경우, 재 초기화, reset과 비슷함, 
--> terraform taint aws_instance.example 하면, apply되어있어도 ec2가 다시 생성할수 있게함
--> 다시 apply 해야됨

validate -> syntax 검증
untaint -> taint를 undo (취소)
import [옵션] ADDRESS ID -> 자원 정보를 가져옴
--> terraform import aws_instance.foo i-abcd1234
--> 왜냐면 AWS는 apply하기 전까지 자원을 볼수가 없기 때문임


push -> git이랑 비슷 (하시코프 엔터프라이즈에서 사용 가능)
refresh -> 원격 상태를 새로 고침
remote -> 원격상태를 바라보는거, 이것도 git remote랑 비슷함

-----------------------------------------------------------
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




