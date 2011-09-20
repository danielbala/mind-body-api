module MindBody
  class SaleService < Base

    def initialize
      super
      @wsdl_file = "#{Base::URL}/SaleService.asmx?wsdl"
    end

    def get_accepted_card_type
      simple_request
    end

    def get_sales
      simple_request
    end

    def get_services(args={})
      options = {}
      options["ClassScheduleID"] = args[:class_id] if args[:class_id]
      simple_request(options)
    end

    def get_products
      simple_request
    end

    def checkout_shopping_cart(card, order)
      options = {
        "ClientID" => "123456789",
        "Test" => true
      }
      payment = payment_hash(card, order) ; cart = cart_item_hash(order)
      options.merge!(payment) ; options.merge!(cart)
      simple_request(options)
    end

    private

    def payment_hash(card, order)
      {
        "Payments" => {
          "PaymentInfo"  => {
            "CreditCardNumber" => card.card_number,
            "Amount" => order.total,
            "BillingAddress" => card.billing_address,
            "BillingCity" => card.billing_city,
            "BillingPostalCode" => card.billing_state,
            "BillingPostalCode" => card.billing_zip,
            "ExpYear" => card.exp_year,
            "ExpMonth" => card.exp_month,
            "BillingName" => "Foo Bar"
          }, 
          :attributes! => { "PaymentInfo" => { "xsi:type" => "CreditCardInfo" } }
        }
      }  
    end

    def cart_item_hash(order)
      arr = []
      order.line_items.each do |item|
        arr << {
          "Quantity" => item.quantity,
          "Item" => {
            "ID" => item.id
            },
            "ClassIDs" => {  :int => item.orderable.mb_class_schedule_id }
          }
      end 
      
      { "CartItems" => { "CartItem" => arr }  }
    end  

  end
end