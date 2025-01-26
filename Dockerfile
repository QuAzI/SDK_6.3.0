FROM debian:bookworm-slim

LABEL maintainer="https://github.com/Skeeve"

RUN apt-get update \
 && apt-get upgrade --yes \
 && apt-get install --yes \
    locales \
    htop \
    git \
    build-essential \
    curl \
	subversion \
 && rm -rf /var/lib/apt/lists/* \
 && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

# ENV SDK_ARCH=A13
# ENV SDK_ARCH=iMX6
ENV SDK_ARCH=B288
ENV SDK_BASE=/SDK
ENV SDK_BRANCH=6.5
#ENV SDK_URL=https://github.com/pocketbook/SDK_6.3.0/tree/6.5/SDK-${SDK_ARCH}
ENV SDK_URL=https://github.com/pocketbook/SDK_6.3.0

#ENV CMAKE_VERSION=3.21.3
ENV CMAKE_VERSION=3.31.5
ENV CMAKE_URL=https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}

ENV CMAKE_TOOLCHAIN_FILE=${SDK_BASE}/share/cmake/arm_conf.cmake

# Prepare SDK
WORKDIR "/repo"
RUN git clone ${SDK_URL} .
RUN git checkout ${SDK_BRANCH}

VOLUME "/project"
WORKDIR "/project"

RUN ln -s /repo/SDK-${SDK_ARCH} ${SDK_BASE} \
 && ${SDK_BASE}/bin/update_path.sh \
 && chmod +x $BASEPATH/*/usr/bin/pbres

# Get cmake
RUN CMAKE="cmake-${CMAKE_VERSION}-linux-$( uname -m )" \
 && curl -L --silent ${CMAKE_URL}/${CMAKE}.tar.gz | tar xvzf - --strip-components=1 --directory=/usr \
;

ENTRYPOINT [ "bash" ]
