ARG SKA_PST_BUILDTOOLS_BASE_IMAGE="harbor.skao.int/production/ska-build-cuda:0.2.0"

FROM $SKA_PST_BUILDTOOLS_BASE_IMAGE AS base

ENV DEBIAN_FRONTEND=noninteractive
ENV LD_LIBRARY_PATH=/usr/local/lib/

ARG APT_DEPENDENCIES_PATH=/tmp/apt.txt
# Copy installation payloads
COPY ./images/psrchive-builder/apt.txt ${APT_DEPENDENCIES_PATH}
COPY ./images/psrchive-builder/apt.txt /tmp/pip.txt
COPY ./resources/psrdada /mnt/ska-pst-buildtools/resources/psrdada
COPY ./images/psrchive-builder/ctest2junit.xsl /usr/local/share/ctest2junit/
COPY ./images/psrchive-builder/ctest2junit /usr/local/bin/

WORKDIR /mnt/ska-pst-buildtools

# Prepare environment
RUN stat ${APT_DEPENDENCIES_PATH} \
    && apt-get update -y \
    && apt upgrade -y \
    && apt-get install --no-install-recommends --no-install-suggests -y $(cat ${APT_DEPENDENCIES_PATH}) \
    && apt-get autoremove --yes \
    && rm -rf /var/lib/apt/lists/*

    # start with the base image as a builder, so we can return to this later
FROM base AS base-builder

ENV DEBIAN_FRONTEND=noninteractive
ENV LD_LIBRARY_PATH=/usr/local/lib

# Prepare environment for PSRDADA
ARG PSRDADA=psrdada
WORKDIR /mnt/${PSRDADA}-build

# Compile PSRDADA without IBVERBS and RDMACM
# CUDA architectures 80:A100, 86:A40, 89:L40, supported by CUDA 12.4.0
RUN cmake /mnt/ska-pst-buildtools/resources/${PSRDADA} \
        -DCMAKE_CUDA_ARCHITECTURES="80;86;89" \
        -DCMAKE_DISABLE_FIND_PACKAGE_rdmacm=TRUE \
        -DCMAKE_DISABLE_FIND_PACKAGE_ibverbs=TRUE \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr/local/psrdada \
        -DBUILD_TESTING=OFF \
    && make -j$(nproc) install \
    && ldconfig

ARG GOOGLETEST_VERSION=1.17.0
ARG GOOGLETEST_RELEASE_URL=https://github.com/google/googletest/archive/refs/tags
ARG GOOGLETEST_RELEASE_FILE=v${GOOGLETEST_VERSION}.tar.gz
ARG GOOGLETEST_FILE_FOLDER=googletest-${GOOGLETEST_VERSION}
ARG GOOGLETEST=googletest

WORKDIR /mnt/${GOOGLETEST}
RUN curl -L -O ${GOOGLETEST_RELEASE_URL}/${GOOGLETEST_RELEASE_FILE} \
    && stat ${GOOGLETEST_RELEASE_FILE} \
    && tar -xvf ${GOOGLETEST_RELEASE_FILE} \
    && stat ${GOOGLETEST_FILE_FOLDER}

WORKDIR /mnt/${GOOGLETEST}-build
RUN cmake /mnt/${GOOGLETEST}/${GOOGLETEST_FILE_FOLDER} \
      -DCMAKE_INSTALL_PREFIX=/usr/local/googletest \
    && make -j$(nproc) install \
    && ldconfig


FROM base AS base-runtime

COPY ./images/psrchive-builder/pst-builder.conf /etc/ld.so.conf.d/

# Install runtime dependencies, build artefacts
# COPY --from=base-builder /builder/usr/local/psrdada /usr/local/psrdada
# COPY --from=base-builder /builder/usr/local/googletest /usr/local/googletest
RUN --mount=type=bind,from=base-builder,target=/builder \
    cp -rd /builder/usr/local/psrdada /usr/local/psrdada \
    && cp -rd /builder/usr/local/googletest /usr/local/googletest \
    && ldconfig

ENV \
  PKG_CONFIG_PATH=/usr/local/psrdada/lib/pkgconfig:/usr/local/grpc/lib/pkgconfig:/usr/local/spdlog/lib/pkgconfig:/usr/local/googletest/lib/pkgconfig \
  LD_LIBRARY_PATH=/usr/local/psrdada/lib:/usr/local/grpc/lib:/usr/local/spdlog/lib:/usr/local/googletest/lib: \
  PATH=$PATH:/usr/local/cuda/bin:/usr/local/psrdada/bin:/usr/local/grpc/bin:/usr/local/protoc-gen-doc/bin \
  GTEST_ROOT=/usr/local/googletest \
  PSRDADA_ROOT_DIR=/usr/local/psrdada
