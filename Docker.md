
## To Study
https://github.com/docker/labs/tree/master/beginner
https://github.com/docker/labs/blob/master/developer-tools/README.md
	- https://github.com/docker/labs/tree/master/developer-tools/java-debugging
	- https://github.com/docker/labs/tree/master/developer-tools/java

https://github.com/docker/labs/tree/master/12factor

## Basic Ideas
> **Container**
> noun: Isolated area of an OS with resource usage limits applied

> Docker is a platform for developers and sysadmins to build, ship, and run applications. Docker lets you quickly assemble applications from components and eliminates the friction that can come when shipping code. Docker lets you test and deploy your code into production as fast as possible.

— docs.docker.com/

An application typically requires specific versions for the operating system, application server, JDK, database server, may require  configuration files, and similarly multiple other dependencies. Also, The application may need binding to specific ports and certain amount of memory. The components and configuration together required to run your application is what is referred to as **application operating system**.


## Main Components
Docker has three main components:

1.  _Images_  are the  **build component**  of Docker and are the read-only templates defining an application operating system.
    
2.  _Containers_  are the  **run component**  of Docker and created from images. Containers can be run, started, stopped, moved, and deleted.
    
3.  Images are stored, shared, and managed in a  _registry_  and are the  **distribution component**  of Docker. DockerHub is a publicly available registry

## Docker Image
An image is a read only template for creating application containers. Inside of it there is all the code and supporting files to run an application. 

- Images are build-time construct -> Image is a "stopped c ontainer" .
- Containers are their run time siblings -> Container is a "running image".
- An image is a bunch of independent layers that are very loosely connected by a manifest files. 
	- The manifest contains several things and one of them is the layers to be stacked and how to stack them.

- TODO - PRINT 6

Images are stored in a Registry. It can be cloud or On-premises computers. The images can be pull in the hosts by using the `docker image pull` command.

- TODO - PRINT 7
- TODO - PRINT 8

Docker images are then built from these base images using a simple, descriptive set of steps we call instructions. Each instruction creates a new layer in our image. Instructions include actions like:

1.  Run a command
    
2.  Add a file or directory
    
3.  Create an environment variable
    
4.  Run a process when launching a container    

These instructions are stored in a file called a Dockerfile. Docker reads this Dockerfile when you request a build of an image, executes the instructions, and returns a final image.

### Type of Docker Image's Hashes 
- Distribution hashes - Pushed Images to the registry have a hash of the compressed data called distribution hash
- Content Hashes - Uncompressed layers on the house, have as hash the `Content Hash`

- TODO - PRINT 9
- TODO - PRINT 10

## Docker Container
A container consists of an operating system, user-added files, and meta-data. Each container is built from an image. That image tells Docker what the container holds, what process to run when the container is launched, and a variety of other configuration data. The Docker image is read-only. When Docker runs a container from an image, it adds a read-write layer on top of the image in which the application can then run.

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

## Docker service
### Docker `run` vs Docker `service`
Docker run will start a single container. With docker service you manage a group of containers (from the same image). You can scale them (start multiple containers) or update them.

> docker run is used to create a standalone container
docker service create is used to create instances (called tasks) of that service running in a cluster (called swarm) of computers (called nodes). 

## Container Networking
Inside a Bridged Networking (default networking for docker linux), containers can talk to each other. When there a need of communication between containers in separated bridge networking, it becomes a "hard" operation because each one of these bridges are isolated. However it can be achieved through the usage of overlay.

- TODO - PRINT 15 
- TODO - PRINT 16

### Overlay Networking
`docker network create -o encrypted`

- TODO - PRINT 17

- `docker network ls`
- `docker network inspect bridge`
- `docker port web` -  Shows all the existing port mapping

### Creating a New Networking
- `docker network create -d <driver: default is 'bridge'> <name>  `

#### Networks  Drivers
- bridge
- overlay 
- overnet

## Working with Volumes and Persistend Data
Every container when it is created has its own temporary persistence layer (on Linux it is in `/var/lib/docker`) and all the data produced by the container is stored there. When a container is destroyed all of those information is destroyed as well. 

In order to keep the persistence untied of the container lifecycle, volumes come into play. It existe outside the container.

- TODO - PRINT 18

- `docker volume ls`  
- `docker volume create <name>`
- `docker volume inspect <name>`
- `docker volume rm <name>`

- `docker container ..... --mount source=<name-volume>,target=<where-to-mount-that-in-the-container>` : attaching a volume

## Working with Secrets
 - `docker secret create <name-secret> <path-for-the-secret>`: creating a new secret
	 - By doing this command a new secret is going to be created and stored in the docker swarm raft
 - `docker secret ls`
 - `docker service... --secret <name-secret>` : grant some service access to the secret
- secret's location on linux -> `/run/secrets`

- TODO - PRINT 18

## Deploying in Production with Stacks and Services
- TODO - PRINT 19

## Docker Commands
- `docker ps`
	- `docker ps -a` -  Show all the docker images executed, it is like a history
	- `docker ps -q` -  Only display numeric IDs (container_id)
- docker images
- docker build -t < imagename >  < context>
	- `docker build -t docker-java .` 
- docker run < image >
	- `docker run -it < image-name >`
	- `docker run -it -p host_port:container_port < image-name >`
	- `docker run -d < image-name >`: run the container in background
	- `docker run -d < image-name > sleep 1d`
	- `docker run -dit < image-name >`
- `docker rm $(docker ps -qa)`: remove all the containers that by the container_id
- `docker container stop < two first numbers docker-id >`
- `docker container ls -a`: Shows the inactive containers
- `docker container rm $(docker container ls -aq) -f`
- `docker logs < container >`
- `docker port web` -  Shows all the existing port mapping
- `docker service`
	- `docker service create -d --name <name> --replicas 2 --network <driver> alpine sleep 1`
	- `docker service ls`
	- docker service ps <service name> 

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




