
class HubspotService::Send
  
  def self.user_to_hubspot_and_retrieve_hubspot_id(user)
    # TODO: change env variables and uncomment Rails.env.development? 
    # unless Rails.env.development?
      if user.email.present?
        Hubspot::Contact.create_or_update!([
          { email: user.email,
            firstname: user.first_name.blank? ? user.email : user.first_name,
            lastname: user.last_name,
            phone: user.phone_number,
            address: "#{user.address_one}\n#{user.address_two}\n#{user.address_three}\n",
            city: user.city,
            state: user.state,
            zip: user.postal_code,
            country: user.country
          }
        ])
        #find the Hubspot user id (called vid)
      end
    #end
  end
  
  def self.order_to_hubspot(order, hubspot_id, dealstage, deal_id)
    # TODO: change env variables and uncomment Rails.env.development? 
    #unless Rails.env.development
    if deal_id.present? == true
      deal = Hubspot::Deal.find(deal_id)
      response = deal.update!(
      {
          'amount' =>  order.total, 
          'description' => order.print_line_items,
          'dealname' => "#{order.ax_sales_id} - #{order.customer.last_name} - #{order.line_items[0].variant.item_code}",
          'dealstage' => dealstage,
          'pipeline' => ENV['HUBSPOT_PIPELINE_ID'],
          'hubspot_owner_id' => ENV['HUBSPOT_OWNER_ID'],
          'bed_type' => order.line_items[0].variant.bed_type,
          'date_variant' => order.line_items[0].variant.departure_date,
          'departure_city' => order.line_items[0].variant.departure_city,
          'duration_days_' => order.line_items[0].variant.product.number_of_days,
          'hotel_accommodation' => order.line_items[0].variant.accommodation,
          'instalments_selected' => order.line_items[0].request_installments ? "True" : "False",
          'md_operator' => order.line_items[0].variant.product.operator.name,
          'purchase_quantity' => order.line_items.length,
          'supplier_product_code' => order.line_items[0].variant.supplier_product_code,
          'order_info_link' => Rails.application.routes.url_helpers.order_customer_info_path(order, host: 'www.mydiscoveries.com.au'),
          'campaign_code' => order.campaign_code
        })
      return response.deal_id
    else  
      response = Hubspot::Deal.create!(
        ENV['HUBSPOT_PORTAL_ID'], 
        ENV['HUBSPOT_COMPANY_ID'], 
        hubspot_id,{
          'amount' =>  order.total, 
          'description' => order.print_line_items,
          'dealname' => "#{order.ax_sales_id} - #{order.customer.last_name} - #{order.line_items[0].variant.item_code}",
          'dealstage' => dealstage,
          'pipeline' => ENV['HUBSPOT_PIPELINE_ID'],
          'hubspot_owner_id' => ENV['HUBSPOT_OWNER_ID'],
          'bed_type' => order.line_items[0].variant.bed_type,
          'date_variant' => order.line_items[0].variant.departure_date,
          'departure_city' => order.line_items[0].variant.departure_city,
          'duration_days_' => order.line_items[0].variant.product.number_of_days,
          'hotel_accommodation' => order.line_items[0].variant.accommodation,
          'instalments_selected' => order.line_items[0].request_installments ? "True" : "False",
          'md_operator' => order.line_items[0].variant.product.operator.name,
          'purchase_quantity' => order.line_items.length,
          'supplier_product_code' => order.line_items[0].variant.supplier_product_code,
          'order_info_link' => Rails.application.routes.url_helpers.order_customer_info_path(order, host: 'www.mydiscoveries.com.au'),
          'campaign_code' => order.campaign_code
        })
      return response.deal_id
    end
    #end
  end
end

#'pipeline' => 'mdfulfilmentpipeline' f1eeb762-48e2-4150-ae79-81075972fb10
