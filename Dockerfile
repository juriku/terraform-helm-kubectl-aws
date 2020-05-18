FROM alpine:latest

ENV TERRAFORM_VERSION=0.12.25
ENV HELM_VERSION=3.2.1
ENV HELMFILE_VERSION=0.116.0
ENV KUBECTL_VERSION=1.17.5

ENV PATH /google-cloud-sdk/bin:$PATH
RUN apk --no-cache add \
        curl \
        python \
        py-pip \
        bash \
        libc6-compat \
        git \
        gettext \
        coreutils

RUN pip install --upgrade pip awscli

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    chmod +x kubectl && mv kubectl /usr/bin/

RUN wget --quiet https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz \
    && tar -xzf helm-v${HELM_VERSION}-linux-amd64.tar.gz \
    && mv linux-amd64/helm /usr/bin \
    && rm -rf linux-amd64

RUN curl -L -o /usr/bin/helmfile https://github.com/roboll/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_linux_amd64 && \
    chmod +x /usr/bin/helmfile

RUN mkdir -p ~/.helm/plugins && \
    helm plugin install https://github.com/futuresimple/helm-secrets 

RUN wget --quiet https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && mv terraform /usr/bin \
  && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && apk -v --purge del py-pip \
  && rm -rf /tmp/* \
  && rm -rf /var/cache/apk/* \
  && rm -rf /var/tmp/*