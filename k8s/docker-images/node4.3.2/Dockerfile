FROM ubuntu



RUN apt-get update \
 && apt-get install -y  rlwrap mongodb curl python  python2.7 python2.7-dev  \
 && apt-get upgrade -y --force-yes \
 && rm -rf /var/lib/apt/lists/*;

RUN export PYTHON='/usr/bin/python'

RUN curl https://deb.nodesource.com/node_4.x/pool/main/n/nodejs/nodejs_4.3.2-1nodesource1~trusty1_amd64.deb > node.deb \
 && dpkg -i node.deb \
 && rm node.deb

RUN npm install -g pangyp\
 && npm install -g cnpm --registry=https://registry.npm.taobao.org \
 && ln -s $(which pangyp) $(dirname $(which pangyp))/node-gyp\
 && npm cache clear

ENV NODE_ENV production
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY ./README.md /usr/src/app 
COPY ./package.json /usr/src/app

CMD ["tailf", "/var/log/dpkg.log"]
