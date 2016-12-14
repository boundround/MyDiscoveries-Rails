require 'httparty'

class LivnOffersCreationService
  include Service

  initialize_with_parameter_assignment :product_id

  ERROR_STATUSES = [400, 401, 403, 404]

  Response = Struct.new(:offer, :http_response, :errors, :status) do
    def success?
      status == :success
    end

    def fail?
      status == :fail
    end
  end

  def call
    retrieve_product
    errors_handling

    response
  end

  def retrieve_product
    if product_id_valid?
      begin
        response.http_response = HTTParty.get(
          ENV['LIVN_RETRIEVE_PRODUCT_URL'] + product_id,
          basic_auth: credentials,
          headers: { 'Accept' => 'application/json' }
        )
      rescue HTTParty::Error, StandardError => e
        response.errors << e.to_s
      end
    end
  end

  def response
    @response ||= Response.new(nil, nil, [], nil)
  end

  private

  def errors_handling
    if !product_id_valid?
      response.status = :fail
      response.errors << "Wrong LIVN Product ID"
    elsif response.errors.any?
      response.status = :fail
    elsif ERROR_STATUSES.include?(response.http_response.code)
      response.status = :fail
      response.errors <<
        "LIVN error: #{response.http_response.parsed_response['webApplicationException']['message']}"
    else
      validate_and_create_offer(response.http_response.parsed_response['product'])
    end
  end

  def validate_and_create_offer(product)
    response.offer = Offer.new
    attributes = Offer.attribute_names - except_attributes

    attributes.each do |attribute|
      response.offer.send "#{attribute}=", product.try(:[], attribute)
    end

    response.offer.livn_product_id = product_id

    if response.offer.save
      response.status = :success
    else
      response.offer.errors.full_messages.each{ |msg| response.errors << msg }
      response.status = :fail
    end
  end

  def except_attributes
    %w{ id created_at attraction_id updated_at }
  end

  def credentials
    { username: ENV['LIVN_USERNAME'], password: ENV['LIVN_PASSWORD'] }
  end

  def product_id
    @id ||= @product_id.to_s.strip
  end

  def product_id_valid?
    product_id.present? && product_id_valid_type
  end

  # '3'   => valid
  # 3     => valid
  # 'asd' => invalid
  def product_id_valid_type
    product_id.to_i.to_s == product_id
  end
end
