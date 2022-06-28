#
#  This jdk_test.Dockerfile creates a docker image from the base image https://hub.docker.com/r/almondsh/almond
#
ARG almond_version=0.10.9
ARG scala_kernel_version=2.12.12
FROM almondsh/almond:$almond_version-scala-$scala_kernel_version
USER root
RUN sudo apt-get -y clean && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y wget apt-transport-https gnupg
COPY creds/csrca.crt /usr/local/share/ca-certificates/csrca.crt
RUN apt-get update && \
    apt-get install -y \
    ca-certificates

#https://stackoverflow.com/questions/42292444/how-do-i-add-a-ca-root-certificate-inside-a-docker-image
RUN chmod 644 /usr/local/share/ca-certificates/csrca.crt && update-ca-certificates

#wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public --ca-certificate=/usr/local/share/ca-certificates/csrca.crt
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    rm -rf /var/lib/apt/lists/*

#source    https://github.com/DataDog/dd-trace-java-docker-build/blob/master/Dockerfile
# Install oracle jvm
# Oracle is periodically removing older versions from the downloads - when that happens one needs to go to
# https://www.oracle.com/java/technologies/javase/javase-jdk8-downloads.html to figure out the correct new link.
# !IMPORTANT! Replace '/otn/' with '/otn-pub/' to work around Oracle login issue
# See: https://gist.github.com/wavezhang/ba8425f24a968ec9b2a8619d7c2d86a6
RUN wget -q -O /tmp/oracle-jdk8.tar.gz -c --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" "https://javadl.oracle.com/webapps/download/GetFile/1.8.0_331-b09/165374ff4ea84ef0bbd821706e29b123/linux-i586/jdk-8u331-linux-x64.tar.gz"
#COPY bin/jdk-8u331-linux-x64.tar.gz /tmp/jdk-8u331-linux-x64.tar.gz
RUN #mv /tmp/jdk-8u331-linux-x64.tar.gz /tmp/oracle-jdk8.tar.gz
RUN tar xzf /tmp/oracle-jdk8.tar.gz -C /usr/lib/jvm/
RUN mv /usr/lib/jvm/jdk1.8.0_331 /usr/lib/jvm/oracle8
RUN rm -f /tmp/oracle-jdk8.tar.gz

# Install Oracle JDK 1.8 from ppa
#RUN add-apt-repository ppa:ts.sch.gr/ppa && \
#    apt-get -y update
#RUN echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
#RUN echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections
#
#RUN apt-get -y install oracle-java8-installer && \
#    java -version
#ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

#RUN wget https://cdn.azul.com/zulu/bin/zulu8.62.0.19-ca-jdk8.0.332-linux_amd64.deb zulu8jdk.deb -O zulu8jdk.deb
#RUN apt-get install -y ./zulu8jdk.deb
