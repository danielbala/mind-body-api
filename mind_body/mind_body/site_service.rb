module MindBody
  class SiteService < Base

    def initialize
      super
      @wsdl_file = "#{Base::URL}/SiteService.asmx?wsdl"
    end
    
    def get_sites
      simple_request
    end
    
    def get_locations
      simple_request
    end

  end
end