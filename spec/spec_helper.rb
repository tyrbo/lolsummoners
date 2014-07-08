ENV["RAILS_ENV"] ||= 'test'
require 'coveralls'
Coveralls.wear!('rails')
require "codeclimate-test-reporter"
CodeClimate::TestReporter.start
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rspec'
Capybara.javascript_driver = :webkit
require 'database_cleaner'
require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: false)
require 'sidekiq/testing'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false
  config.infer_spec_type_from_file_location!

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1.44
  config.order = "random"
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
    Redis.current.select(1)
    Redis.current.flushdb
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.before(:each) do
    stub_request(:get, "https://na.api.pvp.net/api/lol/na/v2.4/league/by-summoner/442232?api_key=#{ENV['RIOT_API']}").
      to_return(:status => 200, :body => '{"442232":[{"queue":"RANKED_SOLO_5x5","leagueName":"Taric\'s Enforcers","tier":"CHALLENGER","entries":[{"playerOrTeamId":"442232","playerOrTeamName":"aphromoo","leagueName":"Taric\'s Enforcers","queueType":"RANKED_SOLO_5x5","tier":"CHALLENGER","division":"I","leaguePoints":748,"wins":168,"isHotStreak":false,"isVeteran":true,"isFreshBlood":false,"isInactive":false,"lastPlayed":-1},{"playerOrTeamId":"23459413","playerOrTeamName":"Suffix","leagueName":"Taric\'s Enforcers","queueType":"RANKED_SOLO_5x5","tier":"CHALLENGER","division":"I","leaguePoints":51,"wins":166,"isHotStreak":false,"isVeteran":false,"isFreshBlood":true,"isInactive":false,"lastPlayed":-1}]}]}', :headers => {})

      stub_request(:get, "https://na.api.pvp.net/api/lol/na/v1.4/summoner/by-name/ajsdfoabsdfouabsdfiouweroi?api_key=#{ENV['RIOT_API']}").
        to_return(:status => 404, :body => "", :headers => {})

        stub_request(:get, "https://na.api.pvp.net/api/lol/na/v1.4/summoner/by-name/pentakill?api_key=#{ENV['RIOT_API']}").
          to_return(:status => 200, :body => '{"pentakill":{"id":0,"name":"Pentakill","profileIconId":28,"revisionDate":0,"summonerLevel":30}}', :headers => {})

          stub_request(:get, "https://na.api.pvp.net/api/lol/na/v1.4/summoner/by-name/peak?api_key=#{ENV['RIOT_API']}").
            to_return(:status => 200, :body => '{"peak":{"id":21848947,"name":"Peak","profileIconId":28,"revisionDate":0,"summonerLevel":30}}', :headers => {})

            stub_request(:get, "https://na.api.pvp.net/api/lol/na/v2.4/league/by-summoner/0/entry?api_key=#{ENV['RIOT_API']}").
              to_return(:status => 404, :body => "", :headers => {})

              stub_request(:get, "https://na.api.pvp.net/api/lol/na/v2.4/league/by-summoner/21848947/entry?api_key=#{ENV['RIOT_API']}").
                to_return(:status => 200, :body => '{"21848947":[{"isHotStreak": false,"isFreshBlood": false,"leagueName": "Taric\'s Zealots","isVeteran": false,"tier": "PLATINUM","lastPlayed": -1,"playerOrTeamId": "21848947","leaguePoints": 37,"division": "IV","isInactive": false,"queueType": "RANKED_SOLO_5x5","playerOrTeamName": "Peak","wins": 7}]}', :headers => {})
  end

  config.after(:suite) do
    WebMock.disable!
    Redis.current.select(1)
    Redis.current.flushdb
  end
end
