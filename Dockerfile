# Use Ubuntu as base image
FROM ubuntu:18.04 as base

# Project
LABEL project="https://github.com/CAltschaffel/mcbedrock-synology-docker"

# Install dependencies
RUN apt-get update \
	&& apt-get install -y \
	--no-install-recommends \
		gosu \
		screen \
		wget \
		unzip \
		apt-utils \
		libcurl4 \
		libcurl4-openssl-dev \
		ca-certificates curl \
	&& rm -rf /var/lib/apt/lists/*

# Copy projects scripts
COPY ./scripts /scripts

# Create directory structures
RUN useradd -m -d /bedrock bedrock \
  && mkdir /downloads \
  && mkdir /backups \
  && mkdir /bedrock/worlds \
  && chown -R bedrock:bedrock /bedrock \
  && chmod -R 700 /scripts

# User to run
USER root

# Set workdir
WORKDIR /bedrock

# Expose minecraft bedrock port IPv4
EXPOSE 19132/tcp
EXPOSE 19132/udp
# Expose minecraft bedrock port IPv6
EXPOSE 19133/tcp
EXPOSE 19133/udp

# Set Docker entrypoint to Start|Stop server
ENTRYPOINT ["/scripts/entrypoint.sh"]
CMD ["bedrock_server"]

# Configure Container behaviour
ENV BEDROCK_IN_DOCKER_TERM_MIN="1"
ENV BEDROCK_IN_DOCKER_FORCE_RESTORE="0"
ENV BEDROCK_IN_DOCKER_FORCE_1_MIN_RESTART="0"
ENV BEDROCK_IN_DOCKER_RESTART_TIME_UTC="03:00"
