module NimbleApi

  class Contacts

    def initialize(nimble)
      @nimble = nimble
    end

    def list params={}
      params[:fields] = params[:fields].join(',') if params[:fields]
      params[:record_type] ||= 'person'
      @nimble.get "contacts", params
    end

    def list_ids params={}
      @nimble.get "contacts/ids", params
    end
  end
end