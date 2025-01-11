FROM debian:12.1

RUN apt update && apt install -y \
  git \
  build-essential \
  cmake \
  ninja-build \
  libboost-dev \
  libboost-regex-dev \
  libboost-locale-dev \
  libgoogle-glog-dev \
  libgtest-dev \
  libyaml-cpp-dev \
  libleveldb-dev \
  libmarisa-dev \
  libopencc-dev \
  liblua5.4-dev

COPY / /librime
WORKDIR /librime
RUN bash install-plugins.sh \
  rime/librime-charcode \
  hchunhui/librime-lua \
  WhiredPlanck/librime-quickjs \
  lotem/librime-octagram \
  rime/librime-predict

WORKDIR /librime
RUN cmake -B build -G Ninja \
  -DCMAKE_BUILD_TYPE:STRING=Release \
  -DENABLE_LOGGING:BOOL=ON \
  -DBUILD_TEST:BOOL=ON \
  -DBUILD_STATIC:BOOL=OFF \
  -DBUILD_SHARED_LIBS:BOOL=ON
RUN cmake --build build

WORKDIR /librime/build
RUN ctest
