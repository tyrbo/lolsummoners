web: bundle exec puma -e $RACK_ENV -b -p 3333 --pidfile tmp/web.pid
worker: env RAILS_ENV=$RAILS_ENV REDIS_URL=$REDIS_URL_INT bundle exec sidekiq -c 10
updater: env RAILS_ENV=$RAILS_ENV REDIS_URL=$REDIS_URL_INT bundle exec sidekiq -c 10 -q updates
