FROM openjdk
WORKDIR /usr/app/helloworld
ADD ./target/helloworld-0.0.1-SNAPSHOT.jar /
CMD java -jar helloworld-0.0.1-SNAPSHOT.jar

