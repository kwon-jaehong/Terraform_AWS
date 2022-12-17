프로비저닝 : 사용자의 요구에 맞게 시스템 자원을 할당, 배치, 배포해 두었다가 필요 시 시스템을 즉시 사용할 수 있는 상태로 미리 준비해 두는 것을 말한다.

테라폼은 AWS CLI를 인증하면 따로 넣지 인증서를 넣지 않아도 사용 가능

내 공인 ip 알기 
nslookup myip.opendns.com resolver1.opendns.com
Server:         resolver1.opendns.com
Address:        208.67.222.222#53

Non-authoritative answer:
Name:   myip.opendns.com
Address: 118.176.134.211 (이거임)

----------------------------------------
테라폼 워크 스페이스

워크스페이스란? 한 프로젝트 단위

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

--------------------------
https://jybaek.tistory.com/899

providers, resource, data, module 등을 묶어서 뭐라고 표현해야 할지 잘 모르겠습니다. 예약어, 키워드 등으로 볼 수 있을 텐데 여기서는 키워드라고 통칭하도록 합니다. 이번 글에서는 테라폼에서 통용되는 키워드를 하나씩 살펴보도록 합니다.

# providers
테라폼은 docker, AWS, GCP 등 2021년 02월 기준으로 700개가 넘는 다양한 프로바이더를 제공합니다. 
일종의 플랫폼 키워드

# resource
플랫폼에서 가용할 수 있는 자원 (AWS라면 aws_vpc ,aws_subnet 등이 있다.)

# normal variables
일반변수는 그냥 일반 변수다.

# output
리소스 출력용 아웃풋 키워드, 테라폼 모듈이 실행되고 나서 출력/저장하고 싶은 값을 명시하는 부분이다.

# data source
data는 Data Source, 즉 정보를 가져오는 곳을 정의한다. 그리고 data가 읽을 수 있는 정보의 출처는 매우 다양하다. provider(가령 AWS)에서 나왔을 수도 있고 내가 입력한 값을 가공해서 나왔을 수도 있고 remote state를 읽어서 나왔을 수도 있다.
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






