#### About
This is a simple collection of docker-compose files that can be used to spin up stand alone services without need for additional configuration or deploying those services locally.

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
