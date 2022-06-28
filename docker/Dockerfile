#
#  This jdk_test.Dockerfile creates a docker image from the base image https://hub.docker.com/r/almondsh/almond
#
ARG almond_version=0.13.0
ARG scala_kernel_version=2.13.7
FROM almondsh/almond:$almond_version-scala-$scala_kernel_version
USER root
RUN apt-get update && apt-get install -y wget apt-transport-https gnupg2 xdg-utils

# Install mitm fake ssl certificate
COPY csrca.crt /usr/local/share/ca-certificates/csrca.crt
RUN apt-get update && \
    apt-get install -y \
    ca-certificates

#https://stackoverflow.com/questions/42292444/how-do-i-add-a-ca-root-certificate-inside-a-docker-image
RUN chmod 644 /usr/local/share/ca-certificates/csrca.crt && update-ca-certificates

# Install chrome
RUN \
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
  echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list && \
  apt-get update && \
  apt-get install -y \
    google-chrome-stable

# Install zulu jvms
#https://github.com/microsoft/java/tree/master/docker/ubuntu
RUN apt-get -qq update && \
    apt-get -qq -y --no-install-recommends install gnupg software-properties-common && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0x219BD9C9 && \
    apt-add-repository "deb http://repos.azul.com/azure-only/zulu/apt stable main" && \
    apt-get -qq update && \
    apt-get -qq -y dist-upgrade && \
    apt-get -qq -y --no-install-recommends install zulu-8-azure-jdk=8.58.0.13* && \
    apt-get -qq -y purge gnupg software-properties-common && \
    apt -y autoremove && \
    rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/zulu-8-azure-amd64

#RUN update-alternatives --install /usr/bin/java java /usr/lib/jvm/oracle8/bin/java 2000
#RUN apt remove openjdk-8-jdk

USER jovyan
RUN pip install Jupyterlab==3.1.17 
RUN jupyter labextension install jupyterlab-plotly@5.3.1
