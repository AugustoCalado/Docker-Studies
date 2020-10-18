FROM gradle:6.6.1-jdk8 as cache  
RUN mkdir -p /home/gradle/cache_home  
ENV GRADLE_USER_HOME /home/gradle/cache_home  
COPY build.gradle /home/gradle/java-code/  
WORKDIR /home/gradle/java-code  
RUN gradle clean build -i --stacktrace  
  
FROM gradle:6.6.1-jdk8 as builder  
COPY --from=cache /home/gradle/cache_home /home/gradle/.gradle  
COPY . /usr/src/java-code/  
WORKDIR /usr/src/java-code  
RUN gradle --no-daemon build --stacktrace  
  
FROM openjdk:8-jdk-alpine  
EXPOSE 8080  
USER root  
WORKDIR /usr/src/java-app  
COPY --from=builder /usr/src/java-code/build/libs/*.jar ./websocket-demo.jar  
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","-agentlib:jdwp=transport=dt_socket,server=y,address=5000,suspend=n","websocket-demo.jar"]