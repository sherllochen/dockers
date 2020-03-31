ARG RUBY_VERSION
FROM ruby:$RUBY_VERSION
ARG RAILS_VERSION
ARG WORKDIR

# Change source to aliyun, can remove if you want
RUN mv /etc/apt/sources.list /etc/apt/sources.list.orig \
&& echo "deb http://mirrors.aliyun.com/debian buster main contrib non-free" >> /etc/apt/sources.list \
&& echo "deb http://mirrors.aliyun.com/debian buster-proposed-updates main contrib non-free" >> /etc/apt/sources.list \
&& echo "deb http://mirrors.aliyun.com/debian buster-updates main contrib non-free" >> /etc/apt/sources.list \
&& echo "deb http://mirrors.aliyun.com/debian-security/ buster/updates main non-free contrib" >> /etc/apt/sources.list

RUN apt-key adv --refresh-keys --keyserver keyserver.ubuntu.com

# Install dependencies
COPY .dockerdev/rails/Aptfile /tmp/Aptfile
RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    build-essential \
    default-mysql-client default-libmysqlclient-dev \
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
    gem install bundler

# Config mirror for chinese developer, can remove if you want
RUN gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.com/

RUN gem install rails -v $RAILS_VERSION
# Config mirror for chinese developer, can remove if you want
RUN bundle config mirror.https://rubygems.org https://gems.ruby-china.com

# for gems
RUN mv Gemfile.docker Gemfile
# COPY *.gemspec $WORKDIR/
RUN bundle install  -j $(nproc)