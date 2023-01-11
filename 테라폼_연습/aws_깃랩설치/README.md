
1. AWS ami 유저 생성, 권한 설정 및 엑세스키, 시크릿키 발급

------------------
- AWS ec2에 접속할 키 생성
로컬 컴퓨터에서 ssh-keygen [키이름]을 이용해 ec2인스턴스에 접속할 키페어를 만든다
```
ssh-keygen -f mykey
```
엔터 2번

openssl rsa -in mykey -text > mykey.pem

---------------------------------
엔서블 명령어
ansible -i aws.inv -m ping all --private-key  ./key_file/mykey -u ubuntu 