web: bundle exec puma --config config/puma.rb
worker: bundle exec sidekiq -e production
node: forever start -l forever.log -o script.log -e script.err.log -c coffee ../node-updater/server.coffee
