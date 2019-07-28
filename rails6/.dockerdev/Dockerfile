ARG RUBY_VERSION
FROM ruby:$RUBY_VERSION

ARG PG_MAJOR
ARG NODE_MAJOR
ARG BUNDLER_VERSION
ARG YARN_VERSION

# Change source to aliyun
RUN mv /etc/apt/sources.list /etc/apt/sources.list.orig \
&& echo "deb http://mirrors.aliyun.com/debian buster main contrib non-free" >> /etc/apt/sources.list \
&& echo "deb http://mirrors.aliyun.com/debian buster-proposed-updates main contrib non-free" >> /etc/apt/sources.list \
&& echo "deb http://mirrors.aliyun.com/debian buster-updates main contrib non-free" >> /etc/apt/sources.list \
&& echo "deb http://mirrors.aliyun.com/debian-security/ buster/updates main non-free contrib" >> /etc/apt/sources.list

# Add PostgreSQL to sources list
RUN curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
  && echo 'deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main' $PG_MAJOR > /etc/apt/sources.list.d/pgdg.list

# Add NodeJS to sources list
RUN curl -sL https://deb.nodesource.com/setup_$NODE_MAJOR.x | bash -

# Add Yarn to the sources list
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list

# Install dependencies
COPY .dockerdev/Aptfile /tmp/Aptfile
RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    build-essential \
    postgresql-client-$PG_MAJOR \
    nodejs \
    yarn=$YARN_VERSION-1 \
    $(cat /tmp/Aptfile | xargs) && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    truncate -s 0 /var/log/*log

# Configure bundler and PATH
ENV LANG=C.UTF-8 \
  GEM_HOME=/bundle \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3
ENV BUNDLE_PATH $GEM_HOME
ENV BUNDLE_APP_CONFIG=$BUNDLE_PATH \
  BUNDLE_BIN=$BUNDLE_PATH/bin
ENV PATH /app/bin:$BUNDLE_BIN:$PATH

# Upgrade RubyGems and install required Bundler version 
RUN gem update --system && \
    gem install bundler:$BUNDLER_VERSION

# Create a directory for the app code
RUN mkdir -p /app

WORKDIR /app

# Config mirror for chinese developer
RUN npm config set registry https://registry.npm.taobao.org
RUN gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.com/

ARG RAILS_VERSION
RUN gem install rails -v $RAILS_VERSION
RUN bundle config mirror.https://rubygems.org https://gems.ruby-china.com

# for gems
COPY Gemfile Gemfile.lock /app/
RUN bundle install  -j $(nproc)

COPY package.json yarn.lock /app/
RUN yarn install --no-bin-links

# copy app files
COPY . /app/

EXPOSE 3000
