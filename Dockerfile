FROM trenpixster/elixir:latest

RUN apt-get -y update
RUN apt-get -y upgrade

RUN apt-get install -y build-essential inotify-tools postgresql-client

RUN curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
RUN apt-get install -y nodejs

RUN mix local.hex --force && \
    mix local.rebar

RUN mix archive.install --force https://github.com/phoenixframework/phoenix/releases/download/v1.1.1/phoenix_new-1.1.1.ez

RUN mkdir -p /usr/src/app

WORKDIR /usr/src/app

COPY mix.exs mix.lock package.json /usr/src/app/

RUN npm install && \
    node node_modules/brunch/bin/brunch build && \
    mix deps.get

EXPOSE 4000

COPY . /usr/src/app

CMD ["mix", "phoenix.server"]
