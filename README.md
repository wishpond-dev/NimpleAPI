NimbleApi
=========

NimbleApi is a Ruby wrapper for the Nimble API. The wrapper provides an interface to interact with Contacts and Contact.

References:
  * http://nimble.readthedocs.org/en/latest/
  * https://github.com/nimblecrm/omniauth-nimble
  * https://github.com/nimblecrm/ruby-example (use this to fetch your 'refresh' token)

## Configuration

The nimble api uses oauth for authorization. You are required to obtain a client secret, token and registered callback url for each domain (including your localhost for testing) before starting to use this wrapper. Once you have obtained these keys, you will need to generate a refresh token. This allows you to access the API without going through the entire oauth flow to recreate your API client.

Configure the NimbleApi with the following:

    NimbleApi.configure do |c|
      c.client_id = ENV['CLIENT_ID']
      c.client_secret = ENV['CLIENT_SECRET']
      c.refresh_token = ENV['REFRESH_TOKEN']
    end
    
If you are using rails, create config/initializers/nimble.rb with this contents. You will need a set of all three ENV variables for each callback url that you deploy, including localhost for testing.

## Usage

    > require 'nimble-api'

    # Configure with your id, secret and refresh token for your application
    NimbleApi.configure do |c|
      c.client_id = ENV['NIMBLE_CLIENT_ID']
      c.client_secret = ENV['NIMBLE_CLIENT_SECRET']
      c.refresh_token = ENV['NIMBLE_REFRESH_TOKEN']
    end

    # Create a nimble object
    @nimble = NimbleApi()

    # Create a person hash - email is required
    @person = {
      'first name' => 'Fred',
      'last name' => 'Flintstone',
      'email' => 'fred@bedrock.org',
      'tags' => 'test'
    }

    # Use the hash to create a contact and save it to your Nimble account
    fred = @nimble.contact.create @person

    fred.save

    # Attempt to save duplicate person throws error - checking is based on first email value
    > fred.save
    RuntimeError: fred@bedrock.org already exists!

    # Update one element, or multiple
    fred.update("parent company" => [{ "modifier"=>"","value"=>"Cogswell Cogs"}])

    # Find a contact by their email address, best way to find a unique user
    fred = @nimble.contact.by_email 'fred@bedrock.org'

    # Find a contact by id
    fred = @nimble.contact.fetch "54444842faed29141e5c7300"

    # Find a contact by their first and last name, returns the first match - be careful!
    fred = @nimble.contact.by_name 'Fred', 'Flintstone'

    # Use convenience methods to display the id, email and fields
    > fred.id
    => "54444842faed29141e5c7300"

    > fred.email
    => "fred@bedrock.org"

    > fred.fields
    => {"last name"=>[{"group"=>"Basic Info", ... "value"=>"Flintstone", "label"=>"last name"}],
        "first name"=>[{"group"=>"Basic Info", ... "value"=>"Fred", "label"=>"first name"}], 
        "lead status"=>[{"group"=>"Lead Details", ... "value"=>"Not Qualified", "label"=>"lead status"}], 
        "email"=>[{"group"=>"Contact Info", ... "value"=>"fred@bedrock.org", "label"=>"email"}], 
        "source"=>[{"group"=>"Basic Info", ... "value"=>"m", "label"=>"source"}],
        "parent company"=>[{ ... "value"=>"Cogswell Cogs", "label"=>"parent company"}]}

    > fred.note "This is your note"
    => {"note"=>"This is your note", ... "note_preview"=>"This is your note" ...

    > fred.task 'next week', 'Big Subject', 'little notes'
    => {"due_date"=>"2014-10-29T19:00:00+00:00", "updated"=>"2014-10-19T23:31:43+00:00", "tags"=>[], ....

    > @nimble.contacts.list
    => {"meta"=>{"per_page"=>30, "total"=>238, "pages"=>8, "page"=>1}, "resources"=>[...]

    > @nimble.contacts.list(fields: ['first name', 'last name', 'email'])
    => ... limited to just these fields

    > @nimble.contacts.list(keyword: 'fred')
    => {"meta"=>{"per_page"=>30, "total"=>1, "pages"=>1, "page"=>1}, "resources"=>[ ... just one ... ]
    
    > @nimble.contacts.list_ids( per_page:100, page: 2 )
    => {"meta"=>{"per_page"=>100, "total"=>396, "pages"=>4, "page"=>2}, "resources"=>[ ... 100 resources ... ]

## Contacts

Provides list and list_ids, each taking params as described by the nimble api documentation http://nimble.readthedocs.org/en/latest/responses/#contact-list

## Contact

Provides a Contact object which can perform a number of instance methods:

### create
Create a new contact by providing a person definition with contact fields.

    @nimble = NimbleApi()
    person = {
      'first name' => 'Fred',
      'last name' => 'Flintstone',
      'email' => 'fred@bedrock.org',
      'tags' => 'test'
    }
    
    fred = @nimble.contact.create @person


### save
Save the contact, results will populate @contact within the object

    fred.save
    fred.contact['fields'] # accesses returned field values

### by_email
Find a contact by email address. Note that this will be the best way to locate unique contacts

### by_name
Find a contact by first and last name. Be careful John Smith!

### fetch, alias: get
Find a contact by id. Can also be called from an instance in order to refresh the contact data

### id, email, fields
Convenience methods to access the contact id, first email address and fields hash

### update
Update with new fields contents

      fred.update("parent company" => [{ "modifier"=>"","value"=>"Cogswell Cogs"}])
      fred.fetch
      fred.fields['parent company'].first['value'].should eq 'Cogswell Cogs'

### note
Adds a note for the contact


### notes
Return notes

### task
Add a task for the contact with due_date, subject and optional notes. The due_date parameter supports the Chronic parser (https://github.com/mojombo/chronic) so that you can use strings such as: 'tomorrow', 'next week', 'thursday'.
