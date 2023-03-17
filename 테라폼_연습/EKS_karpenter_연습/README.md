https://karpenter.sh/preview/concepts/provisioners/

https://karpenter.sh/v0.20.0/getting-started/getting-started-with-terraform/

노드 템플릿
https://karpenter.sh/preview/concepts/node-templates/

--------
aws 계정에서 처음 스팟 인스턴스를 사용하는 경우에만

aws iam create-service-linked-role --aws-service-name spot.amazonaws.com
------
aws eks --region us-east-2 update-kubeconfig --name demo --profile default



helm install rabbitmq my-repo/rabbitmq-cluster-operator
kubectl apply -f rabbit.yaml
curl -u momo:momo production-rabbitmqcluster.default.svc.cluster.local:15672/api/overview


helm install redis bitnami/redis --set auth.enabled=false

