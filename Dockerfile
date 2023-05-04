FROM openjdk:8-jdk-alpine
RUN apk add --no-cache curl tar
RUN curl -L -O https://download.sonatype.com/nexus/3/latest-unix.tar.gz \
    && tar -xzf latest-unix.tar.gz \
    && mv nexus-* nexus \
    && rm latest-unix.tar.gz \
    && adduser -D -h /nexus -s /bin/false nexus \
    && chown -R nexus:nexus /nexus
COPY nexus.properties /nexus/etc/nexus.properties
ENV INSTALL4J_ADD_VM_PARAMS="-Xms2g -Xmx2g -XX:MaxDirectMemorySize=3g"
USER nexus
EXPOSE 8081
WORKDIR /nexus
ENTRYPOINT [ "./bin/nexus", "run" ]