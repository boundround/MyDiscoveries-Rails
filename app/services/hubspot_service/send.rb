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
  
  # def self.order_to_hubspot(order, hubspot_id, dealstage)
  #   unless Rails.env.development?
  #     if user.email.present?
  #       response = Hubspot::Deal.create!(
  #         "3450808", 
  #         "483432591", 
  #         hubspot_id,{ 
  #           "amount" => order.total.to_s, 
  #           "createdate" => or
  #           der.created_at.to_time.to_i,
  #           "description" => order.description,
  #           "dealname" => order.title,
  #           "dealstage" => dealstage,
  #           "holiday_type" => "Package",
  #           "pipeline" => "mdfulfilmentpipeline",
  #           "hubspot_owner_id" => 27537933,
  #           "bed_type" => order.spree_variant.bed_type,
  #           "date_variant" => "29/06/2016",
  #           "departure_city" => "Sydney",
  #           "duration_days_" => "3",
  #           "hotel_accommodation" => "5-star hotel",
  #           "instalments_selected" => true,
  #           "md_operator" => "name",
  #           "purchase_quantity" => 3,
  #           "supplier_product_code" => "supplier_product_code"
  #         })
  #     end
  #   end
  # end
end

#"pipeline" => "mdfulfilmentpipeline" f1eeb762-48e2-4150-ae79-81075972fb10
#https://api.hubapi.com/contacts/v1/contact/email/testingapis@hubspot.com/profile?hapikey=demo
