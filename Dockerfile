FROM centos:latest

RUN yum -y update && \
    yum -y install java-1.8.0-openjdk-headless wget && \
    yum clean all

ENV NEXUS_HOME=/opt/nexus
RUN mkdir -p ${NEXUS_HOME}

ENV NEXUS_VERSION=3.35.0
RUN cd ${NEXUS_HOME} && \
    wget https://download.sonatype.com/nexus/3/nexus-${NEXUS_VERSION}-unix.tar.gz && \
    tar -xzvf nexus-${NEXUS_VERSION}-unix.tar.gz --strip-components=1 && \
    rm -f nexus-${NEXUS_VERSION}-unix.tar.gz

COPY nexus.properties ${NEXUS_HOME}/etc/nexus.properties

RUN useradd --user-group --system --home-dir ${NEXUS_HOME} nexus && \
    chown -R nexus:nexus ${NEXUS_HOME} && \
    chmod -R 775 ${NEXUS_HOME}

EXPOSE 8081

USER nexus
WORKDIR ${NEXUS_HOME}

CMD ["bin/nexus", "run"]
