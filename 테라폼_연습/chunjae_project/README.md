
실배포때 eks 노드그룹 admin t3 large로 배포하자

게이트 웨이 노드그룹은 스트레스 테스트를 해봐야함



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


