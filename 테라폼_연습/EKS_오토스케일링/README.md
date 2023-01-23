https://www.youtube.com/watch?v=-nUQNFAX5TI

https://www.youtube.com/watch?v=kADwAYTErgA

먼저, 이상적인 오토 스케일링을 하고 싶은면 HPA와 CA가 동반되야 한다
HPA (파드 생성) -> pod 적재공간 부족할 시 CA(클러스터 생성)

이러한 작업을 하기위해서는 클러스터, 각 노드의 정보를 알기 위해 
메트릭 수집체계가 필요하다(자원 사용 현황율을 알아야 스케일링을 하지)

rm ~/.kube/config
## aws eks 정보를 kubectl에서 사용할 수 있게 컨피그 파일을 가져옴
aws eks --region us-east-2 update-kubeconfig --name chunjae_ocr --profile default
kubectl get nodes 


오토스케일링 설정
https://341123.tistory.com/8
https://velog.io/@choiys0212/EKS-AutoScaling
https://haereeroo.tistory.com/22

