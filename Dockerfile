# Stage 1: Build the Maven project
FROM maven:3.8-openjdk-11-slim AS build

# Set the working directory in the container
WORKDIR /app

# Copy the Maven project file and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the application source code
COPY src ./src

# Build the application
RUN mvn package -DskipTests

# Stage 2: Build the final image
FROM openjdk:11-jre-slim

# Set the working directory in the container
WORKDIR /app

# Copy the JAR file from the Maven build stage to the container
COPY --from=build /app/target/E-Telihealth-0.0.1-SNAPSHOT.jar .

# Expose port 8080 (or the port your application listens on)
EXPOSE 8080

# Define the command to run your application
CMD ["java", "-jar", "E-Telihealth-0.0.1-SNAPSHOT.jar"]
