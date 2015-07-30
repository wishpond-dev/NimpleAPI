module NimbleApi

  class Contact

    attr_accessor :contact
    def initialize(nimble)
      @nimble = nimble
    end

    def create params
      # email is used as unique id
      @email = params['email']
      @person = {
        "fields" => {
          "first name" => [{"value" => params['first name'],"modifier" => ""}],
          "last name" => [{ "value"=> params['last name'],"modifier" => ""}],
          "Gender"=>[{"modifier"=>"", "value" => params["Gender"]}],
          "parent company" => [{ "modifier"=>"","value"=>params['company']}],
          "linkedin" => [{"modifier"=>"",  "value"=>params['linkedin']}],
          "URL" => [{ "modifier"=>"other", "value"=>params['website']}],
          "email" => [{"modifier"=>"work", "value"=>params['email']}],
          "lead status" => [{"modifier"=>"", "value"=>"Not Qualified"}],
          "title" => [{"modifier" => "", "value" => params['headline']}],
          "address" => [ { "modifier" => "work","value" => params['address']}]
          },
          "tags" => [params['tags']],
          "record_type" => "person"
        }
      # remove empty fields
      @person['fields'].keys.each {|k| @person['fields'].delete(k) if @person['fields'][k][0]['value'].nil? }
      self
    end

    # convenience methods
    def id
      self.contact['id']
    end

    def email
      self.contact['fields']['email'].first['value']
    end

    def fields
      self.contact['fields']
    end

    # Checks for duplicates by email
    def save
      raise 'must call contact.create(params) before save' unless @person
      raise 'must set email address for unique checking before save' unless @email
      if @email
        raise "#{@email} already exists!" unless self.by_email(@email).nil?
      end
      self.contact = @nimble.post 'contact', @person
      return nil unless self.contact
      self
    end

    # Searches contacts for matching email, sets self.contact to matching result
    def by_email email
      query = { "and" => [{ "email" => { "is"=> email } },{ "record type"=> { "is"=> "person" }} ] }
      resp = @nimble.get 'contacts', { :query => query.to_json }
      self.contact = resp['resources'].first
      return nil unless self.contact
      self
    end

    # Searches contacts for matching name, sets self.contact to first matching result
    def by_name first_name, last_name
      query = { "and" => [{ "first name" => { "is"=> first_name } }, { "last name" => { "is"=> last_name } }, { "record type"=> { "is"=> "person" }} ] }
      resp = @nimble.get 'contacts', { :query => query.to_json }
      self.contact = resp['resources'].first
      return nil unless self.contact
      self
    end

    # Gets contact by id and sets self.contact to result
    def fetch id=nil
      id ||= self.id
      resp = @nimble.get "contact/#{id}"
      self.contact = resp['resources'].first
      return nil unless self.contact
      self
    end
    alias_method :get, :fetch

    # Update with param 'fields' set to passed in param hash
    def update fields
      self.contact = @nimble.put "contact/#{self.id}", { fields: fields }
      return nil unless self.contact
      self
    end

    # Returns notes for contact, based on params if provided
    def notes params=nil
      @nimble.get "contact/#{self.id}/notes", params
    end

    # Adds note to contact. Preview set to 64 chars substring or can be provided
    def note note, preview=nil
      preview ||= note[0..64]
      params = {
        contact_ids: [ self.id ],
        note: note,
        note_preview: preview
      }
      @nimble.post "contacts/notes", params
    end

    # Delete not by id for self.contact
    def delete_note id
      @nimble.delete "contact/notes/#{id}"
    end

    # Delete contact with id of self.contact, or by id as argument
    def delete id=nil
      id ||= self.id
      @nimble.delete "contact/#{id}"
    end

    # Create new task for contac. due_date argument is parsed by Chronic and can be of
    # format 'next week', 'tomorrow', 'Friday', 'Oct 10, 2014', etc.
    def task due_date, subject, notes=nil
      due = Chronic.parse(due_date).strftime('%Y-%m-%d %H:%M')
      params = {
        related_to: [ self.id ],
        subject: subject,
        due_date: due
      }
      params[:notes] = notes if notes
      @nimble.post "activities/task", params
    end

  end
end
