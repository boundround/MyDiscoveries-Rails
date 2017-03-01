class Ax::Download
  include Service

  initialize_with_parameter_assignment :xml_file

  def call
    process
  end

  private

  def process
    if !order_present?
      ActiveRecord::Base.transaction do
        user     = process_user
        customer = save_customer(user)        if user && user.persisted?
        @order   = save_order(user, customer) if customer && customer.persisted?
      end

      OrderAuthorized.delay.notification(@order.id) if @order && @order.persisted?
    end
  end

  def order_present?
    Order.find_by(ax_sales_id: order_sales_id).present?
  end

  def converted_xml
    @converted_xml ||= Hash.from_xml(xml_file)
  end

  def xml_order
    @xml_order ||= converted_xml['Envelope']['Order']
  end

  def cust_account
    @cust_account ||= xml_order['CustAccount']
  end

  def customer_email
    @customer_email ||= xml_order['EmailAddress']
  end

  def user_from_db
    @user_from_db ||= User.find_by(ax_cust_account: cust_account)
  end

  def new_user
    user = User.new(ax_cust_account: cust_account, created_from_ax: true)

    # skip email & password validation
    user.save(validate: false)

    user
  end

  def process_user
    user_from_db || new_user
  end

  def shipping_address
    @shipping_address ||= xml_order['ShippingAddress']
  end

  def customer_country
    @customer_country ||= shipping_address['Country']
  end

  def customer_email
    @customer_email ||= xml_order['EmailAddress']
  end

  def customer_first_name
    @customer_first_name ||= shipping_address['FirstName']
  end

  def customer_last_name
    @customer_last_name ||= shipping_address['LastName']
  end

  def customer_phone_number
    @customer_phone_number ||= shipping_address['PhoneNumber']
  end

  def customer_city
    @customer_city ||= shipping_address['City']
  end

  def customer_state
    @customer_city ||= shipping_address['State']
  end

  def customer_postal_code
    @customer_postal_code ||= shipping_address['PostCode']
  end

  def customer_address_one
    @customer_address_one ||= shipping_address['AddressOne']
  end

  def customer_address_two
    @customer_address_two ||= shipping_address['AddressTwo']
  end

  def customer_address_three
    @customer_address_three ||= shipping_address['AddressThree']
  end

  def customer_title
    @customer_title ||= shipping_address['Title']
  end

  def save_customer(user)
    customer = Customer.new(
      user:            user,
      country:         customer_country,
      email:           customer_email,
      title:           customer_title,
      first_name:      customer_first_name,
      last_name:       customer_last_name,
      phone_number:    customer_phone_number,
      city:            customer_city,
      state:           customer_state,
      postal_code:     customer_postal_code,
      address_one:     customer_address_one,
      address_two:     customer_address_two,
      address_three:   customer_address_three,
      created_from_ax: true
    )

    customer.save(validate: false)
    customer
  end

  def total_price
    @total_price ||= xml_order['Total'].to_i
  end

  def offer
    @offer ||= Offer.where(
      'item_id IN (?) OR child_item_id IN (?)',
      xml_item_ids,
      xml_item_ids
    ).first
  end

  def xml_item_ids
    @xml_item_ids ||= if xml_order['Items']['Item'].is_a?(Hash)
      [xml_order['Items']['Item']['ItemId']]
    else
      xml_order['Items']['Item'].map{ |i| i['ItemId'] }.uniq
    end
  end

  def order_sales_id
    @order ||= xml_order['SalesId']
  end

  def purchase_date
    @purchase_date ||= DateTime.parse("#{xml_order['OrderDate']} #{xml_order['OrderTime']}")
  end

  def save_order(user, customer)
    order = user.orders.build(
      customer:           customer,
      offer:              offer,
      title:              offer.name,
      created_from_ax:    true,
      total_price:        total_price,
      ax_sales_id:        order_sales_id,
      number_of_adults:   xml_item_ids.count(offer.item_id),
      number_of_children: xml_item_ids.count(offer.child_item_id),
      purchase_date:      purchase_date,
      status:             :authorized
    )

    order.save
    order
  end
end
