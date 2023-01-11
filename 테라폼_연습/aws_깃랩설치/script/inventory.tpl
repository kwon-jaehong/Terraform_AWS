[gitlab_server]
gitlab_server ansible_host=${gitlab_server_ip} ansible_user=ubuntu
[gitlab_runner]
%{  for ip in gitlab_runner_ip ~}
gitlab_runner ansible_host=${ip} ansible_user=ubuntu
%{ endfor ~}
