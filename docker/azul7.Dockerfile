#
#  This jdk_test.Dockerfile creates a docker image from the base image https://hub.docker.com/r/almondsh/almond
#
ARG almond_version=0.10.9
ARG scala_kernel_version=2.12.12
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
    apt-get -qq -y --no-install-recommends install zulu-7-azure-jdk=7.50.0.11* && \
    apt-get -qq -y purge gnupg software-properties-common && \
    apt -y autoremove && \
    rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/zulu-7-azure-amd64

#azul needs more graphics libs
RUN apt-get update && apt-get install -y mesa-utils libgl1-mesa-glx

# install missing from ubuntu 20.04 gnome2 library
# because java sucks
# https://github.com/gdelmas/IntelliJDashPlugin/issues/73#issuecomment-396226710
#RUN apt-get install -y software-properties-common && \
#    rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    echo 'deb http://archive.ubuntu.com/ubuntu bionic universe' >> "/etc/apt/sources.list.d/bionic.list"; \
    echo 'deb http://archive.ubuntu.com/ubuntu bionic multiverse' >> "/etc/apt/sources.list.d/bionic.list"; \
    echo 'deb http://archive.ubuntu.com/ubuntu bionic-security main' >> "/etc/apt/sources.list.d/bionic.list";


RUN apt-get update && apt-get -y install libgnome2-0

#RUN update-alternatives --install /usr/bin/java java /usr/lib/jvm/oracle8/bin/java 200
#RUN apt-get remove openjdk-8-jdk
#RUN apt-get update && \
#  apt-get install -y \
#    openjdk-11-jdk

USER jovyan
RUN pip install Jupyterlab==3.1.17 
RUN jupyter labextension install jupyterlab-plotly@5.3.1
