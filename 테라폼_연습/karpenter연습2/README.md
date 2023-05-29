https://karpenter.sh/preview/concepts/provisioners/

https://karpenter.sh/v0.20.0/getting-started/getting-started-with-terraform/

https://kingofbackend.tistory.com/261

노드 템플릿
https://karpenter.sh/preview/concepts/node-templates/

--------
aws 계정에서 처음 스팟 인스턴스를 사용하는 경우에만

aws iam create-service-linked-role --aws-service-name spot.amazonaws.com
------ㄴ
aws eks --region us-east-2 update-kubeconfig --name demo --profile default



helm install rabbitmq my-repo/rabbitmq-cluster-operator
kubectl apply -f rabbit.yaml
curl -u chunjae:chunjae production-rabbitmqcluster.default.svc.cluster.local:15672/api/overview


helm install redis bitnami/redis --set auth.enabled=false



kubectl -n kube-system get cm aws-auth
------------------------------------------------------
https://repost.aws/questions/QUmfFhl4k8RSy4OmbM86WCVQ/give-cluster-admin-access-to-eks-worker-nodes

module.eks_blueprints.managed_node_group_iam_role_arns[0]

{
  "cluster_primary_security_group_id" = "sg-036a8f70a553caa62"
  "cluster_security_group_arn" = "arn:aws:ec2:us-east-2:916657902198:security-group/sg-02ee93cd0e82cf778"
  "cluster_security_group_id" = "sg-02ee93cd0e82cf778"
  "configure_kubectl" = "aws eks --region us-east-2 update-kubeconfig --name demo"
  "eks_cluster_arn" = "arn:aws:eks:us-east-2:916657902198:cluster/demo"
  "eks_cluster_certificate_authority_data" = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMvakNDQWVhZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJek1EVXlOREEyTVRrd01Wb1hEVE16TURVeU1UQTJNVGt3TVZvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTmxmCkpsYTl1Yk9HZGd1UVhKSkFWSW45OVlZVHNLSmh0RmFnTUgvelJZY1BWcmxrc3ZBdkNJSU9nbkhNdy9wTUZ0OUMKekgzN2ZFU2Y2MUU1dUhoQWVqR2JXRW1SSGxnNm5wbExPUW1RQ3JHaXUyNlZsblZCMHpZMVZDY2pyWmFJR243QgpIRTZvY3V0a2E2NHY3S0duUkRNV3dkeTJkKzNXZVNib0pKeWRTQkZmaGpYM2w0VG1Cc3VTVTBSUXVod2t0TVJYCmtuSmd1UGhLam9kMFBsYXErUWJKUnhqT1VsOWNINVB0NXdwZVA1NXpBM2RScmhMVXE2VUQxMC9Jc3BJaCtPckQKZlJEMmp4TlN4UzFITTBndmpicklmSDNEUHhOU1B2M1QxMW9HSll2MVpWU2hKS0dJRTVQdThxclFISmZKbDBrZQp2QzhDN1JYS0Z1SmFHcjVURytVQ0F3RUFBYU5aTUZjd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZOK3RpMjRHSmRiWUx3bGpsM3JkVm9VQzMvU1ZNQlVHQTFVZEVRUU8KTUF5Q0NtdDFZbVZ5Ym1WMFpYTXdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBRWRlYWVDeFJDdGUwbEJLMFBBQwpMOHNJYUtrVVVvZ0creFJ4OEc0TnRsRDF0b2lRUUM1NVREZkdxR05QQzlDNnZuQ0RNMlJtcGFIOHBsb0JvVDFoCnh2dWxPRFZQMDd6c3NzZE1zL1A1NVJaNUU1a1J4cVZ5RFllMlBtaXZtNjR6eHFKSWM4L2VwaHZrZUg1Z3lDSkMKS0o3K0lmL240bE5mdVBkdEY5MkRWVUVMT1RmVzVJZEovUWJRY1IyNGR4ZXhJMXpZMGtlaU53Mko1R2RrRUplSQpNUncxTGlYVlB0LzluWXBoNE0xZE9BRzNIZDE5czA5eXc1dVdrL3RtZy8va25xV1RxTHMzUjFETWFDTHVDWDBGClBvRmJvWTI2cVBUeGMwMy9lcExkWEpEeHgvNDZ6d3ZwQzNCTGF2akNNU3h4R05iU3R3Tjh1RUwzNjNTYWY4SGQKbmhNPQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg=="
  "eks_cluster_endpoint" = "https://50DAF5D3D1901DE1983A014B6D27E9AA.sk1.us-east-2.eks.amazonaws.com"
  "eks_cluster_id" = "demo"
  "eks_cluster_status" = "ACTIVE"
  "eks_cluster_version" = "1.25"
  "eks_oidc_issuer_url" = "oidc.eks.us-east-2.amazonaws.com/id/50DAF5D3D1901DE1983A014B6D27E9AA"
  "eks_oidc_provider_arn" = "arn:aws:iam::916657902198:oidc-provider/oidc.eks.us-east-2.amazonaws.com/id/50DAF5D3D1901DE1983A014B6D27E9AA"
  "emr_on_eks_role_arn" = []
  "emr_on_eks_role_id" = []
  "fargate_profiles" = {}
  "fargate_profiles_aws_auth_config_map" = []
  "fargate_profiles_iam_role_arns" = null /* object */
  "managed_node_group_arn" = tolist([
    "arn:aws:eks:us-east-2:916657902198:nodegroup/demo/general-20230524064830213800000001/1ec42642-182d-b691-3610-7eba4a25b9d5",
  ])
  "managed_node_group_aws_auth_config_map" = tolist([
    {
      "groups" = [
        "system:bootstrappers",
        "system:nodes",
      ]
      "rolearn" = "arn:aws:iam::916657902198:role/demo-general"
      "username" = "system:node:{{EC2PrivateDNSName}}"
    },
  ])
  "managed_node_group_iam_instance_profile_arns" = tolist([
    "arn:aws:iam::916657902198:instance-profile/demo-general",
  ])
  "managed_node_group_iam_instance_profile_id" = tolist([
    "demo-general",
  ])
  "managed_node_group_iam_role_arns" = tolist([
    "arn:aws:iam::916657902198:role/demo-general",
  ])
  "managed_node_group_iam_role_names" = tolist([
    "demo-general",
  ])
  "managed_node_groups" = tolist([
    {
      "role" = {
        "managed_nodegroup_arn" = [
          "arn:aws:eks:us-east-2:916657902198:nodegroup/demo/general-20230524064830213800000001/1ec42642-182d-b691-3610-7eba4a25b9d5",
        ]
        "managed_nodegroup_iam_instance_profile_arn" = [
          "arn:aws:iam::916657902198:instance-profile/demo-general",
        ]
        "managed_nodegroup_iam_instance_profile_id" = [
          "demo-general",
        ]
        "managed_nodegroup_iam_role_arn" = [
          "arn:aws:iam::916657902198:role/demo-general",
        ]
        "managed_nodegroup_iam_role_name" = [
          "demo-general",
        ]
        "managed_nodegroup_id" = [
          "demo:general-20230524064830213800000001",
        ]
        "managed_nodegroup_launch_template_arn" = (known after apply)
        "managed_nodegroup_launch_template_id" = (known after apply)
        "managed_nodegroup_launch_template_latest_version" = (known after apply)
        "managed_nodegroup_status" = [
          "ACTIVE",
        ]
      }
    },
  ])
  "managed_node_groups_id" = tolist([
    "demo:general-20230524064830213800000001",
  ])
  "managed_node_groups_status" = tolist([
    "ACTIVE",
  ])
  "oidc_provider" = "oidc.eks.us-east-2.amazonaws.com/id/50DAF5D3D1901DE1983A014B6D27E9AA"
  "self_managed_node_group_autoscaling_groups" = []
  "self_managed_node_group_aws_auth_config_map" = []
  "self_managed_node_group_iam_instance_profile_id" = []
  "self_managed_node_group_iam_role_arns" = []
  "self_managed_node_groups" = tolist([])
  "teams" = []
  "windows_node_group_aws_auth_config_map" = []
  "worker_node_security_group_arn" = "arn:aws:ec2:us-east-2:916657902198:security-group/sg-0a530826381814e3c"
  "worker_node_security_group_id" = "sg-0a530826381814e3c"
}