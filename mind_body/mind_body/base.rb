module MindBody
  class Base

    attr_accessor :source_name, :password, :site_ids, :wsdl_file
    
    BUGS_SUBDOMAIN = "bugs"
    CLIENTS_SUBDOMAIN = "clients"
    URL = "http://#{CLIENTS_SUBDOMAIN}.mindbodyonline.com/api/0_5"
    ACTION_URL = "http://#{BUGS_SUBDOMAIN}.mindbodyonline.com/api/0_5"
    USERAGENT = 'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.0.1) Gecko/20060111 Firefox/1.5.0.1'

    def initialize(source_name=nil, password=nil, site_ids=nil)
      config = YAML::parse( File.open( File.dirname(__FILE__) + "/config/mind_body.yml" ) )
      @source_name = source_name || config["source_name"].value || ""
      @password = password || config["password"].value || ""
      @site_ids = site_ids || config["site_ids"].value || ""
    end

    def soap_client(file)
      Savon::Client.new do 
        http.headers["User-Agent"] = USERAGENT         
        wsdl.document = file
      end
    end

    def simple_request(options={})
      body = !options.keys.empty? ? (base_soap_request.merge!(options)) : base_soap_request
      method = calling_method.camelize
      client = soap_client(wsdl_file)
      response = client.request "#{URL}/#{method}" do |soap|
        soap.env_namespace = :soapenv
        soap.input = [ "#{method}", { "xmlns" => "#{URL}" } ]
        soap.body = { "Request" => body }
      end
      logging_request(body)
      logging_response(response)
      log_response_type(response)
      if response.success?
        return response.to_hash["#{calling_method}_response".intern]["#{calling_method}_result".intern]
      else
        return response
      end
    end
    
    def log_response_type(response)
      return logger.debug("&&&&&&&&&&&&&& RESPONSE IS #{response.type} &&&&&&&&&&&&&&&&&&")
    end

    def logging_request(soap)
      return \
      logger.debug("===================== BEGIN SOAP REQUEST LOGGING ======================"),
      logger.debug(soap.to_xml),
      logger.debug(" ====================== END SOAP REQUEST LOGGING ======================")
    end

    def logging_response(response)
      return \
      logger.debug("&&&&&&&&&&&&&&&&&&&&&&& BEGIN SOAP RESPONSE LOGGING &&&&&&&&&&&&&&&&&&&&&&&"),
      logger.debug("response.success? ============= #{response.success?}    "),
      logger.debug("response.soap_fault ============ #{response.soap_fault?} "),
      logger.debug("response.http_error ============= #{response.http_error?} "),
      logger.debug("&&&&&&&&&&&&&&&&&&&&&&& END SOAP RESPONSE LOGGING &&&&&&&&&&&&&&&&&&&&&&&")
    end

    def credentials
      {
        "SourceName" => source_name,
        "Password" => password,
        "SiteIDs" => {  :int => site_ids }
      }
    end

    def base_soap_request
      {
        "XMLDetail" => "Full",
        "PageSize" => 1000,
        "CurrentPageIndex" => 0,
        "SourceCredentials" => credentials
      } 
    end 

    def logger
      Rails.logger
    end

  end
end
