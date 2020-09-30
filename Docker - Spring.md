Github search keyword : `id "com.bmuschko.docker-java-application"`

## Tutorials
- [How to create a custom Docker image with JDK8, Maven and Gradle](https://medium.com/@migueldoctor/how-to-create-a-custom-docker-image-with-jdk8-maven-and-gradle-ddc90f41cee4)
- [Simple automate build using Docker and Gradle for Java Spring Boot project](https://medium.com/@engleangs/simple-automate-build-using-docker-and-gradle-for-java-spring-boot-project-70d79e65b4e6)
- [Automating Docker Builds With Gradle](https://tomgregory.com/automating-docker-builds-with-gradle/)
- [Simple automate build using Docker and Gradle for Java Spring Boot project](https://medium.com/@engleangs/simple-automate-build-using-docker-and-gradle-for-java-spring-boot-project-70d79e65b4e6)

- [ Docker for Spring boot | Gradle | Java micro service](https://medium.com/@sairamkrish/docker-for-spring-boot-gradle-java-micro-service-done-the-right-way-2f46231dbc06)

- [Spring Boot in a Container](https://github.com/spring-guides/top-spring-boot-docker#a-better-dockerfile)
--- 
- [Spring Boot, Mysql, React docker compose example](https://www.callicoder.com/spring-boot-mysql-react-docker-compose-example/)
- [Building a Spring Boot application in Jenkins (part 1 of microservice devops series)](https://tomgregory.com/building-a-spring-boot-application-in-jenkins/)
- [Building a Spring Boot application in Docker and Jenkins (part 2 of microservice devops series)](https://tomgregory.com/building-a-spring-boot-application-in-docker-and-jenkins/)
- [Dockerizando um ambiente com API’s springboot se comunicando por RabbitMQ](https://medium.com/totvsdevelopers/dockerizando-um-ambiente-com-apis-springboot-se-comunicando-por-rabbitmq-c8368faa6e64)
- [Spring Boot Docker Integration With Rabbitmq and Mysql](https://www.codeprimers.com/spring-boot-docker-integration-with-rabbitmq-and-mysql/)

## Gradle

- https://github.com/whitingjr/echo-api/blob/b73cfd308db5dc61131381a6a71a537397e92dc9/build.gradle

- https://github.com/pedro-n-rocha/micro-container/blob/1c8339f13a1c3f7cfd664566e8abf625585dda03/build.gradle

- https://github.com/set321go/profiles-service/blob/be7fed98e5b384f0727afa3b1a44b2056f7b26ba/build.gradle

- https://github.com/Alxandr/ircbot/blob/7fdb23da2ac12f6eb9bd69ef1c12ff217242f540/build.gradle

- https://github.com/kvrobert/TLOGRS/blob/2a718278a02db754e041921574962eb8aefeb8ee/build%20(1).gradle

- https://github.com/mrdunski/soccero-panda-manta/blob/e1826352b0d582dbc5961acde7135b6bc5506ade/build.gradle

## Options to build and Run SpringBoot Application
1. Use a readily available gradle image and build the application. Then build a Docker image with the output artifact (jar)
2. Have a multi-stage Dockerfile. As a first stage, build the application, in the second stage, build a docker image with output artifact from previous stage.
	-  [Getting from the local computer](https://medium.com/@sairamkrish/docker-for-spring-boot-gradle-java-micro-service-done-the-right-way-2f46231dbc06)
	- [Download from github](https://medium.com/@engleangs/simple-automate-build-using-docker-and-gradle-for-java-spring-boot-project-70d79e65b4e6)
3. Use plugins to run 
