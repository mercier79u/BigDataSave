FROM openjdk:14
ADD bigdata-mongo.jar bigdata-mongo.jar
CMD ["java", "-jar", "bigdata-mongo.jar"]
expose 8080