# About
This is a simple collection of docker-compose files that can be used to spin up stand alone services without need for additional configuration or deploying those services locally.

# WSL2 (Ubuntu 20.04) with Docker
Source: https://dev.to/bowmanjd/install-docker-on-windows-wsl-without-docker-desktop-34m9
**IMPORTANT: Set MTU if working over VPN on WSL2:** `sudo ifconfig eth0 mtu 1350`

**Note:** In a pure linux environment, this isn't necessary but WSL2 behaves differently with its own version of init 
so the below steps are necessary to get docker to work properly INSIDE WSL2.

## Using the bash script 
A bash script was created to automate the installation steps. This should run all of the setup commands for you by issuing:

`sudo bash setup_docker_for_wsl.sh`


### Confirm docker-service file matches your setup
`cat ~/bin/docker-service`
and paste the below:
NOTE: the DOCKER_DISTRO should match the output of `wsl -l -v`
```
DOCKER_DISTRO="Ubuntu-20.04"
DOCKER_DIR=/mnt/wsl/shared-docker
DOCKER_SOCK="$DOCKER_DIR/docker.sock"
export DOCKER_HOST="unix://$DOCKER_SOCK"
if [ ! -S "$DOCKER_SOCK" ]; then
    mkdir -pm o=,ug=rwx "$DOCKER_DIR"
    sudo chgrp docker "$DOCKER_DIR"
    /mnt/c/Windows/System32/wsl.exe -d $DOCKER_DISTRO sh -c "nohup sudo -b dockerd < /dev/null > $DOCKER_DIR/dockerd.log 2>&1"
fi
```
- Run docker with the command `docker-service`

### Running a new container
1) Find the service you need
2) Copy service to a new folder or project
3) Modify project name in docker-compose.yml
4) Modify .env.dev settings to match what you need
5) Run `sudo docker-compose up --build` to build the image and run it.

## Docker Useful Commands
### Access mysql db
```$ sudo docker-compose exec CONTAINER_NAME mysql -uUSERNBAME -pPASSWORD```

### Remove volumes along with containers
`docker-compose down -v`

### Development mode with flask output
- `docker-compose up`
  - `-d` is for detached mode
  - `--build` in the event you need to build the image, add new dependencies, etc...

### Access command line
- `sudo docker exec -it CONTAINER_NAME bash`

### See running containers
- `sudo docker ps`
