# Containerfile for tnk4on/code-server
FROM registry.access.redhat.com/ubi8/ubi
LABEL maintainer="Shion Tanaka / Twitter(@tnk4on)"

# Work directory
WORKDIR /tmp

# Platform: amd64 or arm64
ARG ARCH
ENV VERSION=3.12.0

# code-server: https://github.com/cdr/code-server/releases
RUN dnf update --disableplugin=subscription-manager -y \
&& curl -LO https://github.com/cdr/code-server/releases/download/v${VERSION}/code-server-${VERSION}-${ARCH}.rpm \
&& rpm -ivh code-server-${VERSION}-${ARCH}.rpm \
&& rm -rf code-server-${VERSION}-${ARCH}.rpm \
&& dnf install --disableplugin=subscription-manager --nodocs -y git sudo \
&& dnf clean all \
&& useradd coder \
&& usermod -aG wheel coder \
&& echo -e 'coder\tALL=(ALL)\tNOPASSWD: ALL' > /etc/sudoers.d/020_sudo_for_coder \
&& curl -L -o /usr/share/git-core/contrib/completion/git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash

COPY ./entrypoint.sh /usr/bin/entrypoint.sh
USER coder
WORKDIR /home/coder
EXPOSE 8080/tcp
ENTRYPOINT ["/usr/bin/entrypoint.sh", "--bind-addr", "0.0.0.0:8080", "."]