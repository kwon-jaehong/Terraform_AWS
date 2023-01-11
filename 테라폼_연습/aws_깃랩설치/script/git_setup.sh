sudo apt-get update
sudo apt-get install -y curl openssh-server ca-certificates tzdata perl
sudo apt-get install -y postfix
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash
sudo EXTERNAL_URL="https://gitlab.example.com" apt-get install gitlab-ce

sudo ufw allow OpenSSH
sudo ufw allow http
sudo ufw allow https

sudo nano /etc/gitlab/gitlab.rb

# 2. gitlab 기본 설정 - /etc/gitlab/gitlab.rb 파일 수정