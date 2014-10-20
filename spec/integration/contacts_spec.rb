require 'spec_helper'

describe NimbleApi::Contacts do

  before :each do
    NimbleApi.configure do |c|
      c.client_id = CLIENT_ID
      c.client_secret = CLIENT_SECRET
      c.refresh_token = REFRESH_TOKEN
    end
    @nimble = NimbleApi()
  end

  describe "list" do
    it "should retrieve contacts" do
      resp = @nimble.contacts.list
      resp['meta']['total'].should > 0
    end

    it "should specify fields" do
      resp = @nimble.contacts.list(fields: ['first name', 'email'])
      resp['resources'][0]['fields'].keys.should eq ['first name', 'email']
    end

    it "should limit to record_type = person" do
      resp = @nimble.contacts.list(fields: ['first name', 'email'])
      resp['resources'][0]['record_type'].should eq 'person'
    end

    it "can supress tags" do
      resp = @nimble.contacts.list(tags: 0)
      resp['resources'][0].keys.include?('tags').should eq false
    end

    it "supports keyword param" do
      resp = @nimble.contacts.list(keyword: 'winnie')
      resp['resources'][0]['fields']['first name'][0]['value'].should eq 'winnie'
    end
  end

end
