ENV["RAILS_ENV"] ||= 'test'
require 'coveralls'
Coveralls.wear!('rails')
require "codeclimate-test-reporter"
CodeClimate::TestReporter.start
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rspec'
require 'fakeredis/rspec'
require 'database_cleaner'
require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: false)

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

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.before(:each) do
    stub_request(:get, "https://prod.api.pvp.net/api/lol/na/v1.3/summoner/by-name/ajsdfoabsdfouabsdfiouweroi?api_key=#{ENV['RIOT_API']}").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'prod.api.pvp.net', 'User-Agent'=>'Ruby'}).
         to_return(:status => 404, :body => "", :headers => {})

    stub_request(:get, "https://prod.api.pvp.net/api/lol/na/v1.3/summoner/by-name/pentakill?api_key=#{ENV['RIOT_API']}").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'prod.api.pvp.net', 'User-Agent'=>'Ruby'}).
         to_return(:status => 200, :body => '{"pentakill":{"id":1,"name":"Pentakill","profileIconId":28,"revisionDate":0,"summonerLevel":30}}', :headers => {})

    stub_request(:get, "https://prod.api.pvp.net/api/lol/na/v1.3/summoner/by-name/peak?api_key=#{ENV['RIOT_API']}").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'prod.api.pvp.net', 'User-Agent'=>'Ruby'}).
         to_return(:status => 200, :body => '{"peak":{"id":21848947,"name":"Peak","profileIconId":28,"revisionDate":0,"summonerLevel":30}}', :headers => {})
  end

  config.after(:suite) do
    WebMock.disable!
  end
end
