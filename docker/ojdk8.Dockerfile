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

#source    https://github.com/DataDog/dd-trace-java-docker-build/blob/master/Dockerfile
# Install oracle jvm
# Oracle is periodically removing older versions from the downloads - when that happens one needs to go to
# https://www.oracle.com/java/technologies/javase/javase-jdk8-downloads.html to figure out the correct new link.
# !IMPORTANT! Replace '/otn/' with '/otn-pub/' to work around Oracle login issue
# See: https://gist.github.com/wavezhang/ba8425f24a968ec9b2a8619d7c2d86a6
RUN wget -q -O /tmp/oracle-jdk8.tar.gz -c --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" "https://javadl.oracle.com/webapps/download/GetFile/1.8.0_331-b09/165374ff4ea84ef0bbd821706e29b123/linux-i586/jdk-8u331-linux-x64.tar.gz"
RUN tar xzf /tmp/oracle-jdk8.tar.gz -C /usr/lib/jvm/
RUN mv /usr/lib/jvm/jdk1.8.0_331 /usr/lib/jvm/oracle8
RUN rm -f /tmp/oracle-jdk8.tar.gz

RUN update-alternatives --install /usr/bin/java java /usr/lib/jvm/oracle8/bin/java 2000

# install missing from ubuntu 20.04 gnome2 library
# because java sucks
# https://github.com/gdelmas/IntelliJDashPlugin/issues/73#issuecomment-396226710
RUN apt-get install -y software-properties-common && \
    rm -rf /var/lib/apt/lists/*

RUN add-apt-repository universe
RUN set -eux; \
    echo 'deb http://archive.ubuntu.com/ubuntu bionic universe' >> "/etc/apt/sources.list.d/bionic.list"; \
    echo 'deb http://archive.ubuntu.com/ubuntu bionic multiverse' >> "/etc/apt/sources.list.d/bionic.list"; \
    echo 'deb http://archive.ubuntu.com/ubuntu bionic-security main' >> "/etc/apt/sources.list.d/bionic.list";


RUN apt-get update && apt-get -y install libgnome2-0

USER jovyan
RUN pip install Jupyterlab==3.1.17
RUN jupyter labextension install jupyterlab-plotly@5.3.1
