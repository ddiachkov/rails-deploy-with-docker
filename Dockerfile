FROM ubuntu:12.04

# update package lists
RUN apt-get update

# install ruby dependencies
RUN apt-get install -y build-essential git libssl-dev libreadline-dev

# install ruby from sources
## HACK, use RUN wget (vs ADD) to download for faster cache hits
RUN apt-get install wget
RUN wget -O - http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.0.tar.gz | tar xz
RUN cd ruby-2.1.0 && ./configure --disable-install-doc --with-openssl-dir=/usr/bin && make && make install
# cleanup
RUN rm -rf ruby-2.1.0*

# install Bundler
RUN gem install bundler --version 1.5.1 --no-document

# app dependencies
RUN apt-get install -y libsqlite3-dev libmysqlclient-dev libxslt-dev libxml2-dev libmagickwand-dev
WORKDIR /rails/app
ADD Gemfile /rails/app/
ADD Gemfile.lock /rails/app/
RUN bundle install

# add the app assets and required files
ADD Rakefile /rails/app/
ADD /config/ /rails/app/config/
ADD /app/assets/ /rails/app/app/assets/

# precompile assets
RUN bundle exec rake assets:precompile --trace

# copy the rest of the app
ADD / /rails/app/

# This does not use the cache and can be forced from the command line, so we skip it
# https://github.com/dotcloud/docker/issues/3525
# EXPOSE 3000


