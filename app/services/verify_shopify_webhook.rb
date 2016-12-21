require 'base64'
require 'openssl'

class VerifyShopifyWebhook
  include Service

  initialize_with_parameter_assignment :data, :hmac_header

  def call
    verify_webhook(data, hmac_header)
  end

  private

  def verify_webhook(data, hmac_header)
    digest = OpenSSL::Digest.new('sha256')
    calculated_hmac = Base64.encode64(OpenSSL::HMAC.digest(digest, ENV['SHOPIFY_WEBHOOKS_KEY'], data)).strip
    calculated_hmac == hmac_header
  end
end
