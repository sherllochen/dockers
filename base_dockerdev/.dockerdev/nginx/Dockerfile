ARG RUBY_VERSION
FROM ruby:$RUBY_VERSION

# Change source to aliyun, can remove if you want
RUN mv /etc/apt/sources.list /etc/apt/sources.list.orig \
&& echo "deb http://mirrors.aliyun.com/debian buster main contrib non-free" >> /etc/apt/sources.list \
&& echo "deb http://mirrors.aliyun.com/debian buster-proposed-updates main contrib non-free" >> /etc/apt/sources.list \
&& echo "deb http://mirrors.aliyun.com/debian buster-updates main contrib non-free" >> /etc/apt/sources.list \
&& echo "deb http://mirrors.aliyun.com/debian-security/ buster/updates main non-free contrib" >> /etc/apt/sources.list

RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -yq apt-utils gnupg gnupg2 gnupg1 vim
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
RUN sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger buster main > /etc/apt/sources.list.d/passenger.list'
RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -yq nginx-extras libnginx-mod-http-passenger
RUN if [ ! -f /etc/nginx/modules-enabled/50-mod-http-passenger.conf ]; then sudo ln -s /usr/share/nginx/modules-available/mod-http-passenger.load /etc/nginx/modules-enabled/50-mod-http-passenger.conf ; fi

COPY ./mod-http-passenger.conf /etc/nginx/conf.d/mod-http-passenger.conf
RUN mv /etc/nginx/sites-enabled/default /etc/nginx/sites-enabled/default.bk
COPY ./app_config /etc/nginx/sites-enabled/default

CMD ["service" ,"nginx", "start"]