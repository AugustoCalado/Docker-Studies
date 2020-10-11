docker volume create --name gradle-cache

docker run -rm -v gradle-cache:/home/gradle/.gradle -v "$PWD":/home/gradle/project -w /home/gradle/project gradle:6.6.1-jdk8 gradle build
