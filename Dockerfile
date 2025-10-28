FROM ubuntu:22.04

# Avoid timezone prompts
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y tzdata
RUN ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime && dpkg-reconfigure -f noninteractive tzdata

# Install dependencies
RUN apt-get update && apt-get install -y \
    software-properties-common \
    apt-transport-https \
    wget \
    gpg \
    sudo \
    r-base \
    pandoc \
    libssl-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

# Add Posit (RStudio) repo
RUN wget -qO- https://repos.rstudio.com/rstudio-server/jammy/amd64/Packages | head -n 10 || true
RUN wget -qO- https://package-manager.rstudio.com/posit.gpg | gpg --dearmor -o /usr/share/keyrings/posit.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/posit.gpg] https://package-manager.rstudio.com/all/jammy/latest main" > /etc/apt/sources.list.d/posit.list

# Install RStudio Server from Posit APT repo
RUN apt-get update && apt-get install -y rstudio-server

# Create user
RUN useradd -m rstudio && echo "rstudio:rstudio" | chpasswd && adduser rstudio sudo

EXPOSE 8787

CMD ["/usr/lib/rstudio-server/bin/rserver", "--server-daemonize=0", "--www-port=8787", "--auth-none=1"]