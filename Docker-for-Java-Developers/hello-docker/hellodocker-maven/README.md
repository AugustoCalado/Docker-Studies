## Create image using Java
Create a simple Java application

### Note
If running OpenJDK 9 or later, mvn package may fail with

```
[ERROR] Failed to execute goal org.apache.maven.plugins:maven-compiler-plugin:3.1:compile (default-compile) on project helloworld: Compilation failure: Compilation failure:
[ERROR] Source option 1.5 is no longer supported. Use 1.6 or later.
[ERROR] Target option 1.5 is no longer supported. Use 1.6 or later.
because support for Java 5 was dropped in JDK9.
```

Possible solution:
```
  <properties>
    <maven.compiler.source>1.6</maven.compiler.source>
    <maven.compiler.target>1.6</maven.compiler.target>
  </properties>
```

## Create a new Java project:

Creating basic project structure command:
```
mvn archetype:generate -DgroupId=org.examples.java -DartifactId=helloworld -DinteractiveMode=false
```

Build the project:
```
cd helloworld
mvn package
```

## Package and run Java application as Docker image
Create a new Dockerfile in helloworld directory and use the following content:
```
FROM openjdk:latest

COPY target/helloworld-1.0-SNAPSHOT.jar /usr/src/helloworld-1.0-SNAPSHOT.jar

CMD java -cp /usr/src/helloworld-1.0-SNAPSHOT.jar org.examples.java.App
Build the image:
```

Create a new image:
```
docker image build -t hello-java:latest .
```

Run the image:
```
docker container run hello-java:latest
```

This displays the output:
```
Hello World!
```