FROM alpine:3.8

ENV LANG C.UTF-8

RUN { \
		echo '#!/bin/sh'; \
		echo 'set -e'; \
		echo; \
		echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
	} > /usr/local/bin/docker-java-home \
	&& chmod +x /usr/local/bin/docker-java-home
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
ENV PATH $PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin

ENV JAVA_VERSION 8u181
ENV JAVA_ALPINE_VERSION 8.181.13-r0

RUN set -x \
	&& apk add --no-cache \
		openjdk8="$JAVA_ALPINE_VERSION" \
&& [ "$JAVA_HOME" = "$(docker-java-home)" ]

wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-3.2.0.1227-linux.zip && \ unzip sonar-scanner-cli-3.2.0.1227-linux.zip && \ cd /usr/bin && ln -s /sonar-scanner-3.2.0.1227-linux/bin/sonar-scanner sonar-scanner && \ apk del wget && \ ln -s /usr/bin/sonar-scanner-run.sh /bin/sonar-scanner COPY sonar-scanner-run.sh /usr/bin

apk add --no-cache openssh
