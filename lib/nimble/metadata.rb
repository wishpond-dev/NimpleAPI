module NimbleApi

  class Metadata

    def initialize(nimble)
      @nimble = nimble
    end

    def all
      @nimble.get "contacts/metadata"
    end

    def groups
      metadata = @nimble.get "contacts/metadata"
      groups = Hash.new
      metadata['groups'].keys.each {|g| groups[g] = metadata['groups'][g]['id']}
      groups
    end

    def add_group params
      @nimble.post 'contacts/metadata/groups', params
    end

    def add_field params
      @nimble.post 'contacts/metadata/fields', params
    end
  end

end