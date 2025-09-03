ARG PSRCHIVE_BASE_IMAGE="ocr.jcan.dev/library/psrchive-builder:latest"
FROM $PSRCHIVE_BASE_IMAGE AS base

ARG UID=1000
ARG GID=1000
ARG UNAME=pst

ARG DEPENDENCIES_PATH=/mnt/ska-pst-psrchive/dependencies/ska-pst-psrchive
ARG APT_DEPENDENCIES_PATH=/tmp/psrchive.apt.txt

ENV DEBIAN_FRONTEND=noninteractive

# copy installation payload required for APT packages
COPY ./images/psrchive/apt.txt ${APT_DEPENDENCIES_PATH}

# Prepare environment
RUN stat ${APT_DEPENDENCIES_PATH} \
    && apt-get update -y \
    && apt upgrade -y \
    && apt-get install -y --reinstall ca-certificates \
    && update-ca-certificates \
    && apt-get install --no-install-recommends --no-install-suggests -y $(cat ${APT_DEPENDENCIES_PATH}) \
    && apt-get autoremove --yes \
    && rm -rf /var/lib/apt/lists/*

ENV INST=/usr/local
ENV SRC=/home/${UNAME}/src
ENV BUILD=/home/${UNAME}/build
ENV PGPLOT_DIR=/usr/lib/pgplot5
ENV PGPLOT_FONT=${PGPLOT_DIR}/grfont.dat
ENV TEMPO2=${INST}/tempo2
ENV PSRCAT_FILE=${INST}/psrchive/psrcat/psrcat.db
ENV PATH=${PATH}:${INST}/tempo2/bin:${INST}/psrchive/bin
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${INST}/tempo2/lib:${INST}/psrchive/lib
ENV PYTHONPATH=${INST}/psrchive/lib/python3.10/site-packages
ENV PKG_CONFIG_PATH=${PKG_CONFIG_PATH}:${INST}/psrchive/lib/pkgconfig

RUN groupadd -g $GID $UNAME && \
    useradd -m -u $UID -g $GID -s /bin/bash $UNAME

# Copy installation payload
COPY --chown=${UID}:${GID} images/psrchive/psrchive.cfg /home/${UNAME}/.psrchive.cfg

# start with the base image as a builder, so we can return to this later
FROM base AS base-builder

ARG UID=1000
ARG GID=1000
ARG UNAME=pst

# create source and build directories as the production user
RUN mkdir -p ${SRC} ${BUILD}/psrchive && \
    chown -R ${UID}:${GID} ${SRC} ${BUILD}

# Sync submodules
COPY --chown=${UID}:${GID} resources/psrchive ${SRC}/psrchive

# Compile PSRCHIVE
WORKDIR ${SRC}/psrchive
RUN ./bootstrap

WORKDIR ${BUILD}/psrchive
RUN ${SRC}/psrchive/configure --prefix=${INST} --enable-shared \
    && ./packages/tempo2.csh && \
    ${SRC}/psrchive/configure --prefix=${INST}/psrchive --enable-shared \
    && ./packages/splinter.csh \
    && ./packages/psrcat.csh && \
    ${SRC}/psrchive/configure --prefix=${INST}/psrchive --enable-shared \
    && make -j$(nproc) \
    && make install

# Copy just the built products from base-builder to base-runtime to minimize final image size
FROM base AS base-runtime

COPY ./images/psrchive/ska-pst-psrchive.conf /etc/ld.so.conf.d/

RUN --mount=type=bind,from=base-builder,target=/builder \
    cp -rd /builder${INST}/tempo2 ${INST}/tempo2 && \
    cp -rd /builder${INST}/psrchive ${INST}/psrchive && \
    ldconfig

# RUNTIME TEST
RUN psrchive_config

WORKDIR /home/${UNAME}
CMD ["/bin/bash"]
