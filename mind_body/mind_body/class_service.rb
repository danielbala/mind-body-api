module MindBody
  class ClassService < Base

    def initialize
      super
      @wsdl_file = "#{Base::URL}/ClassService.asmx?wsdl"
    end
    
    def get_classes(start_date, end_date = Date.today)
      options = {}
      options["StartDateTime"] = start_date unless start_date.nil?
      simple_request(options)
    end
    
    def get_enrollments(start_date, end_date = Date.today)
      options = {}
      options["StartDate"] = start_date unless start_date.nil?
      options["EndDate"] = end_date
      options["Fields"] = { :string => ["Enrollments.Classes", "Enrollments.Clients"] }
      simple_request(options)
    end
    
    def add_clients_to_enrollments(user, enrollment, start_date = Date.today)
      options = {}
      options["ClientIDs"] = {:string => user.client_id}
      options["ClassScheduleIDs"] = enrollment.mb_class_schedule_id
      options["EnrollDateForward"] = start_date
      simple_request(options)
    end
    
        
    # ================== TODO =====================
    # def update_client_visits
    # end 
    # def get_class_visits
    # end
    # def get_class_descriptions
    # end
    # def add_clients_to_classes
    # end

  end
end