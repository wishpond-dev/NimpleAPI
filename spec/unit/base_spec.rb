require 'spec_helper'

describe NimbleApi::Base do

  it "should raise an error if the client_id has not been set" do
    NimbleApi.configure do |c|
      c.client_id = nil
    end
    expect do
      NimbleApi()
    end.to raise_error ArgumentError
  end

  it "can be called directly if the keys have been set via NimbleApi.configure" do
    NimbleApi.configure do |config|
      config.client_id = "qwer"
      config.client_secret = "1234"
      config.refresh_token = "qwer-1234"
    end
    expect do
      NimbleApi()
    end.to_not raise_error
  end

  it "can be instanced with the keys as a param" do
    expect do
      NimbleApi({ :client_id => "qwer", :client_secret => "1234", :refresh_token =>"qwer-1234" })
    end.to_not raise_error
  end


  describe "configuration" do

    before(:each) do
      NimbleApi.configure do |config|
        config.client_id = "qwer"
        config.client_secret = "1234"
        config.refresh_token = "qwer-1234"
        config.host = "nimble.com"
        config.callback_path = "/auth/callback"
        config.api_version = "v2"
      end
    end

    it "allows me to set my client_id" do
      NimbleApi.client_id.should eql 'qwer'
    end

    it "allows me to set my client_secret" do
      NimbleApi.client_secret.should eql '1234'
    end

    it "allows me to set my refresh_token" do
      NimbleApi.refresh_token.should eql 'qwer-1234'
    end

    it "allows me to set my host" do
      NimbleApi.host.should eql 'nimble.com'
    end

    it "allows me to set my callback_path" do
      NimbleApi.callback_path.should eql "/auth/callback"
    end

    it "allows me to set my api_version" do
      NimbleApi.api_version.should eql 'v2'
    end
  end
end