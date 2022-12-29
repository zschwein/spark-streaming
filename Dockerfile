FROM openjdk:11-jdk-slim as source
ARG GRADLE_VERSION=7.6

RUN apt-get -y update && \
  apt-get -y install wget unzip && \
  wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -P /tmp && \
  unzip -d /opt/gradle /tmp/gradle-${GRADLE_VERSION}-bin.zip && \
  ln -s /opt/gradle/gradle-${GRADLE_VERSION} /opt/gradle/latest

ENV GRADLE_HOME=/opt/gradle/latest
ENV PATH=${GRADLE_HOME}/bin:${PATH}

COPY . /tmp/app
WORKDIR /tmp/app
RUN gradle shadowJar

FROM apache/spark:v3.3.0 as spark

COPY --from=source /tmp/app/build/libs/spark-streaming-0.0.1-all.jar /opt/spark/jars/

ENV SPARK_HOME /opt/spark
WORKDIR /opt/spark/work-dir
ENTRYPOINT [ "/opt/entrypoint.sh" ]
