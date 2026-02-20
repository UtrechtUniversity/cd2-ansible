# This is a locally modified version of the upstream CKAN Dockerfile

# See CKAN docs on installation from Docker Compose on usage
FROM ubuntu:noble
LABEL org.opencontainers.image.authors="Yoda team"

# Set timezone
ENV TZ=UTC
RUN apt-get update && apt-get install -y tzdata
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Setting the locale
ENV LC_ALL=en_US.UTF-8
RUN apt-get update
RUN apt-get install --no-install-recommends -y locales
RUN sed -i "/$LC_ALL/s/^# //g" /etc/locale.gen
RUN dpkg-reconfigure --frontend=noninteractive locales
RUN update-locale LANG=${LC_ALL}

# Install basic tools
RUN apt-get install -y wget curl iproute2 sudo less vim

# Define environment variables
ENV ANUBIS_VERSION=1.25.0

# Install Anubis
RUN cd /tmp && \
    wget "https://github.com/TecharoHQ/anubis/releases/download/v${ANUBIS_VERSION}/anubis_${ANUBIS_VERSION}_amd64.deb" && \
    dpkg -i "anubis_${ANUBIS_VERSION}_amd64.deb" && \
    useradd anubis
ADD botpolicies.yml /etc/anubis/botpolicies.yml

# Create data directory
RUN mkdir /anubis_bbolt && \
    chown anubis /anubis_bbolt

ADD anubis-init.sh /anubis-init.sh
RUN chmod +x /anubis-init.sh

EXPOSE 8080

CMD ["/anubis-init.sh"]
