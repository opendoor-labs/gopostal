FROM debian:buster

RUN apt-get update && apt-get install -y \
  autoconf \
  automake \
  libtool \
  pkg-config \
  wget \
  make \
  curl

ARG LIBPOSTAL_VERSION=v1.0.0

ENV LIBPOSTAL_DIR=/opt/libpostal
ENV LIBPOSTAL_DATA_DIR=/opt/libpostal_data

RUN wget https://github.com/openvenues/libpostal/archive/$LIBPOSTAL_VERSION.tar.gz
RUN mkdir -p $LIBPOSTAL_DIR
RUN tar -xvzf $LIBPOSTAL_VERSION.tar.gz -C $LIBPOSTAL_DIR --strip 1
WORKDIR $LIBPOSTAL_DIR
RUN ls
RUN ./bootstrap.sh
RUN ./configure --datadir=$LIBPOSTAL_DATA_DIR --disable-dependency-tracking
RUN make
RUN make install
