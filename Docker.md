
https://github.com/docker/labs/tree/master/beginner
https://github.com/docker/labs/blob/master/developer-tools/README.md
	- https://github.com/docker/labs/tree/master/developer-tools/java-debugging
	- https://github.com/docker/labs/tree/master/developer-tools/java

https://github.com/docker/labs/tree/master/12factor
docker ps
- `docker ps -a` -  Show all the docker images executed, it is like a history
- `docker ps -q` -  Only display numeric IDs (container_id)
docker images
docker build -t < imagename >  < context>
	- `docker build -t docker-java .` 
docker run < image >
	- `docker run -it < image-name >`
	- `docker run -it -p host_port:container_port < image-name >`
	- `docker run -d < image-name >`: run the container in background
`docker rm $(docker ps -qa)`: remove all the containers that by the container_id

## Docker-Machine

`docker-machine env < machine-name >`
`eval ${docker-machine ev <machine-name}` : insert all the environment of the informed machine-name into the client environment variables.

## Docker Compose
Defining and running multi-container applications
con

### Volume Mapping
