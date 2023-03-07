
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






----------------------------------

귀하의 요청에 대해 알려주십시오
카펜터 스케쥴러가 "aws.amazon.com/neuroncore"를 스케쥴링 할 수 있는 방법이 있습니까?

----------------------------------
해결하려는 문제에 대해 알려주십시오. 당신은 무엇을 하려고 하며, 왜 어렵습니까?
나는 EKS환경에서 ML모델 MSA환경을 구성하려 합니다.
또한 AWS inf1 인스턴스를 사용해 서비스를 운영하려고 한다.

각 서비스는 "aws.amazon.com/neuroncore" 하나씩 사용해서 pod를 구성하였습니다.


https://karpenter.sh/v0.20.0/concepts/instance-types/ 


[소스 코드 참조]

apiVersion: apps/v1
kind: Deployment
metadata:
  name: example-app
  namespace: default
spec:
  replicas: 2
  selector:
    matchLabels:
      app: example-app
  template:
    metadata:
      labels:
        app: example-app
    spec:
      containers:
      - name: example-app
        image: image:0.1        
        resources:
          limits:
            cpu: 1000m
            memory: 1.5Gi
            aws.amazon.com/neuroncore: 1
          requests:
            cpu: 800m
            memory: 1.0Gi
---
apiVersion: karpenter.sh/v1alpha5
kind: Provisioner
metadata:
  name: default
spec:
  ttlSecondsAfterEmpty: 10
  ttlSecondsUntilExpired: 600
  limits:
    resources:
      cpu: 1000
      aws.amazon.com/neuron: 100
  requirements:
    - key: "karpenter.sh/capacity-type"
      operator: In
      values: ["spot"]
    - key: karpenter.k8s.aws/instance-family
      operator: In
      values: [inf1]
    - key: karpenter.k8s.aws/instance-size
      operator: In
      values: [xlarge, 2xlarge]
  providerRef:
    name: my-provider
---
apiVersion: karpenter.k8s.aws/v1alpha1
kind: AWSNodeTemplate
metadata:
  name: my-provider
spec:
  subnetSelector:
    kubernetes.io/cluster/demo: owned
  securityGroupSelector:
    kubernetes.io/cluster/demo: owned



다음과 같은 오류를 
│ controller 2023-03-07T07:48:40.081Z    ERROR    controller.provisioning    Could not schedule pod, incompatible with provisioner "default", no instance type satisfied resources {"aws.amazon.com/neuroncore":"1","cpu":" │
│ 800m","memory":"1Gi","pods":"1"} and requirements karpenter.sh/capacity-type In [on-demand spot], karpenter.k8s.aws/instance-family In [inf1], karpenter.k8s.aws/instance-size In [2xlarge xlarge], kubernetes.io/arch In │
│  [amd64], karpenter.sh/provisioner-name In [default]    {"commit": "5d4ae35-dirty", "pod": "application/layout-analysis-866f9cb8dd-xqqjj"}  


같은환경에서 뉴런 코어를 쓰면 정상 스케쥴링되어 스팟인스턴스를 추가해 줍니다.
잘되는 소스코드
뉴런 코어를 쓰면 정상 작동합니다.


---------
현재 이 문제를 해결하고 있습니까?
일단은, pod 리소스 요청을 "aws.amazon.com/neuron"로 사용하려 하지만, 작은 ML모델에서 강제로 뉴런 코어 4개를 받아서 쓰는것은 매우 비효율적이고, 자원낭비라고 생각합니다.



----------------
