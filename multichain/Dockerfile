## -*- docker-image-name: "multichain" -*-
FROM ubuntu:14.04


# install chain-explorer dependencies and some tools
RUN apt-get update \
&& apt-get -y install supervisor \
&& apt-get -y install curl \
&& apt-get install -y sqlite3 libsqlite3-dev \
&& apt-get install -y python-dev \
&& apt-get install -y python-pip \
&& pip install --upgrade pip \
&& pip install pycrypto \
&& apt-get install -y git


RUN pwd
# download and base setup multichain
RUN curl http://www.multichain.com/download/multichain-1.0-alpha-26.tar.gz -o multichain-1.0.tar.gz \
&& tar -xvzf /multichain-1.0.tar.gz \
&& mv multichain-1.0-alpha-26 multichain-1.0 \
&& rm /multichain-1.0.tar.gz \
&& cd multichain-1.0 && ls -la \
&& mv multichaind multichain-cli multichain-util /usr/local/bin

COPY runchain.sh /root/runchain.sh

CMD ["/bin/bash", "/root/runchain.sh"]
