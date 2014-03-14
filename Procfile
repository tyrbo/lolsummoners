web: bundle exec puma --config config/puma.rb
worker: bundle exec sidekiq -e production
worker: forever start -l log/forever.log -o log/script.log -e log/script.err.log -c coffee ../node-updater/server.coffee
