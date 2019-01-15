FROM bash:5

ENV KUBE_VERSION "1.12.4"

COPY config-icp-kube /usr/local/bin/config-icp-kube
RUN apk --no-cache add ncurses ca-certificates openssl curl jq \
    && wget https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 -O /usr/local/bin/dumb-init \
    && wget https://raw.githubusercontent.com/ahmetb/kubectx/v0.6.2/kubectx -O /usr/local/bin/kubectx \
	&& wget https://raw.githubusercontent.com/ahmetb/kubectx/v0.6.2/kubens -O /usr/local/bin/kubens \
    && chmod a+x /usr/local/bin/dumb-init /usr/local/bin/kubectx /usr/local/bin/kubens /usr/local/bin/config-icp-kube \
    && apk --no-cache del ca-certificates openssl
RUN apk --no-cache add ca-certificates openssl \
    && wget https://storage.googleapis.com/kubernetes-release/release/v${KUBE_VERSION}/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl \
    && chmod a+x /usr/local/bin/kubectl \
    && apk --no-cache del ca-certificates openssl

ENTRYPOINT ["/usr/local/bin/dumb-init", "--", "/usr/local/bin/docker-entrypoint.sh"]
CMD ["kubectl"]
