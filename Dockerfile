FROM ruby:2.2.3

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev libqt4-dev
RUN mkdir /app

WORKDIR /app

ADD Gemfile Gemfile.lock /app/
RUN bundle install

EXPOSE 3333

ADD . /app
