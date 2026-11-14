#!/bin/bash
sudo apt update && sudo apt install -y docker.io git
sudo systemctl enable --now docker
sudo docker pull mghzakariae/k8s_proj:${image_tag}

cat <<EOF > /home/ubuntu/.env
REDIS_HOST=${redis_host}
REDIS_PORT=6379
SECRET_KEY=${secret_key}
DEBUG=false
EOF

sudo docker run -d -p 5000:5000 --env-file /home/ubuntu/.env mghzakariae/k8s_proj:${image_tag}