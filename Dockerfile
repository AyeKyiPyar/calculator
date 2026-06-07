# Use specific image version or digest
FROM eclipse-temurin:21-jdk

# Create a non-root user
RUN useradd -m appuser
USER appuser

# Copy the jar
ADD target/calculator-jenkins-0.0.1-SNAPSHOT.jar app.jar

# Run the app
ENTRYPOINT ["java","-jar","app.jar"]
