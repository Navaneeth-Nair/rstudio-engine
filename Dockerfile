# Use Ubuntu base image
FROM ubuntu:22.04

# Avoid timezone prompt
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y tzdata

# Set timezone to UTC automatically
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
    && rm -rf /var/lib/apt/lists/*

# Install RStudio Server
RUN wget https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2023.09.1-494-amd64.deb \
    && gdebi -n rstudio-server-2023.09.1-494-amd64.deb \
    && rm rstudio-server-2023.09.1-494-amd64.deb

# Create an RStudio user
RUN useradd -m rstudio && echo "rstudio:rstudio" | chpasswd && adduser rstudio sudo

# Expose port 8787 (RStudio default)
EXPOSE 8787

# Start RStudio Server
CMD ["/usr/lib/rstudio-server/bin/rserver", "--server-daemonize=0", "--www-port=8787", "--auth-none=1"]