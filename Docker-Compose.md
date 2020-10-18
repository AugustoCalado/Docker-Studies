# Docker Compose

Compose is a tool for defining and running multi-container Docker applications. With a file config (YAML), is possible to configure several application's servers. Then, with a single command, all the services from the configuration file are created and starter .

Docker Compose directives are written in YAML format and are hosted in a file commonly named  `docker-compose.yml`. Common Docker Compose commands include:

-   `docker-compose up --build`  builds the images for every service defined in the  `docker-compose.yml`  file and run the containers in the predefined order.    
-   `docker-compose down --volumes`  removes all the containers built by your compose script as well as any storage volumes.   
-   `docker-compose ps`  lists all currently active containers.
-   `docker-compose stop`  halts the running of the currently active containers.

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
        - 
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

### Key Commands
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
