FROM python:3.10-slim

ENV KUBECTL_VERSION="v1.29.0"
ENV HELM_VERSION="v3.14.0"

RUN apt-get update && \
    apt-get install -y curl bash git && \
    curl -LO https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    curl -LO https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz && \
    tar -zxvf helm-${HELM_VERSION}-linux-amd64.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    rm -rf *.tar.gz linux-amd64 && \
    apt-get clean

CMD ["cat"]
