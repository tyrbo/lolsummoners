FROM trenpixster/elixir:latest

RUN apt-get -y update
RUN apt-get -y upgrade

RUN apt-get install -y build-essential inotify-tools

RUN curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
RUN apt-get install -y nodejs

RUN mix local.hex
RUN mix archive.install https://github.com/phoenixframework/phoenix/releases/download/v1.1.1/phoenix_new-1.1.1.ez

RUN mkdir -p /usr/src/app

WORKDIR /usr/src/app

ADD . /usr/src/app
