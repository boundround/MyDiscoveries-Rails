Spree::Order.class_eval do
  belongs_to :product
  belongs_to :customer

  # override spree relations
  belongs_to :user,       class_name: 'User'
  belongs_to :created_by, class_name: 'User'
  belongs_to :approver,   class_name: 'User'
  belongs_to :canceler,   class_name: 'User'

  has_many :passengers
  has_many :add_ons, through: :line_items

  after_commit :set_ax_sales_id!, on: :create

  accepts_nested_attributes_for :passengers
  accepts_nested_attributes_for :line_items
  accepts_nested_attributes_for :customer

  # customizes checkout flow
  checkout_flow do
    remove_checkout_step :address
    remove_checkout_step :delivery
    remove_checkout_step :payment
    remove_checkout_step :confirm
    remove_checkout_step :complete

    add_transition from: :cart, to: :add_passengers, if: ->(order) do
      order.line_items.any?
    end

    add_transition from: :add_passengers, to: :px_payment, if: ->(order) do
      order.passengers.count == order.total_quantity
    end

    add_transition from: :px_payment, to: :completed, if: ->(order) do
      order.authorized?
    end
  end

  # overrides spree method
  def completed?
    state == 'completed'
  end

  def set_ax_sales_id!
    update_column(:ax_sales_id, "WM#{1000000 + id}") unless created_from_ax && ax_sales_id.present?
  end

  def line_items_without_passengers
    line_items.select{ |li| li.passengers.empty? }
  end

  def ax_line_items
    items = ax_data.try(:[], 'Envelope').
      try(:[], 'Order').
      try(:[], 'Items').
      try(:[], 'Item')

    return [] if items.blank?
    items.is_a?(Hash) ? [items] : items
  end

  def set_cart_state!
    update(state: 'cart') unless cart?
  end

  def set_cart_add_passengers!
    update(state: 'add_passengers') unless add_passengers?
  end

  def set_completed_state!
    update(state: 'completed') unless completed?
  end

  def total_quantity
    line_items.pluck(:quantity).reduce(:+)
  end

  def total_price
    if promotions.any?
      total      = total_amount
      adjustment = (total / 100).to_f * total_flat_percent

      (total - adjustment).to_f
    else
      total_amount
    end
  end

  def total_amount
    line_items.map(&:total_price).reduce(:+)
  end

  def total_flat_percent
    promotions.map(&:promotion_actions).flatten.
      map(&:calculator).sum{ |c| c.preferences[:flat_percent] }
  end

  def total_price_without_installments
    line_items.map(&:total_price_without_installments).reduce(:+)
  end

  def set_miscellaneous_charges!
    update(miscellaneous_charges: true)
  end

  def total_add_ons_amount
    add_ons.map(&:amount).reduce(:+) || 0
  end

  def miscellaneous_charge_label
    "#{ax_sales_id} (#{user.first_name} #{user.last_name})"
  end

  # overrides Spree method
  def update!
    updater.update
    update(
      total: self.reload.amount + self.reload.adjustments.eligible.sum(:amount)
    )
  end

  def check_if_customer_is_present?
    if self.customer.is_present? 
      return true
    else
      return false
    end
  end

  def sna_voucher_ready?
    if @order.products.any? { |product| product.operator_id == 1 }
      return @order.ax_data['Envelope']['Order']['Total'].to_f == @order.total && !product.disable_departure_date
    end
    true
  end

  # method to update hubspot deals
  def send_to_hubspot
    hubspot_id = ""
    if self.customer.present? #&& self.user.blank? #if customer is not a user then use the default ID to create order  
      #find the Hubspot user id (called vid)
      hubspot_id = Hubspot::Contact.find_by_email(self.customer.email).vid

      #if not present then create new hubspot id and assigned the new id to hubspot_id
      if hubspot_id.present? != true
        hubspot_id = HubspotService::Send.user_to_hubspot_and_retrieve_hubspot_id(self.customer)
      end

      #check if payment is received? 
      if self.authorized == true 
        dealstage = ENV['HUBSPOT_STAGE_ID_ORDER_RECEIVED']
      else
        dealstage = ENV['HUBSPOT_STAGE_ID_ABANDONED_CART']
      end

      if @hubspot_deal_id.present? == true
        #update 
        HubspotService::Send.order_to_hubspot(self, hubspot_id, dealstage, @hubspot_deal_id)
      else
        #create hubspot deals
        HubspotService::Send.order_to_hubspot(self, hubspot_id, dealstage, "")
      end
    else
      return "ERROR CREATING HUBSPOT DEAL"
    end
  end

  private

  # overrides Spree method
  def require_email
    false
  end

end
