require 'spec_helper'

describe NimbleApi::Metadata do

  before :each do
    NimbleApi.configure do |c|
      c.client_id = CLIENT_ID
      c.client_secret = CLIENT_SECRET
      c.refresh_token = REFRESH_TOKEN
    end
    @nimble = NimbleApi()
    @fred = @nimble.contact.by_email 'fred@bedrock.org'
    unless @fred
      @person = {
        'first name' => 'Fred',
        'last name' => 'Flintstone',
        'email' => 'fred@bedrock.org',
        'tags' => 'test'
      }
      @fred = @nimble.contact.create @person
      @fred.save
    end
  end

  it "should retrieve all metadata" do
    resp = @nimble.metadata.all
    resp.should_not be_empty
  end

  it "can create a custom group" do
    resp = @nimble.metadata.add_group('type'=>'person','name'=>'testing')
    resp['id'].should_not be_nil
  end

  it "can add a custom field to the group" do
    resp = @nimble.metadata.add_field('group_id' => "5447ee6dfaed29363fb17605", 'name' => 'projects', 'presentation' =>{'width' => '1', 'type' => 'single-line-text-box'})
    resp.should_not be_empty
    # => {"group"=>"taskit",
    #    "name"=>"projects",
    #    "modifier"=>"",
    #    "presentation"=>{"width"=>"1", "type"=>"single-line-text-box"},
    #    "id"=>"5447efa0ae31563ca75a4db1",
    #    "multiples"=>false,
    #    "label"=>"projects"}
  end

  it "can apply a value to the custom field" do
    @fred.update("projects" => [{ "modifier"=>"","value"=>"Thursday project"}])
    @fred.fetch
    @fred.fields['projects'][0]['value'].should eq 'Thursday project'
  end

end
