#Hexo client
#name: sherllo/hexo-client
FROM node:13.5.0-buster
RUN echo "export LC_ALL=en_US.UTF-8"  >>  /etc/profile 
RUN . /etc/profile
LABEL author=sherllo email=sherllochen@gmail.com
WORKDIR /opt/hexo

# Change source to aliyun, can remove if you want
RUN mv /etc/apt/sources.list /etc/apt/sources.list.orig \
&& echo "deb http://mirrors.aliyun.com/debian buster main contrib non-free" >> /etc/apt/sources.list \
&& echo "deb http://mirrors.aliyun.com/debian buster-proposed-updates main contrib non-free" >> /etc/apt/sources.list \
&& echo "deb http://mirrors.aliyun.com/debian buster-updates main contrib non-free" >> /etc/apt/sources.list \
&& echo "deb http://mirrors.aliyun.com/debian-security/ buster/updates main non-free contrib" >> /etc/apt/sources.list

RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    bash git vim

# RUN apk add --no-cache bash
# RUN apk add --no-cache git
# RUN apk add --no-cache vim
RUN npm install -g cnpm --registry=https://registry.npm.taobao.org
RUN npm install hexo-cli -g
RUN apk add --no-cache bash
RUN apk add --no-cache git
RUN apk add --no-cache vim
COPY .travis.yml .travis.yml

CMD bash