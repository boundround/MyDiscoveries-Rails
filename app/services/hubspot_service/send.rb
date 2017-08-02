class HubspotService::Send
  def self.user_to_hubspot_and_retrieve_hubspot_id(user)
    unless Rails.env.development?
      if user.email.present?
        Hubspot::Contact.create_or_update!([
          { email: user.email,
            firstname: user.first_name.blank? ? user.email : user.first_name,
            lastname: user.last_name,
            phone: user.mobile.blank? ? user.home_phone : user.mobile
          }
        ])
        hubspot_id = Hubspot::Contact.find_by_email(user.email).vid #find the Hubspot user id (called vid)
        return hubspot_id
      end
    end
  end

  def self.get_dealstage()
    return dealstage
  end
  
  def self.order_to_hubspot(order, hubspot_id, dealstage)
    unless Rails.env.development?
      if user.email.present?
        response = Hubspot::Deal.create!(
          "3450808", 
          "483432591", 
          hubspot_id,{
            "amount" =>  order.total, 
            "createdate" => order.last.created_at.to_time.to_i,
            "description" => order.last.description,
            "dealname" => order.last.title,
            "dealstage" => dealstage,
            "holiday_type" => order.last.product_type,
            "pipeline" => "f1eeb762-48e2-4150-ae79-81075972fb10",
            "hubspot_owner_id" => 27537933,
            "bed_type" => order.line_items[0].variant.bed_type,
            "date_variant" => order.line_items[0].variant.departure_date,
            "departure_city" => order.line_items[0].variant.departure_city,
            "duration_days_" => order.line_items[0].variant.product.number_of_days,
            "hotel_accommodation" => order.line_items[0].variant.accommodation,
            "instalments_selected" => order.line_items[0].request_installments,
            "md_operator" => order.line_items[0].variant.product.operator.name,
            "purchase_quantity" => order.line_items.length,
            "supplier_product_code" => order.line_items[0].variant.supplier_product_code
          })
      end
    end
  end
end

#"pipeline" => "mdfulfilmentpipeline" f1eeb762-48e2-4150-ae79-81075972fb10
#https://api.hubapi.com/contacts/v1/contact/email/testingapis@hubspot.com/profile?hapikey=demo
