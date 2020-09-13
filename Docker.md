
https://github.com/docker/labs/tree/master/beginner
https://github.com/docker/labs/blob/master/developer-tools/README.md
	- https://github.com/docker/labs/tree/master/developer-tools/java-debugging
	- https://github.com/docker/labs/tree/master/developer-tools/java

https://github.com/docker/labs/tree/master/12factor

## 
> **Container**
> noun: Isolated area of an OS with resource usage limits applied

## Kernel Internals
- **Namespaces**: Linux namespaces provide isolation for running processes, limiting their access to system resources without the running process being aware of the limitations. (keep the processes of a container (or the container itself) unawarer of the process of other containers).
	- TODO - Print 1
- **Control Groups**: Group process and impose limits.
 	- TODO - Print 2

## Docker Engine
- Docker Client -> "receive the commands"
- Docker daemon -> "implements the REST API"
- containerD -> "container supervisor that handles execution and lifecycle operation (Thinks such as starts, stop, pause and un pause)"
- OCI -> "It does the interface with the kernel"

- TODO - PRINT 3

### How it works on Linux?
1. The client asks the daemon for a new container
2. The daemon gets containerD to start and manage containers
3. The containerD uses runC to actually interface with the kernel.
4. The `runC` (reference implemantation of the `OCI` runtime spec) builds the container 

- TODO - PRINT 4
- TODO - PRINT 5

NICE TO KNOW: Thanks to this architecture, it is possible to shut down / restart the daemon or update it without killing the containers.

## Docker Image
An image is a read only template for creating application containers. Inside of it is all the code and supporting files to run an application. 

- Images are build-time construct -> Image is a "stopped c ontainer" .
- Containers are their run time siblings -> Container is a "running image".
- An image is a bunch of independent layers that are very loosely connected by a manifest files. 
	- The manifest contains several things and one of them is the layers to be stacked and how to stack them.

- TODO - PRINT 6

Images are stored in a Registry. It can be cloud or On-premises computers. The images can be pull in the hosts by using the `docker image pull` command.

- TODO - PRINT 7
- TODO - PRINT 8

### Type of Docker Image's Hashes 
- Distribution hashes - Pushed Images to the registry have a hash of the compressed data called distribution hash
- Content Hashes - Uncompressed layers on the house, have as hash the `Content Hash`

- TODO - PRINT 9
- TODO - PRINT 10

## Docker Commands
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
	- `docker run -d < image-name > sleep 1d`
`docker rm $(docker ps -qa)`: remove all the containers that by the container_id
- `docker container stop < two first numbers docker-id >`
- `docker container ls -a`: Shows the inactive containers
- `docker container rm $(docker container ls -aq) -f`
- `docker logs < container >`

## Dockerfile - Containerizing an App
- Instructions for building images
- CAPITALIZE Instructions
- < INSTRUCTION > < value>
- `FROM` always first instruction
	- `FROM` = base image
- `RUN` = Execute command and create layer
- `COPY` = Copy code into image as new layer
- `ENTRYPOINT` = default app for image/container

### Getting Dockerfile from Github
`docker image build -t psweb <link.git>`

### Multi-stage Builds
In order to avoid that the final image become too big (too many packages and stuffs). it is possible to create Multi-stage Builds that will in the end generate a umage only with what is necessary to execute.

- TODO - PRINT 12

```docker
FROM node:latest AS storefront
WORKDIR /usr/src/atsea/app/react-app
COPY react-app .
RUN npm install
RUN npm run build

FROM maven:latest AS appserver
WORKDIR /usr/src/atsea
COPY pom.xml .
RUN mvn -B -f pom.xml -s /usr/share/maven/ref/settings-docker.xml dependency:resolve
COPY . .
RUN mvn -B -s /usr/share/maven/ref/settings-docker.xml package -DskipTests

FROM java:8-jdk-alpine
RUN adduser -Dh /home/gordon gordon
WORKDIR /static
COPY --from=storefront /usr/src/atsea/app/react-app/build/ .
WORKDIR /app
COPY --from=appserver /usr/src/atsea/target/AtSea-0.0.1-SNAPSHOT.jar .
ENTRYPOINT ["java", "-jar", "/app/AtSea-0.0.1-SNAPSHOT.jar"]
CMD ["--spring.profiles.active=postgres"]
```
> Font: [atsea-sample-shop-app](https://github.com/nigelpoulton/atsea-sample-shop-app/tree/master/app )

- TODO - PRINT 13

## Containers
## Copy on Write Concept 
Everytime a container needs to write a change into an existing file. It makes its own copy of the "original" file and writes the changes inside himself.
- TODO - PRINT 14
 
## Docker-Machine
`docker-machine env < machine-name >`
`eval ${docker-machine ev <machine-name}` : insert all the environment of the informed machine-name into the client environment variables.

## Docker Compose
Defining and running multi-container applications
con

### Volume Mapping


