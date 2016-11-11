FROM microsoft/azure-cli

ENV K8S_VERSION=k8s1-1-1
ENV QD_HOME=/mnt/qd
ENV QD_KUBECTL=/mnt/kubectl
ENV PATH=${PATH}:${QD_KUBECTL}
WORKDIR ${QD_HOME}

RUN mkdir -p ${QD_KUBECTL}
RUN curl -L -o ${QD_KUBECTL}/kubectl https://softrepo.blob.core.chinacloudapi.cn/${K8S_VERSION}/kubectl-linux-386
RUN chmod +x ${QD_KUBECTL}/kubectl
