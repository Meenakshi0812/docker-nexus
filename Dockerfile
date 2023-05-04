# Use the latest CentOS image as the base image
FROM centos:latest

# Install required packages
RUN yum -y update && \
    yum -y install java-1.8.0-openjdk-headless wget && \
    yum clean all

# Download and extract Nexus
ENV NEXUS_VERSION=3.35.0
ENV NEXUS_HOME=/opt/nexus
RUN mkdir -p ${NEXUS_HOME} && \
    cd ${NEXUS_HOME} && \
    wget https://download.sonatype.com/nexus/3/nexus-${NEXUS_VERSION}-unix.tar.gz && \
    tar -xzvf nexus-${NEXUS_VERSION}-unix.tar.gz --strip-components=1 && \
    rm -f nexus-${NEXUS_VERSION}-unix.tar.gz

# Copy nexus.properties file
COPY nexus.properties ${NEXUS_HOME}/etc/nexus.properties

# Create a user for Nexus
RUN useradd --user-group --system --home-dir ${NEXUS_HOME} nexus && \
    chown -R nexus:nexus ${NEXUS_HOME} && \
    chmod -R 775 ${NEXUS_HOME}

# Expose the Nexus port
EXPOSE 8081

# Set the user and working directory
USER nexus
WORKDIR ${NEXUS_HOME}

# Start the Nexus server
CMD ["bin/nexus", "run"]
