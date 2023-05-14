
aws eks --region us-east-2 update-kubeconfig --name test_eks --profile default

----

참조
https://aws.amazon.com/ko/blogs/tech/machine-learning-with-kubeflow-on-amazon-eks-with-amazon-efs/




kubectl patch storageclass gp2 -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

while ! kustomize build example | awk '!/well-defined/' | kubectl apply -f -; do echo "Retrying to apply resources"; sleep 10; done
----

curl --silent --location "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv5.0.1/kustomize_v5.0.1_linux_amd64.tar.gz" | tar xz -C /tmp
chmod +x /tmp/kustomize
sudo mv /tmp/kustomize /usr/local/bin/kustomize
kustomize version