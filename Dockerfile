FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y tzdata
RUN ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime && dpkg-reconfigure -f noninteractive tzdata

# Dependencies
RUN apt-get update && apt-get install -y \
    r-base \
    wget \
    curl \
    sudo \
    pandoc \
    gpg \
    libssl-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    libclang-dev \
    libpq5 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

# Diagnostic install block
RUN set -ex; \
    wget https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2025.09.1-401-amd64.deb \
    || curl -LO https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2025.09.1-401-amd64.deb; \
    ls -lh rstudio-server-2025.09.1-401-amd64.deb; \
    dpkg -i rstudio-server-2025.09.1-401-amd64.deb || apt-get -f install -y; \
    rm rstudio-server-2025.09.1-401-amd64.deb

# Create default user
RUN useradd -m rstudio && echo "rstudio:rstudio" | chpasswd && adduser rstudio sudo

EXPOSE 8787

CMD ["/usr/lib/rstudio-server/bin/rserver", "--server-daemonize=0", "--www-port=8787", "--auth-none=1"]