FROM msaraiva/elixir-dev

RUN apk --update add nodejs postgresql-dev

RUN mix local.hex --force && \
    mix local.rebar

RUN mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phoenix_new-1.1.1.ez

RUN mkdir -p /usr/src/app

WORKDIR /usr/src/app

COPY mix.exs mix.lock package.json /usr/src/app/

RUN npm install && \
    node node_modules/brunch/bin/brunch build && \
    mix deps.get

EXPOSE 4000

COPY . /usr/src/app

CMD ["mix", "phoenix.server"]
