shop_url = "https://#{ENV['SHOPIFY_API_KEY']}:#{ENV['SHOPIFY_PASSWORD']}@bound-round.myshopify.com/admin"
ShopifyAPI::Base.site = shop_url
