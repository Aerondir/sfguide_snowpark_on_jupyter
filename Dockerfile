#
#  This Dockerfile creates a docker image from the base image https://hub.docker.com/r/almondsh/almond 
#
ARG almond_version=0.10.9
ARG scala_kernel_version=2.12.12
FROM almondsh/almond:$almond_version-scala-$scala_kernel_version
USER root
RUN apt-get update && apt-get install -y wget apt-transport-https gnupg
COPY creds/csrca.crt /usr/local/share/ca-certificates/csrca.crt
RUN apt-get update && \
    apt-get install -y \
    ca-certificates

RUN update-ca-certificates

#wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public --ca-certificate=/usr/local/share/ca-certificates/csrca.crt
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    rm -rf /var/lib/apt/lists/*

#https://askubuntu.com/questions/971877/cannot-add-ppa-user-or-team-does-not-exist
#it was company's man-in-the-middle fake SSL certificate that caused this
RUN add-apt-repository -y ppa:ts.sch.gr/ppa && \
    apt-get update && \
    apt-get install -y \
    oracle-java8-installer

#https://stackoverflow.com/questions/42292444/how-do-i-add-a-ca-root-certificate-inside-a-docker-image
RUN chmod 644 /usr/local/share/ca-certificates/csrca.crt && update-ca-certificates