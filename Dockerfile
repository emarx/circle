FROM  openjdk:8-alpine

ENV SCALA_VERSION 2.12.3
ENV SBT_VERSION 0.13.13
ENV SBT_HOME /usr/local/sbt

RUN apk add --update tar && \
    apk add --update curl && \
    apk add --update wget && \
    apk add --update git && \
    apk add --update python && \
    apk add --update openssh && \
    rm -rf /tmp/* /var/cache/apk/*

ENV PATH ${PATH}:${SBT_HOME}/bin

# Install Scala
## Piping curl directly in tar
RUN \
  curl -fsL https://downloads.lightbend.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz | tar xfz - -C /root/ && \
  echo >> /root/.bashrc && \
  echo 'export PATH=~/scala-$SCALA_VERSION/bin:$PATH' >> /root/.bashrc

# Install sbt
RUN curl -sL "http://dl.bintray.com/sbt/native-packages/sbt/$SBT_VERSION/sbt-$SBT_VERSION.tgz" | gunzip | tar -x -C /usr/local && \
    echo -ne "- with sbt $SBT_VERSION\n" >> /root/.built

# Define working directory
WORKDIR /root

ARG CLOUD_SDK_VERSION=159.0.0
ARG SHA256SUM=5b408575407514f99ad913bd0c6991be4b46408ddc7080a6494bbf43e6ce222a
ENV PATH /google-cloud-sdk/bin:$PATH

# Install gcloud
RUN wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    export PATH=$PWD/google-cloud-sdk/bin:$PATH && \
    export CLOUDSDK_CORE_DISABLE_USAGE_REPORTING=true && \
    gcloud components update --quiet && \
    gcloud --quiet components install kubectl && \
    rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz

VOLUME ["/root/.config"]
