FROM alpine:3.12

ENV TERRAFORM_VERSION=0.14.3
ENV HELM_VERSION=v3.4.2
ARG HELMFILE_VERSION=v0.135.0
ARG KUBECTL_VERSION=1.18.14
ENV SOPS_VERSION=3.6.1

RUN apk --no-cache add \
        curl \
        jq \
        python3 \
        py3-pip \
        bash \
        libc6-compat \
        git \
        gettext \
        coreutils

RUN pip3 install --upgrade pip awscli

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    chmod +x kubectl && mv kubectl /usr/bin/

RUN curl -L -o /usr/local/bin/sops https://github.com/mozilla/sops/releases/download/v${SOPS_VERSION}/sops-v${SOPS_VERSION}.linux && \
    chmod +x /usr/local/bin/sops

RUN wget --quiet https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz \
    && tar -xzf helm-${HELM_VERSION}-linux-amd64.tar.gz \
    && mv linux-amd64/helm /usr/bin \
    && rm -rf linux-amd64

RUN curl -L -o /usr/bin/helmfile https://github.com/roboll/helmfile/releases/download/${HELMFILE_VERSION}/helmfile_linux_amd64 && \
    chmod +x /usr/bin/helmfile

RUN mkdir -p ~/.helm/plugins && \
    helm plugin install https://github.com/databus23/helm-diff && \
    helm plugin install https://github.com/hypnoglow/helm-s3.git && \
    helm plugin install https://github.com/futuresimple/helm-secrets 

RUN wget --quiet https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && mv terraform /usr/bin \
  && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && apk -v --purge del py-pip \
  && rm -rf /tmp/* \
  && rm -rf /var/cache/apk/* \
  && rm -rf /var/tmp/*