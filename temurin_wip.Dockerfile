#
#  This temurin_wip.Dockerfile creates a docker image from the base image https://hub.docker.com/r/almondsh/almond
#
ARG almond_version=0.13.0
ARG scala_kernel_version=2.12.15
#FROM almondsh/almond:$almond_version-scala-$scala_kernel_version
FROM almondsh/almond:latest
USER root
RUN apt-get update && apt-get install -y wget apt-transport-https gnupg2 xdg-utils

#RUN  wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | apt-key add -
#  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 74885C03 && \

RUN wget --no-check-certificate -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | apt-key add -

RUN \
  echo "deb https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list && \
  apt-get update && \
  apt-get install -y \
    temurin-8-jdk \
    ca-certificates

RUN update-ca-certificates

USER jovyan
RUN pip install Jupyterlab==3.1.17 
RUN jupyter labextension install jupyterlab-plotly@5.3.1
