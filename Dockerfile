FROM ruby:2.2.3

RUN apt-get update -qq
RUN apt-get install -y build-essential g++ flex bison gperf perl \
  libsqlite3-dev libfontconfig1-dev libicu-dev libfreetype6 libssl-dev \
  libpng-dev libjpeg-dev python libx11-dev libxext-dev libpq-dev

RUN git clone --recurse-submodules git://github.com/ariya/phantomjs.git
RUN cd phantomjs && ./build.py
RUN cp phantomjs/bin/phantomjs /usr/bin/phantomjs

RUN apt-get install -y qt5-default libqt5webkit5-dev

RUN mkdir /app

WORKDIR /app

ADD Gemfile Gemfile.lock /app/
RUN bundle install

EXPOSE 3333

ADD . /app
