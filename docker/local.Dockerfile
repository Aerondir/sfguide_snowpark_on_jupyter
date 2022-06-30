# Running with locally replatformed to u18 image file https://github.com/almond-sh/almond
FROM almond:ubuntu-18.04
USER root
#RUN apt-get update && apt-get upgrade -y && apt-get install -y openjdk-8-jdk

# Install mitm fake ssl certificate
COPY csrca.crt /usr/local/share/ca-certificates/csrca.crt

RUN apt-get update                             \
 && apt-get install -y --no-install-recommends \
    ca-certificates curl firefox           \
 && rm -fr /var/lib/apt/lists/*                \
 && curl -L https://github.com/mozilla/geckodriver/releases/download/v0.30.0/geckodriver-v0.30.0-linux64.tar.gz | tar xz -C /usr/local/bin

#https://stackoverflow.com/questions/42292444/how-do-i-add-a-ca-root-certificate-inside-a-docker-image
RUN chmod 644 /usr/local/share/ca-certificates/csrca.crt && update-ca-certificates

RUN apt-get update  \
 && apt-get install -y --no-install-recommends \
    software-properties-common  \
    gnupg \
 && add-apt-repository ppa:deadsnakes/ppa  \
 && apt-get -y update \
 && apt-get -y install --no-install-recommends  \
    python3.8 \
 && rm -rf /var/lib/apt/lists/*


# Install oracle jvm https://www.itzgeek.com/how-tos/linux/debian/how-to-install-oracle-java-8-on-debian-9-ubuntu-linux-mint.html
# Oracle is periodically removing older versions from the downloads - when that happens one needs to go to
# See: https://gist.github.com/wavezhang/ba8425f24a968ec9b2a8619d7c2d86a6
RUN  curl -Lo jdk-11.0.15_linux-x64_bin.deb https://cfdownload.adobe.com/pub/adobe/coldfusion/java/java11/java11015/jdk-11.0.15_linux-x64_bin.deb \
     && apt-get install -y  \
        ./jdk-11.0.15_linux-x64_bin.deb \
     && rm -rf /var/lib/apt/lists/* \
     && rm -f jdk-11.0.15_linux-x64_bin.deb

RUN update-ca-certificates

#Set the default java version
RUN update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk-11/bin/java 2000
RUN update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/jdk-11/bin/javac 2000
ENV PATH="/usr/lib/jvm/jdk-11/bin:${PATH}"
ENV JAVA_HOME=/usr/lib/jvm/jdk-11
ENV J2SDKDIR=/usr/lib/jvm/jdk-11

RUN apt-get update && apt-get -y install \
    libgnome2-0 \
    && rm -rf /var/lib/apt/lists/*

USER jovyan
ENV PATH="/usr/lib/jvm/jdk-11/bin:${PATH}"
ENV JAVA_HOME=/usr/lib/jvm/jdk-11
#RUN pip install Jupyterlab
#RUN pip install plotly
#RUN pip install Jupyterlab==3.1.17
#RUN jupyter labextension install jupyterlab-plotly@5.3.1
