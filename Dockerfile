FROM hseeberger/scala-sbt

ARG CLOUD_SDK_VERSION=159.0.0
ARG SHA256SUM=5b408575407514f99ad913bd0c6991be4b46408ddc7080a6494bbf43e6ce222a
ENV PATH /google-cloud-sdk/bin:$PATH

# Install gcloud
RUN wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    export PATH=$PWD/google-cloud-sdk/bin:$PATH && \
    export CLOUDSDK_CORE_DISABLE_USAGE_REPORTING=true && \
    gcloud components update --quiet && \
    gcloud --quiet components install kubectl

# Install Node
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && apt-get install -y nodejs

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get install -y apt-transport-https && \
    apt-get update && \
    apt-get install -y yarn ruby-full parallel && \
    yarn config set workspaces-experimental true && \
    echo "will cite" | parallel --citation

VOLUME ["/root/.config"]
