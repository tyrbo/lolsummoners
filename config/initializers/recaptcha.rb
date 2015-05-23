Recaptcha.configure do |config|
  config.public_key = "6LfsRQcTAAAAAO9RceUr0j7W202QhDbO98NClgwZ"
  config.private_key = ENV["RECAPTCHA_SECRET"]
end
