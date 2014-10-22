require 'json'
require 'faraday'
require 'chronic'

require "nimble/version"
require 'nimble/base'
require 'nimble/contacts'
require 'nimble/contact'
require 'nimble/metadata'

def NimbleApi(options={})
  options[:client_id] = NimbleApi.client_id if NimbleApi.client_id
  options[:client_secret] = NimbleApi.client_secret if NimbleApi.client_secret
  options[:refresh_token] = NimbleApi.refresh_token if NimbleApi.refresh_token
  NimbleApi::Base.new(options)
end