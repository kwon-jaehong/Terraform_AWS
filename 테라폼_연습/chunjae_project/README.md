
실배포때 eks 노드그룹 admin t3 large로 배포하자

게이트 웨이 노드그룹은 스트레스 테스트를 해봐야함


aws 계정에서 처음 스팟 인스턴스를 사용하는 경우에만
aws iam create-service-linked-role --aws-service-name spot.amazonaws.com 

-------------------
테라폼 쿠버네티스 얌 보디
https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/kubectl_manifest

------------------
cat ~/.aws/credentials
rm ~/.kube/config
## aws eks 정보를 kubectl에서 사용할 수 있게 컨피그 파일을 가져옴
aws eks --region us-east-2 update-kubeconfig --name chunjae_ocr --profile default
kubectl get nodes 
----


## 임시 CURL 이미지
kubectl run -i --tty curl --rm --image=alpine/curl --restart=Never -- /bin/sh

curl http://192.168.26.157:8081/metrics

nslookup character-detection.application.svc.cluster.local

------------------------------------------------------------



kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
-> 안해도 됨


# 프로메테우스 로드밸런스
kubectl patch svc stack-kube-prometheus-stac-prometheus -n monitoring -p '{"spec": {"type": "LoadBalancer"}}'


아이디 : admin
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
비번 : 


kubectl get service --namespace kube-system k8s-neuron-scheduler -o jsonpath='{.spec.clusterIP}'
-----------------------------------------

## 프록시 제대로 띄우기
kubectl -n kube-system get cm kube-proxy-config -o yaml |sed 's/metricsBindAddress: 127.0.0.1:10249/metricsBindAddress: 0.0.0.0:10249/' | kubectl apply -f -

kubectl -n kube-system patch ds kube-proxy -p "{\"spec\":{\"template\":{\"metadata\":{\"labels\":{\"updateTime\":\"`date +'%s'`\"}}}}}"

-----------------------------------------------------------------
kubectl get --raw "/apis/custom.metrics.k8s.io/v1beta1/namespaces/application/pods/*/nr" | jq .




레디스 마스터 2개 키니 박살났음


----------------
t3 미디엄
서울 48283.2원 노계약
서울 28785.6원 1년 계약

t3 라지
서울 96573.6원 노계약
서울 58500원 1년 계약

inf1 x라지
서울 261295.2원 노계약
서울 164584.8원 1년계약
----------------------------------------
500 {'status': False, 'msg': 'character_detection_api_error'}
500 {'status': False, 'msg': 'character_detection_api_error'}
500 {'status': False, 'msg': 'character_detection_api_error'}
500문제 처리시간 122.92884540557861
500문제 처리시간 146.07485151290894
500문제 처리시간 125.30530023574829
500문제 처리시간 141.86516642570496
500문제 처리시간 122.12773752212524


50문제 처리시간 15.216781377792358
50문제 처리시간 15.039380311965942
50문제 처리시간 15.491265058517456
50문제 처리시간 16.824081897735596
50문제 처리시간 15.071983814239502
50문제 처리시간 15.117674350738525
50문제 처리시간 16.484302043914795
50문제 처리시간 15.613524198532104

50만 문항 기준
45시간 소요

ㄴㄴ

100문제 해도 될듯


---------------------
api gateway 
t3 스몰 써도 될듯