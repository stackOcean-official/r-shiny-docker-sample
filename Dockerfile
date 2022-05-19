FROM ubuntu:jammy

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

## This was not needed before but we need it now
ENV DEBIAN_FRONTEND noninteractive

## Otherwise timedatectl will get called which leads to 'no systemd' inside Docker
ENV TZ UTC+2

WORKDIR /app

RUN apt update
RUN apt-get install -y -qq r-base
# && apt-get install -y libxml2-dev

COPY model model
COPY src src

# Install binaries (see https://datawookie.netlify.com/blog/2019/01/docker-images-for-r-r-base-versus-r-apt/)
COPY ./requirements-bin.txt .
RUN cat requirements-bin.txt | xargs apt-get install -y -qq

# Install remaining packages from source
COPY ./requirements-src.r .
RUN Rscript requirements-src.r

# Clean up package registry
RUN rm -rf /var/lib/apt/lists/*

# CMD ["R"]
CMD Rscript src/predict.r