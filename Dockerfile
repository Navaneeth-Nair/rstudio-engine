# Use Ubuntu base image
FROM ubuntu:22.04

# Avoid timezone prompt
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y tzdata
RUN ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime && dpkg-reconfigure -f noninteractive tzdata

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    gdebi-core \
    r-base \
    sudo \
    pandoc \
    libssl-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    apt-transport-https \
    && rm -rf /var/lib/apt/lists/*

# Download & install RStudio SERVER (not Desktop)
WORKDIR /tmp
RUN wget https://download1.rstudio.org/server/jammy/amd64/rstudio-server-2025.09.1-401-amd64.deb \
    && gdebi -n rstudio-server-2025.09.1-401-amd64.deb \
    && rm rstudio-server-2025.09.1-401-amd64.deb

# Create RStudio user
RUN useradd -m rstudio && echo "rstudio:rstudio" | chpasswd && adduser rstudio sudo

# Expose port 8787 (RStudio default)
EXPOSE 8787

# Start RStudio Server
CMD ["/usr/lib/rstudio-server/bin/rserver", "--server-daemonize=0", "--www-port=8787", "--auth-none=1"]