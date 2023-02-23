
깃랩서버 스펙은
4 cpu 랩 8기가 이상이 좋은것 같다...

--------------------------
도커 설치시

docker run --detach \
--name gitlab \
--hostname 3.133.133.67 \
--publish 80:80 \
--restart always \
--volume ./gitlab/data:/var/opt/gitlab \
--volume ./gitlab/logs:/var/log/gitlab \
--volume ./gitlab/data:/var/opt/gitlab \
--volume ./gitlab/backup:/var/opt/gitlab/backups \
gitlab/gitlab-ce:15.4.6-ce.0

----
야호sa