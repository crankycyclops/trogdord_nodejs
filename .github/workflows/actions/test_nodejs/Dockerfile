FROM ubuntu:20.04

RUN apt-get update && apt-get install -y software-properties-common

# Prevents the script from stalling due to requiring the user to pick a timezone
RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true
RUN apt-get install -y tzdata

# Install dependencies for trogdord so we can build and use it for our tests
RUN apt-get -y install sudo bash wget git g++ cmake libasio-dev sqlite3 libsqlite3-dev rapidjson-dev libhiredis-dev libxml2 libxml2-dev liblua5.3 liblua5.3-dev libinih1 libinih-dev redis-server

# Install build dependencies
RUN apt-get update
RUN apt-get -y install git g++ zlib1g-dev libonig-dev libzip5 libzip-dev

# Install Node 12
RUN apt-get -y install curl dirmngr apt-transport-https lsb-release ca-certificates
RUN curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
RUN apt-get update
RUN apt-get -y install nodejs
RUN echo node -v

# Build and install core library
WORKDIR /usr/local/src
RUN git clone https://github.com/crankycyclops/trogdor-pp.git
WORKDIR /usr/local/src/trogdor-pp
RUN cmake -DENABLE_SERIALIZE_JSON=ON -DENABLE_SERIALIZE_SQLITE=ON -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX:PATH=/usr ./src/core
RUN make -j2 trogdor && make install

# Build and install trogdord
WORKDIR /usr/local/src
RUN git clone https://github.com/crankycyclops/trogdord.git
WORKDIR /usr/local/src/trogdord
RUN cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX:PATH=/usr .
RUN make -j2 trogdord && make install

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
