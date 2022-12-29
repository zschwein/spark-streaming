FROM openjdk:11-jdk-slim as source

COPY . /tmp/app
WORKDIR /tmp/app
RUN ./gradlew shadowJar

FROM apache/spark:v3.3.0 as spark

COPY --from=source /tmp/app/build/libs/spark-streaming-0.0.1-all.jar /opt/spark/jars/

ENV SPARK_HOME /opt/spark
WORKDIR /opt/spark/work-dir
ENTRYPOINT [ "/opt/entrypoint.sh" ]
