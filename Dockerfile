FROM debian:bullseye
RUN DEBIAN_FRONTEND=noninteractive apt clean && DEBIAN_FRONTEND=noninteractive apt update && DEBIAN_FRONTEND=noninteractive apt -y full-upgrade

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --no-install-recommends \
    apt-transport-https \
    apt-utils \
    ca-certificates \
    curl \
    git \
    iputils-ping \
    jq \
    lsb-release \
    software-properties-common

RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Can be 'linux-x64', 'linux-arm64', 'linux-arm', 'rhel.6-x64'.
ENV TARGETARCH=linux-x64

WORKDIR /azp

COPY ./start.sh .
COPY ./installdeps.sh .

RUN chmod +x start.sh installdeps.sh

run export DEBIAN_FRONTEND=noninteractive && ./installdeps.sh

ENTRYPOINT [ "./start.sh" ]
