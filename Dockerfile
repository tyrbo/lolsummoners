FROM rails:4.2.4

RUN mkdir /usr/src/app

WORKDIR /usr/src/app

ADD Gemfile Gemfile.lock /usr/src/app/

RUN bundle install

ADD . /usr/src/app
