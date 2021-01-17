# frozen_string_literal: true

require 'bundler/setup'
require 'OpenWeatherMap'
require 'rest-client'
require 'active_support/time'
require 'active_support/all'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  OPENWEATHERMAP_TOKEN = 'f32b88630791a7026ad9e5bceddafec5'
end
