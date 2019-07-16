FROM debian:jessie

#ENV RUBY_VERSION 1.9.3-p551
ENV RUBY_VERSION 1.8.7-p374
ENV PATH /usr/local/rvm/gems/ruby-${RUBY_VERSION}/bin:/usr/local/rvm/gems/ruby-${RUBY_VERSION}@global/bin:/usr/local/rvm/rubies/ruby-${RUBY_VERSION}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/rvm/bin

RUN set -ex && apt-get update

RUN apt-get install -y curl libxml2-dev libxslt1-dev python2.7-dev python \
  zip vim git

RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

RUN curl -sSL https://get.rvm.io | bash -s stable --ruby=${RUBY_VERSION}
RUN gem update --system 1.8.23.2

RUN mkdir -p /app
WORKDIR /app

COPY . ./
RUN gem install bundler --version '= 1.7.9' && bundle install

EXPOSE 3000

CMD ["bundle", "exec", "script/server"]
