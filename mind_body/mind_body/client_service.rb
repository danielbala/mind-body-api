module MindBody
  class ClientService < Base

    def initialize
      super
      @wsdl_file = "#{Base::URL}/ClientService.asmx?wsdl"
    end
    
    def get_clients(args={})
      options = {}
      options["ClientIDs"] = { :string => args[:client_id] } if args[:client_id]
      options["SearchText"] = (args[:search] ? args[:search] : "")
      simple_request(options)
    end
    
    def get_client_indexes
      simple_request
    end

  end
end