FROM amazoncorretto:25

ARG MAVEN_VERSION=3.9.11

RUN dnf install -y git tar gzip findutils procps-ng which \
    && dnf clean all \
    && curl -fsSL https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    | tar -xz -C /opt \
    && ln -s /opt/apache-maven-${MAVEN_VERSION}/bin/mvn /usr/local/bin/mvn

RUN curl -fsSL https://claude.ai/install.sh | bash

ENV PATH=/root/.local/bin:$PATH \
CLAUDE_CONFIG_DIR=/root/.claude \
DISABLE_AUTOUPDATER=1 \
IS_SANDBOX=1