FROM ubuntu:precise
RUN apt-get -qq update && apt-get -y install git \
                                        python \
                                        python-dev \
                                        python-pip \
                                        python-setuptools \
                                        build-essential \
                                        gcc \
                                        g++ \
                                        libxml2-dev \
                                        libxslt-dev \
                                        lib32z1-dev \
                                        libffi-dev \
                                        libmysqlclient-dev \
                                        pkg-config \
                                        python-lxml \
                                        curl \
                                        tnef \
                                        stow \
                                        lua5.2 \
                                        liblua5.2-dev \
                                        netcat

RUN cd $(mktemp -d) && \
    curl -LO https://github.com/jedisct1/libsodium/releases/download/1.0.0/libsodium-1.0.0.tar.gz && \
    tar -xzf libsodium-1.0.0.tar.gz && \
    cd libsodium-1.0.0 && \
    ./configure --prefix=/usr/local/stow/libsodium-1.0.0 && \
    make -j4 && \
    rm -fr /usr/local/stow/libsodium-1.0.0 && \
    mkdir -p /usr/local/stow/libsodium-1.0.0 && \
    make install && \
    stow -d /usr/local/stow -R libsodium-1.0.0 && \
    ldconfig && \
    cd .. && \
    rm -fr libsodium-1.0.0 libsodium-1.0.0.tar.gz

RUN pip install 'pip==7.1.2' 'setuptools>=5.3' && hash pip && pip install 'pip==7.1.2' 'setuptools>5.3' && pip install tox
RUN git clone https://github.com/nylas/sync-engine.git /app
WORKDIR /app
RUN SODIUM_INSTALL=system pip install -r requirements.txt -q && pip install -e .
RUN mkdir -p /etc/inboxapp && \
    install -m0600 ./etc/config-dev.json /etc/inboxapp/config.json && \
    install -m0600 ./etc/secrets-dev.yml /etc/inboxapp/secrets.yml
RUN useradd -m inboxapp && chown -R inboxapp:inboxapp /etc/inboxapp && mkdir /var/lib/inboxapp && chown -R inboxapp:inboxapp /var/lib/inboxapp
USER inboxapp
VOLUME /app /var/lib/inboxapp /etc/inboxapp
COPY wait-for-mysql.sh /bin/wait-for-mysql.sh
CMD bin/inbox-start
