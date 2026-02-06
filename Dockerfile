FROM openjdk:21-jdk
ADD target/calculator-jenkins-0.0.1-SNAPSHOT.jar app.jar
ENTRYPOINT [ "java", "-jar", "app.jar" ]
