FROM ruby
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev libqt4-dev
RUN gem install foreman
RUN mkdir /app
WORKDIR /app
ADD Gemfile Gemfile.lock /app/
RUN bundle install
ADD . /app
RUN rm /app/tmp/pids/server.pid
