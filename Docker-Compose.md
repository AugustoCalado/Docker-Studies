# Docker Compose
Compose is a tool for defining and running multi-container Docker applications. With a file config (YAML), is possible to configure several application's servers. Then, with a single command, all the services from the configuration file are created and starter .

Docker Compose directives are written in YAML format and are hosted in a file commonly named  `docker-compose.yml`. Common Docker Compose commands include:

-   `docker-compose up --build`  builds the images for every service defined in the  `docker-compose.yml`  file and run the containers in the predefined order.    
-   `docker-compose down --volumes`  removes all the containers built by your compose script as well as any storage volumes.   
-   `docker-compose ps`  lists all currently active containers.
-   `docker-compose stop`  halts the running of the currently active containers.

## Useful Links
- [Docker Compose Command-line Reference](https://docs.docker.com/compose/reference/overview/)

## Dependences Between Containers vs Docker Compose
Since there are several containers at play, there should be an order in which they start up. Docker Compose addresses this with the `depends_on` directive. The directive informs Docker Compose which containers should start running before others can be executed.

## The docker-compose.yml File

### Structure
- version
- service
	- build
	- environment
	- image
	- network
	- ports
	- volumes

### Example I
```yml
version:"3.x"
services:
	node:
		build:
			context: .
			dockerfile: node.dockerfile
		networks:
			- nodeapp-network
	mongodb:
		image: mongo
		networks:
			- nodeapp-network
networks:
	nodeapp-network
		driver:bridge
```

### Example II -  Volume and Environment Variables File
```
version: "3.7"
 
services:
    nginx:
      container_name: nginx
      image: nginx:1.19
      build: 
        context: .
        dockerfile: .docker/nginx.${APP_ENV}.dockerfile
      depends_on: 
        - node
      ports:
        - "80:80"
        - "443:443"
      networks:
        - aug-network
    node:
      container_name: node-codewithdan
      image: ${DOCKER_ACCT}/node-codewithdan
      build: 
        context: .
        dockerfile: .docker/node-codewithdan.${APP_ENV}.dockerfile
      ports:
      - "8080"
      volumes:
        - .:/var/www/codewithdan
      working_dir: /var/www/codewithdan
      env_file:
        - ./.docker/env/app.${APP_ENV}.env
      depends_on:
        - mongo
        - redis
      networks:
        - codewithdan-network

networks:
	codewithdan-network:
	  driver: bridge
```

- `dockerfile: .docker/nginx.${APP_ENV}.dockerfile` - This line gets the value defined in the local environment variable `APP_ENV` and uses it to get the right docker file inside the `.docker`

	**What is in the folder **`.docker`**?**  
		- nginx.dev.dockerfile
		- nginx.prd.dockerfile

- `env_file:` - block where we can define files that hold environments variables. Also, as the same way we did with docker file. We can use the local environment variables to define which file should be used by the docker compose.

	**What is in the folder **`docker/env/`**?**  
		- app.dev.env
		- app.prd.env

	**What is in the folder **`app.dev.env`**?**
	```
	NODE_ENV=development
	```

## Spring and Docker Compose
[environment variables take precedence](https://docs.spring.io/spring-boot/docs/current/reference/html/boot-features-external-config.html) over the .properties files. Then the follow scenario will override the properties in the application-xyz.properties file

### application-xyz.properties
```properties
## Server Properties  
server.port=8080  
server.compression.enabled=true  
  
## Spring DATASOURCE (DataSourceAutoConfiguration & DataSourceProperties)  
spring.datasource.url=jdbc:mysql://localhost:8051/polls?useSSL=false&serverTimezone=UTC&useLegacyDatetimeCode=false  
spring.datasource.username=defaultUser  
spring.datasource.password=default
```
### docker-compose.yml
```yml
services:
  # App backend service
  app-server:
    # Configuration for building the docker image for the backend service
    build:
      context: polling-app-server # Use an image built from the specified dockerfile in the `polling-app-server` directory.
      dockerfile: Dockerfile
    ports:
      - "8080:8082" # Forward the exposed port 8082 on the container to port 8080 on the host machine
    restart: always
    depends_on: 
      - db # This service depends on mysql. Start that first.
    environment: # Pass environment variables to the service ->  environment variables take precedence over the .properties files inside spring app.
      SPRING_DATASOURCE_URL: jdbc:mysql://db:3306/polls?useSSL=false&serverTimezone=UTC&useLegacyDatetimeCode=false
      SPRING_DATASOURCE_USERNAME: root
      SPRING_DATASOURCE_PASSWORD: root    
      SERVER_PORT: 8082
    networks: # Networks to join (Services on the same network can communicate with each other using their name)
      - backend
      - frontend
```

The property `spring.datasource.username` tera o valor da environment variable defined in the docker-compose.yml.

(Spring - Common Application Properties)[https://docs.spring.io/spring-boot/docs/2.0.x/reference/html/common-application-properties.html]

### What I have experienced about Docker and Spring
- Connect app in container using the port mapped in the host machine.
	Well, I initially thought that we should use the mapped port on the host machine to connect my spring application to the database defined in another container. However, it turned out that we only need to use the exposed door inside the container. Why that? Well, the answer is 'network', communication between containers can (should) be done over networks.

## Key Commands
- `docker-compose build`
	- `docker-compose build <name-of-a-service>` - only build/rebuild one service
- `docker-compose up` - create and start the containers
	- `docker-compose up --no-deps node1`- The `--no-deps` tells to not recreate services that node depends on. The `node1` is the service that is going to be rebuild, stop, destroyed, and recreated only. 
- `docker-compose down` - Stop and remove containers (take all)
	- `docker-compose down --rmi all --volumes` - remove all images and remove all volumes
	- 
- `docker-compose logs`
- `docker-compose ps` - list != containers which are running as services
- `docker-compose stop`
- `docker-compose start`
- `docker-compose rm`

## References
https://docs.docker.com/compose/reference/
https://stackoverflow.com/questions/46057625/externalising-spring-boot-properties-when-deploying-to-docker/46058046

