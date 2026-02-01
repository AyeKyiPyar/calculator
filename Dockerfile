FROM eclipse-temurin:21-jdk
ADD build/libs/calculator-jenkins-0.0.1-SNAPSHOT.jar app.jar
ENTRYPOINT [ "java", "-jar", "app.jar" ]