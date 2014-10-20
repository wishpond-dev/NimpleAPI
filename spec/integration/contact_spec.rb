require 'spec_helper'
describe NimbleApi::Contact do

  before :each do
    NimbleApi.configure do |c|
      c.client_id = CLIENT_ID
      c.client_secret = CLIENT_SECRET
      c.refresh_token = REFRESH_TOKEN
    end

    @person = {
      'first name' => 'Fred',
      'last name' => 'Flintstone',
      'email' => 'fred@bedrock.org',
      'tags' => 'test'
    }
    @nimble = NimbleApi()
  end

  it "should create contact" do
    expect do
      NimbleApi()
      @nimble.contact.create @person
    end.to_not raise_error
  end

  describe "when contact does not exist" do

    before :each do
      fred = @nimble.contact.by_email 'fred@bedrock.org'
      fred.delete if fred
    end

    it "should save contact" do
      fred = @nimble.contact.create @person
      resp = fred.save
      resp.should_not be_nil
    end

    it "returns nil for missing contact by_email" do
      @nimble.contact.by_email('nobody@noplace.home').should be_nil
    end
  end

  describe "when contact exists" do

    before :each do
      @fred = @nimble.contact.by_email 'fred@bedrock.org'
      unless @fred
        @fred = @nimble.contact.create @person
        @fred.save
      end
    end

    it "can find contact by_email" do
      resp = @nimble.contact.by_email 'fred@bedrock.org'
      resp.should_not be_nil
    end

    it "can find contact by_name" do
      fred = @nimble.contact.by_name 'Fred', 'Flintstone'
      fred.fields['last name'][0]['value'].should eq 'Flintstone'
    end

    it "returns contact by id" do
      found = @nimble.contact.fetch @fred.id
      found.should_not be_nil
    end

    it "updates contact" do
      @fred.update("parent company" => [{ "modifier"=>"","value"=>"Cogswell Cogs"}])
      @fred.fetch
      @fred.fields['parent company'].first['value'].should eq 'Cogswell Cogs'
    end

    it "can delete with object" do
      resp = @fred.delete
      resp['status'].should eq 'ok'
    end

    it "can delete with id" do
      resp = @nimble.contact.delete @fred.id
      resp['status'].should eq 'ok'
    end
  end

  describe "notes" do
    before :each do
      @fred = @nimble.contact.by_email 'fred@bedrock.org'
      unless @fred
        @fred = @nimble.contact.create @person
        @fred.save
      end
    end

    it "gets all notes" do
      @fred.note "This is your note"
      notes = @fred.notes
      notes['meta']['total'].should > 0
    end


    it "can add a note" do
      timestamp = Time.now
      @fred.note "This note sent at #{timestamp}"
      notes = @fred.notes
      notes['resources'].first['note'].should match timestamp.to_s
    end

    it "can delete a note" do
      timestamp = Time.now
      @fred.note "This note sent at #{timestamp}"
      notes = @fred.notes
      id = notes['resources'].first['note']['id']
      resp = @fred.delete_note id
      resp['id'].should eq id
    end
  end

  describe "tasks" do
    before :each do
      @fred = @nimble.contact.by_email 'fred@bedrock.org'
      unless @fred
        @fred = @nimble.contact.create @person
        @fred.save
      end
    end

    it "can add a task" do
      note = @fred.task 'next week', 'Big Subject', 'little notes'
      note['subject'].should eq 'Big Subject'
      note['due_date'].should match Chronic.parse('next week').strftime('%Y-%m-%d')
    end
  end
end