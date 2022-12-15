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

-------------------------------------------------------------




