custom_web: bundle exec puma -e $RACK_ENV -b unix:///tmp/web_server.sock --pidfile /tmp/web_server.pid -d
worker: env RAILS_ENV=$RAILS_ENV REDIS_URL=$REDIS_URL_INT bundle exec sidekiq -c 10
updater: env RAILS_ENV=$RAILS_ENV REDIS_URL=$REDIS_URL_INT bundle exec sidekiq -c 10 -q updates
