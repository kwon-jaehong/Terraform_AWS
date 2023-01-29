소스코드는 https://github.com/antonputra/tutorials/blob/main/lessons/038/
강의는 https://www.youtube.com/watch?v=nIIxexG7_a8&list=PLiMWaCMwGJXkeBzos8QuUxiYT6j8JYGE5&index=1

테라폼 EKS 생성 실행시 15~20분정도 걸림

cat ~/.aws/credentials
rm ~/.kube/config
## aws eks 정보를 kubectl에서 사용할 수 있게 컨피그 파일을 가져옴
aws eks --region us-east-2 update-kubeconfig --name chunjae_ocr --profile default
kubectl get nodes 




------------------
모니터링
https://oflouis.dev/sw_development/devops/aws-eks-monitoring-kube-prometheus-stack/


helm search repo prometheus-community/kube-prometheus-stack --versions

helm install stable prometheus-community/kube-prometheus-stack -f ./custom.yaml --version 16.10.0 -n monitoring

helm install stable prometheus-community/kube-prometheus-stack -n default

helm upgrade stable prometheus-community/kube-prometheus-stack -f ./custom.yaml -n monitoring

----------------------------------------------
로깅
https://www.youtube.com/watch?v=yjNMaGEmeQU&t=903s


helm search repo elastic/elasticsearch --versions

helm install my-mongodb bitnami/mongodb 

kubectl create namespace dapr-monitoring
helm install elasticsearch elastic/elasticsearch -n dapr-monitoring  --version 7.6.0 --set replicas=1
helm install kibana elastic/kibana -n dapr-monitoring --version 7.6.0

kubectl apply -f ./fluentd-config-map.yaml
kubectl apply -f ./fluentd-dapr-with-rbac.yaml

kubectl create namespace dapr-system
helm install dapr dapr/dapr --namespace dapr-system --set global.logAsJson=true

kubectl apply -f .\counter.yaml

