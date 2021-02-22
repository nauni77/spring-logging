FROM ubuntu:latest

ARG GEMATIK_GIT_TAG
ENV APP_USER bls19

# do not ask interactive => pkg-config needs tzdata and this ask by default for location
ENV DEBIAN_FRONTEND="noninteractive" TZ="Europe/Berlin"

# update and upgrade to latest versions and install ubuntu packages
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        build-essential \
        openjdk-11-jre \
        && \
    rm -rf /var/lib/apt/lists/*

# add user und group for build and run
#RUN useradd -ms /bin/bash "${APP_USER}" && \
#    chown -R "${APP_USER}":root /application

RUN useradd -ms /bin/bash "${APP_USER}"
RUN mkdir /application
RUN chown -R "${APP_USER}:root" /application

USER ${APP_USER}

WORKDIR /application

USER root
ADD assets/entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh && chown "${APP_USER}:root" /entrypoint.sh && \
    mkdir /exchange && \
    chmod 755 /exchange && chown "${APP_USER}:root" /exchange
USER "${APP_USER}"

#### add the spring boot application
ARG DEPENDENCY=build/extractedJar
COPY ${DEPENDENCY}/BOOT-INF/lib /application/bootapp/lib
COPY ${DEPENDENCY}/META-INF /application/bootapp/META-INF
COPY ${DEPENDENCY}/BOOT-INF/classes /application/bootapp

CMD ["/entrypoint.sh"]
