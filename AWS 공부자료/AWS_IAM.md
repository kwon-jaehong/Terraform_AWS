패캠 강의

identity access management 의 약자
AWS 리소스 접근제어

AWS 리소스 접근에는 3가지 방법이 있다.
1. root 계정
2. IAM (콘솔이나 AWS API를 통해 접근)
3. STS (security token service) - 토큰의 라이프 타임이 있다.

IAM 정책의 종류
1. SCP (service control policy) 
- AWS  organizations 내 정책
- 그룹핑 기능인듯

2. permission policy, permission boundary
-  IAM 유저, 롤에 대한 정책 (우리가 대부분 알고있는 권한들)

3. session policy
- sts, federration 시 권한 제어

4. resource-based policy
- identity가 아니라 resource 자체에 권한 제어
- 쉽게말하면 어느 ec2에 정책을 먹여서, s3에 자유롭게 접근 (id 기반의 정책이 아니다!!!) 
- 즉, 리소스 자체에 권한을 부여함

5. endpoint policy
- gateway type vpc endpoint 네트워크 보안쪽임, 사설 서비스에 많이 쓰임


---------------------------------------------------------------------
IAM policy는 json 포맷으로 선언 할 수 있다.


----------------------------------------
AWS EKS 보안 IRSA (iam role for service account)

IRSA
EKS 파드가 뜰때, AWS 리소스 접근을 위해, 토큰을 발급 받아야 하는데
그러한 역활을 하는 파드를 하나 띄움 (중앙 집중적 AWS 연결 인증 관리 파드)






