
cat ~/.aws/credentials
rm ~/.kube/config
## aws eks 정보를 kubectl에서 사용할 수 있게 컨피그 파일을 가져옴
aws eks --region us-east-2 update-kubeconfig --name chunjae_ocr --profile default
kubectl get nodes 
----
https://www.youtube.com/watch?v=-nUQNFAX5TI

https://www.youtube.com/watch?v=kADwAYTErgA

먼저, 이상적인 오토 스케일링을 하고 싶은면 HPA와 CA가 동반되야 한다
HPA (파드 생성) -> pod 적재공간 부족할 시 CA(클러스터 생성)

이러한 작업을 하기위해서는 클러스터, 각 노드의 정보를 알기 위해 
메트릭 수집체계가 필요하다(자원 사용 현황율을 알아야 스케일링을 하지)

오토스케일링 설정
https://341123.tistory.com/8
https://velog.io/@choiys0212/EKS-AutoScaling
https://haereeroo.tistory.com/22


프로메테우스 스크래핑
https://blog.container-solutions.com/prometheus-operator-beginners-guide


## 임시 CURL 이미지
kubectl run -i --tty curl --rm --image=alpine/curl --restart=Never -- /bin/sh

curl http://192.168.26.157:8081/metrics

------------------------------------------------------------
monitoring

kubectl create namespace argocd

kubectl delete namespace argocd

## 쿠버네티스 1.21버젼일 경우 아르고 2.1.15설치 -> 아르고cd 지원 버젼 확인해야됨
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.1.15/manifests/install.yaml

kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

아이디 : admin
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
비번 : 

kubectl apply -f ./argocd_prometheus_install.yaml

-----------------------------------------


kubectl -n kube-system get cm kube-proxy-config -o yaml |sed 's/metricsBindAddress: 127.0.0.1:10249/metricsBindAddress: 0.0.0.0:10249/' | kubectl apply -f -

kubectl -n kube-system patch ds kube-proxy -p "{\"spec\":{\"template\":{\"metadata\":{\"labels\":{\"updateTime\":\"`date +'%s'`\"}}}}}"

-----------------------------------------------------------------

