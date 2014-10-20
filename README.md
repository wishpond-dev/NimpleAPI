NimbleApi
=========

Ruby wrapper for the nimble api. The wrapper provides classes for Contacts and Contact.

References:
  * http://nimble.readthedocs.org/en/latest/
  * https://github.com/nimblecrm/omniauth-nimble
  * https://github.com/nimblecrm/ruby-example (use this to fetch your 'refresh' token)

## Configuration

The nimble api uses oauth for authorization. As such, you are required to obtain a client secret, token and registered callback url for each domain (including your localhost for testing) before starting to use this wrapper. Once you have obtained these keys, you will need to generate a refresh token. This allows you to access the API without needing to do the oauth dance to recreate your api client each time.

To use this wrapper, configure the NimbleApiApi with the following:

    NimbleApi.configure do |c|
      c.client_id = ENV['CLIENT_ID']
      c.client_secret = ENV['CLIENT_SECRET']
      c.refresh_token = ENV['REFRESH_TOKEN']
    end
    
If you plan to use this with rails, create config/initializers/nimble.rb with this contents. Reminder that you will need a set of all three ENV variables for each callback url that you plan to deploy, including localhost for testing.

## Example

    NimbleApi.configure do |c|
      c.client_id = ENV['CLIENT_ID']
      c.client_secret = ENV['CLIENT_SECRET']
      c.refresh_token = ENV['REFRESH_TOKEN']
    end

    @nimble = NimbleApi()

    @person = {
      'first name' => 'Fred',
      'last name' => 'Flintstone',
      'email' => 'fred@bedrock.org',
      'tags' => 'test'
    }

    fred = @nimble.contact.create @person

    fred.save

    fred.update("parent company" => [{ "modifier"=>"","value"=>"Cogswell Cogs"}])

    fred = @nimble.contact.by_email 'fred@bedrock.org'

    fred = @nimble.contact.fetch "54444842faed29141e5c7300"

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

    >@nimble.contacts.list(fields: ['first name', 'last name', 'email'])
    => ... limited to just these fields

    >@nimble.contacts.list(keyword: 'fred')
    => {"meta"=>{"per_page"=>30, "total"=>1, "pages"=>1, "page"=>1}, "resources"=>[ ... just one ... ]

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
Find a contact by email address

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
