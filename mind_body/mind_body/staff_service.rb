module MindBody
  class StaffService < Base
  
    def initialize
      super
      @wsdl_file = "#{Base::URL}/StaffService.asmx?wsdl"
    end
    
    def get_staff
      simple_request
    end
    
    # ================== TODO =====================
    # def get_staff_permissions
    # end

  end
end