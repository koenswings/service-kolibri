#####   
# base
#####

FROM ubuntu:jammy as base

ENV NODE_VERSION=18.19.0

# install required packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl \
    software-properties-common \
    gettext \
    git \
    git-lfs \
    psmisc \
    python3 \
    python3-pip \
    python3-sphinx \
    iproute2           # KSW - Added to solve the "missing ip command" error

# add yarn ppa
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# install nodejs and yarn
RUN apt-get update && \
    ARCH=$(dpkg --print-architecture) && \
    curl -sSO https://deb.nodesource.com/node_18.x/pool/main/n/nodejs/nodejs_$NODE_VERSION-1nodesource1_$ARCH.deb && \
    dpkg -i ./nodejs_$NODE_VERSION-1nodesource1_$ARCH.deb && \
    rm nodejs_$NODE_VERSION-1nodesource1_$ARCH.deb && \
    apt-get install yarn

RUN git lfs install

# Check if symbolic links exist before creating them
RUN if [ ! -f /usr/bin/python ]; then ln -s /usr/bin/python3 /usr/bin/python; fi \
 && if [ ! -f /usr/bin/pip ]; then ln -s /usr/bin/pip3 /usr/bin/pip; fi

# copy Kolibri source code into image
COPY . /kolibri

# do the time-consuming base install commands
RUN cd /kolibri \
    && pip3 install -r requirements/dev.txt \
    && pip3 install -r requirements/test.txt \
    && yarn install --network-timeout 100000


#######
# dev build
#######

#FROM learningequality/kolibribase
FROM base as dev

ENV KOLIBRI_RUN_MODE=devserver
ENV KOLIBRI_HTTP_PORT=8000
# yarn devserver port is hardcoded to 8000 so this var is only for info purposes

COPY docker/entrypoint.py /docker/entrypoint.py

COPY . /kolibri
# This copies current source code into container, note code inside the container
# will not change if you change your working dir!
# For this you'll have to add option --volume $$PDW:/kolibri when running container.

WORKDIR /kolibri

ENTRYPOINT ["python", "/docker/entrypoint.py"]

# Install kolibri from source
RUN cd /kolibri \
    && pip install -e .

CMD ["yarn", "run", "devserver"]
