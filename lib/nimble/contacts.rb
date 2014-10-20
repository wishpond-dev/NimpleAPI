module NimbleApi

  class Contacts

    def initialize(nimble)
      @nimble = nimble
    end

    # Returns list of contacts. Limits contacts and fields with params if provided
    def list params={}
      params[:fields] = params[:fields].join(',') if params[:fields]
      params[:record_type] ||= 'person'
      @nimble.get "contacts", params
    end

    # Returns list of contacts ids only. Limits contacts with params if provided
    def list_ids params={}
      @nimble.get "contacts/ids", params
    end
  end
end