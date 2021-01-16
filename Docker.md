
# Docker
## To Study
https://github.com/docker/labs/tree/master/beginner
- [ ] [Developer Tools Tutorials](https://github.com/docker/labs/blob/master/developer-tools/README.md)
	- [ ] [Tutorial Java Debugging](https://github.com/docker/labs/tree/master/developer-tools/java-debugging)
	- [ ] [Docker for Java Developers](https://github.com/docker/labs/tree/master/developer-tools/java)

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

### Copy on Write Concept 
Everytime a container needs to write a change into an existing file. It makes its own copy of the "original" file and writes the changes inside himself.
- TODO - PRINT 14

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

### `mount` vs `-v`
Both of the commands perform de same task, create/use volumes. Prefer use `mount` rather than `-v`

The biggest difference is that the `-v` syntax combines all the options together in one field, while the `--mount` syntax separates them.
- **`-v`  or  `--volume`**: Consists of three fields, separated by colon characters (`:`).
	- first field is the name of the volume
	- second field is the path where the file or directory are mounted in the container.
	- third field is optional, and is a comma-separated list of options, such as `ro`(read-only).

- **`--mount`**: Consists of multiple key-value pairs, separated by commas and each consisting of a `<key>=<value>` tuple.
	- The `type` of the mount, which can be [`bind`](https://docs.docker.com/storage/bind-mounts/), `volume`, or [`tmpfs`](https://docs.docker.com/storage/tmpfs/).
	- The `source` (or `src`)of the mount. For named volumes, **this is the name of the volume**. For anonymous volumes, this field is omitted.
	- The `destination` (`dst`, or `target`.)takes as its value the path where the file or directory is mounted in the container.
-   The  `readonly`  option, if present, causes the bind mount to be  [mounted into the container as read-only](https://docs.docker.com/storage/bind-mounts/#use-a-read-only-bind-mount).
-   The  `bind-propagation`  option, if present, changes the  [bind propagation](https://docs.docker.com/storage/bind-mounts/#configure-bind-propagation). May be one of  `rprivate`,  `private`,  `rshared`,  `shared`,  `rslave`,  `slave`.

Example: `docker container ..... --mount source=<name-volume>,target=<where-to-mount-that-in-the-container>` : attaching a volume

```
$ docker run -d \
  -it \
  --name devtest \
  --mount type=bind,source="$(pwd)"/target,target=/app \
  nginx:latest

```
The `source="$(pwd)"/target` will get the target file in the path (pwd), and start a volume inside it. actually it will be the volume, right? **PS:** Note that the type of this mount is **bind**!!!

Use  `docker inspect devtest`  to verify that the bind mount was created correctly. Look for the  `Mounts`  section:

```
"Mounts": [
    {
        "Type": "bind",
        "Source": "/tmp/source/target",
        "Destination": "/app",
        "Mode": "",
        "RW": true,
        "Propagation": "rprivate"
    }
],

```

This shows that the mount is a  `bind`  mount, it shows the correct source and destination, it shows that the mount is read-write, and that the propagation is set to  `rprivate`.

![enter image description here](types-of-mounts-bind.png)

## Working with Secrets
 - `docker secret create <name-secret> <path-for-the-secret>`: creating a new secret
	 - By doing this command a new secret is going to be created and stored in the docker swarm raft
 - `docker secret ls`
 - `docker service... --secret <name-secret>` : grant some service access to the secret
- secret's location on linux -> `/run/secrets`

- TODO - PRINT 18

## Deploying in Production with Stacks and Services
- TODO - PRINT 19

## Dockerfile - Containerizing an App
- Instructions for building images
- CAPITALIZE Instructions
- < INSTRUCTION > < value>
- `FROM` always first instruction
	- `FROM` = base image
- `RUN` = Execute command and create layer
- `COPY` = Copy code into image as new layer
- `ENTRYPOINT` = default app for image/container

### Creating an Image
```
  docker image build . -t hellodocker
```
`.` in this command is the context for the command `docker image build`. `-t` adds a tag to the image.

```
docker image build -t hellodocker:2 .
``` 
`helloworld:2` is the format that allows to specify the image name and assign a tag/version to it separated by `:`.

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

## Docker-Machine
`docker-machine env < machine-name >`
`eval ${docker-machine ev <machine-name}` : insert all the environment of the informed machine-name into the client environment variables.

## The `.dockerignore` File
```
.k8s
.vscode
node_modules
npm-debug.log
```

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
	- `docker run -d < image-name >` - run the container in background
	- `docker run -d < image-name > sleep 1d`
	- `docker run -dit < image-name >`
	- `docker run --rm` - removes container afterwards
- `docker rm $(docker ps -qa)` - remove all the containers that by the container_id
- `docker container stop < two first numbers docker-id >`
- `docker container ls -a` - Shows the inactive containers
- `docker container rm $(docker container ls -aq) -f`
- `docker logs < container >`
- `docker port web` -  Shows all the existing port mapping
- `docker service`
	- `docker service create -d --name <name> --replicas 2 --network <driver> alpine sleep 1`
	- `docker service ls`
	- docker service ps <service name> 
- `sudo docker exec –it nginx-test /bin/bash` - Use exec to Run Commands in a Docker Container
- `CTRL+P ... CTRL+Q` - Leave containe without kill it
- `docker system prune` - Clean up disk spaces

### Difference between CMD and ENTRYPOINT
**TL;DR**  `CMD`  will work for most of the cases.

Default entry point for a container is  `/bin/sh`, the default shell.

Running a container as  `docker container run -it ubuntu`  uses that command and starts the default shell. The output is shown as:

> docker container run -it ubuntu
root@88976ddee107:/#

`ENTRYPOINT`  allows to override the entry point to some other command, and even customize it. For example, a container can be started as:

> docker container run -it --entrypoint=/bin/cat ubuntu /etc/passwd
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
. . .

This command overrides the entry point to the container to  `/bin/cat`. The argument(s) passed to the CLI are used by the entry point.

### Difference between ADD and COPY
**TL;DR**  `COPY`  will work for most of the cases.

`ADD`  has all capabilities of  `COPY`  and has the following additional features:

1.  Allows tar file auto-extraction in the image, for example,  `ADD app.tar.gz /opt/var/myapp`.
    
2.  Allows files to be downloaded from a remote URL. However, the downloaded files will become part of the image. This causes the image size to bloat. So its recommended to use  `curl`  or  `wget`  to download the archive explicitly, extract, and remove the archive.

### Docker ARG and ENV
-   **ARG**  is only available during the build of a Docker image (RUN etc), not after the image is created and containers are started from it (ENTRYPOINT, CMD). You can use ARG values to set ENV values to  [work around] that.
-   **ENV**  values are available to containers, but also RUN-style commands during the Docker build starting with the line where they are introduced.

#### ARG
```
ARG some_variable_name
# or with a hard-coded default:
#ARG some_variable_name=default_value

RUN echo "Oh dang look at that $some_variable_name"
# you could also use braces - ${some_variable_name}
```
[relevant docs](https://docs.docker.com/engine/reference/builder/#arg)

When building a Docker image from the commandline, you can set  **ARG**  values using  _–build-arg_:

```
$ docker build --build-arg some_variable_name=a_value
```

**OUTPUT**
```
Oh dang look at that a_value
```

**Docker compose** - Declaring ARG
```
version: '3'

services:
  somename:
    build:
      context: ./app
      dockerfile: Dockerfile
      args:
        some_variable_name: a_value
```

#### ENV
How to set ENV values? It is possible do it when starting the containers, but also there is the possibility to provide default ENV values directly in theDockerfile by hard-coding them. 

When building an image, the only thing that can be provided as parameter are ARG values. Is no allowed provide values for ENV variables directly. However, both ARG and ENV can work together. Use ARG to set the default values of ENV vars.

```
# expect a build-time variable
ARG A_VARIABLE
# use the value to set the ENV var default
ENV an_env_var=$A_VARIABLE
```

**Ways to provide values for ENV variables After Image Built**

1. Provide values one by one
	From the commandline, use the -e flag:
	```
	$ docker run -e "env_var_name=another_value" alpine env
	```

	docker-compose.yml file:
	```
	version: '3'

	services:
	  plex:
	    image: linuxserver/plex
	      environment:
	        - env_var_name=another_value
	```
	
2.  Pass environment variable values from your host
	Don’t provide a value, but just name the variable. This will make Docker access the current value in the host environment and pass it on to the container.

	```
	$ docker run -e env_var_name alpine env
	```

	docker-compose.yml file:
	```
	version: '3'

	services:
	  plex:
	    image: linuxserver/plex
	      environment:
	        - env_var_name
	```

## Import and export images

Docker images can be saved using  `image save`  command to a  `.tar`  file:

docker image save helloworld > helloworld.tar

These tar files can then be imported using  `load`  command:

docker image load -i helloworld.tar

## References
- [Docker ARG, ENV and .env - a Complete Guide](https://vsupalov.com/docker-arg-env-variable-guide/#setting-arg-values)
- [How To SSH Into A Running Docker Container And Run Commands](https://phoenixnap.com/kb/how-to-ssh-into-docker-container)


