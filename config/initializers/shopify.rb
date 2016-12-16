shop_url = "https://#{ENV['SHOPIFY_API_KEY']}:#{ENV['SHOPIFY_PASSWORD']}@#{ENV['SHOPIFY_STORE_DOMAIN']}/admin"
ShopifyAPI::Base.site = shop_url
