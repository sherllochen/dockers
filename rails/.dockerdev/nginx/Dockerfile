ARG RUBY_VERSION
FROM ruby:$RUBY_VERSION
ARG NODE_MAJOR
ARG BUNDLER_VERSION
ARG YARN_VERSION
ARG WORKDIR

# Change source to aliyun, can remove if you want
RUN mv /etc/apt/sources.list /etc/apt/sources.list.orig \
&& echo "deb http://mirrors.aliyun.com/debian buster main contrib non-free" >> /etc/apt/sources.list \
&& echo "deb http://mirrors.aliyun.com/debian buster-proposed-updates main contrib non-free" >> /etc/apt/sources.list \
&& echo "deb http://mirrors.aliyun.com/debian buster-updates main contrib non-free" >> /etc/apt/sources.list \
&& echo "deb http://mirrors.aliyun.com/debian-security/ buster/updates main non-free contrib" >> /etc/apt/sources.list

# Add NodeJS to sources list
RUN curl -sL https://deb.nodesource.com/setup_$NODE_MAJOR.x | bash -

# Add Yarn to the sources list
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list

# Install dependencies
COPY .dockerdev/nginx/Aptfile /tmp/Aptfile
RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    build-essential \
    nodejs \
    yarn=$YARN_VERSION-1 \
    $(cat /tmp/Aptfile | xargs) && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    truncate -s 0 /var/log/*log

# Create a directory for the app code
RUN mkdir -p $WORKDIR
WORKDIR $WORKDIR

# Configure bundler and PATH
ENV LANG=C.UTF-8 \
  GEM_HOME=$WORKDIR/bundle \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3
ENV BUNDLE_PATH $GEM_HOME
ENV BUNDLE_APP_CONFIG=$BUNDLE_PATH \
  BUNDLE_BIN=$BUNDLE_PATH/bin
ENV PATH $WORKDIR/bin:$BUNDLE_BIN:$PATH

# Upgrade RubyGems and install required Bundler version
RUN gem update --system && \
    gem install bundler:$BUNDLER_VERSION

# Config mirror for chinese developer, can remove if you want
RUN npm config set registry https://registry.npm.taobao.org
RUN gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.com/
RUN bundle config mirror.https://rubygems.org https://gems.ruby-china.com

# Install nginx + phusionpassenger
RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -yq apt-utils gnupg gnupg2 gnupg1
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
RUN sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger buster main > /etc/apt/sources.list.d/passenger.list'
RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -yq nginx-extras libnginx-mod-http-passenger
RUN if [ ! -f /etc/nginx/modules-enabled/50-mod-http-passenger.conf ]; then sudo ln -s /usr/share/nginx/modules-available/mod-http-passenger.load /etc/nginx/modules-enabled/50-mod-http-passenger.conf ; fi

COPY .dockerdev/nginx/mod-http-passenger.conf /etc/nginx/conf.d/mod-http-passenger.conf
RUN mv /etc/nginx/sites-enabled/default /etc/nginx/sites-enabled/default.bk
COPY .dockerdev/nginx/app_config /etc/nginx/sites-enabled/default

# Create deploy user
RUN useradd -rm -d /home/deploy -s /bin/bash -g root -G sudo -u 1000 deploy -p "$(openssl passwd -1 deploy)"

# Override sshd_config
COPY .dockerdev/nginx/sshd_config /etc/ssh/sshd_config

# Start ssh and nginx service
COPY .dockerdev/nginx/cmd.sh cmd.sh
RUN chmod +x cmd.sh

CMD ./cmd.sh