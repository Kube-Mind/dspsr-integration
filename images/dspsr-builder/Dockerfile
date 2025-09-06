ARG DSPSR_BASE_IMAGE="ocr.jcan.dev/library/psrchive:2024.12.02-00.00"
FROM $DSPSR_BASE_IMAGE AS base

ENV DEBIAN_FRONTEND=noninteractive

ARG UID=1000
ARG GID=1000
ARG UNAME=pst

ENV INST=/usr/local
ENV SRC=/home/${UNAME}/src
ENV BUILD=/home/${UNAME}/build

ENV PATH=${PATH}:${INST}/dspsr/bin
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${INST}/dspsr/lib

FROM base AS base-builder

# Create build directories
RUN mkdir -p ${BUILD}/dspsr \
    && chown -R ${UID}:${GID} ${BUILD}

# Copy installation payloads
COPY --chown=${UID}:${GID} ./resources/dspsr ${SRC}/dspsr
COPY --chown=${UID}:${GID} images/dspsr-builder/backends.list /home/${UNAME}/
COPY --chown=${UID}:${GID} images/dspsr-builder/backends.list ${BUILD}/dspsr/backends.list

ENV CUDA_NVCC_FLAGS="-O3 -lineinfo -std=c++17 \
-gencode=arch=compute_80,code=sm_80 \
-gencode=arch=compute_86,code=sm_86 \
-gencode=arch=compute_89,code=sm_89"

# Compile DSPSR
WORKDIR ${SRC}/dspsr
RUN ./bootstrap

WORKDIR ${BUILD}/dspsr
RUN ${SRC}/dspsr/configure \
    --with-cuda-include-dir=/usr/local/cuda/include \
    --with-cuda-lib-dir=/usr/local/cuda/lib64 \
    --prefix=${INST}/dspsr --enable-shared \
    && make -j$(nproc) \
    && make install

COPY ./images/dspsr-builder/dspsr.conf /etc/ld.so.conf.d/

RUN ldconfig
CMD [ "bash" ]