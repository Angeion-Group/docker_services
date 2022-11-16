#!/bin/bash

# Import os-release as variables
. /etc/os-release

sudo apt update && sudo apt upgrade
sudo apt install --no-install-recommends apt-transport-https ca-certificates curl gnupg2
curl -fsSL https://download.docker.com/linux/$ID/gpg | sudo tee /etc/apt/trusted.gpg.d/docker.asc
echo "deb [arch=amd64] https://download.docker.com/linux/$ID $VERSION_CODENAME stable" | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $USER
# ensure a docker compose is version 1.29.2 or higher
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$OS-$ARCHITECTURE" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "Ensure that the output of the following command is legacy auto, otherwise select that:"
echo
sudo update-alternatives --config iptables

mkdir ~/bin
DOCKER_DISTRO=$(/mnt/c/Windows/System32/wsl.exe -l -v | awk 'NR==2' | awk '{print $2}')
echo "Got '$DOCKER_DISTRO' as the name of the WSL Image Name, is this correct? [y/n] Default=y"
read input
case $input in
    n)
    echo "What is the name of the current image?"
    echo
    read input
    DOCKER_DISTRO=$input
    ;;
esac

cat > ~/bin/docker-service2 << EOF
DOCKER_DISTRO="$DOCKER_DISTRO"
DOCKER_DIR=/mnt/wsl/shared-docker
DOCKER_SOCK="\$DOCKER_DIR/docker.sock"
export DOCKER_HOST="unix://\$DOCKER_SOCK"
if [ ! -S "\$DOCKER_SOCK" ]; then
    mkdir -pm o=,ug=rwx "\$DOCKER_DIR"
    sudo chgrp docker "\$DOCKER_DIR"
    /mnt/c/Windows/System32/wsl.exe -d \$DOCKER_DISTRO sh -c "nohup sudo -b dockerd < /dev/null > \$DOCKER_DIR/dockerd.log 2>&1"
fi
EOF
if [ -v $(grep '/bin:$PATH' ~/.bashrc) ]; then
    echo 'PATH=~/bin:$PATH' >> ~/.bashrc
fi

chmod +x ~/bin/docker-service
source ~/.bashrc

echo "Starting docker service..."

sudo docker-service &

echo "All done! In the future, start docker service with the command `docker-service` after each shutdown of WSL."
