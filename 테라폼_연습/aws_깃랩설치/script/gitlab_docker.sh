docker run --detach \
--name gitlab \
--hostname ${EIP} \
--restart always \
--volume ./gitlab/config:/etc/gitlab \
--volume ./gitlab/logs:/var/log/gitlab \
--volume ./gitlab/data:/var/opt/gitlab \
gitlab/gitlab-ce