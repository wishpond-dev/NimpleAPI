$:.unshift File.expand_path("../lib", File.dirname(__FILE__))

require 'rubygems'
require 'bundler'
require 'bundler/setup'
Bundler.setup(:development)

require "rspec"
require "nimble"

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end

# Insert your id, secret and refresh token here, or add to your ENV
CLIENT_ID = ENV['NIMBLE_CLIENT_ID']
CLIENT_SECRET = ENV['NIMBLE_CLIENT_SECRET']
REFRESH_TOKEN = ENV['NIMBLE_REFRESH_TOKEN']