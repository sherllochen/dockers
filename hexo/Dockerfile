#Hexo client
#name: sherllo/hexo-client
FROM node:13-alpine
RUN echo "export LC_ALL=en_US.UTF-8"  >>  /etc/profile 
RUN . /etc/profile
LABEL author=sherllo email=sherllochen@gmail.com
WORKDIR /opt/hexo
RUN npm install -g cnpm --registry=https://registry.npm.taobao.org
RUN npm install hexo-cli -g
RUN apk add --no-cache bash
RUN apk add --no-cache git
RUN apk add --no-cache vim
CMD bash
