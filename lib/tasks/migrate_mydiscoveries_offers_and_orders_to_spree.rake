namespace :spree do
  desc "migrate all offers to spree_products and orders to spree_orders"
  task md_migrate: :environment do

    Offer.all.each do |offer|
      product             = Spree::Product.new
      offer_attributes    = offer.attributes.keys
      rejected_attributes = ['id']
      products_attributes = offer_attributes - rejected_attributes

      products_attributes.each do |attribute|
        product.send("#{attribute}=", offer.send("#{attribute}"))
      end

      offer.photos.each do |photo|
        product.photos << photo
      end

      offer.videos.each do |video|
        product.videos << video
      end

      offer.attractions.each do |attraction|
        product.attractions << attraction
      end

      offer.places.each do |place|
        product.places << place
      end

      offer.countries.each do |country|
        product.countries << country
      end

      offer.regions.each do |region|
        product.regions << region
      end

      offer.subcategories.each do |subcategory|
        product.subcategories << subcategory
      end

      offer.users.each do |user|
        product.users << user
      end

      product.save(validate: false)
    end

    RelatedOffer.all.each do |ro|
      product =         Spree::Product.find_by(slug: ro.offer.slug)
      related_product = Spree::Product.find_by(slug: ro.related_offer.slug)

      Spree::RelatedProduct.create(
        product: product,
        related_product: related_product
      )
    end

    Order.all.each do |order|
      spree_order            = Spree::Order.new
      order_attributes       = order.attributes.keys
      rejected_attributes    = ['id', 'offer_id', 'status', 'shopify_order_id', 'is_voucher_sent']
      spree_order_attributes = order_attributes - rejected_attributes

      spree_order_attributes.each do |attribute|
        spree_order.send("#{attribute}=", order.send("#{attribute}"))
      end

      related_product        = Spree::Product.find_by(slug: order.offer.slug)
      spree_order.product    = related_product
      spree_order.authorized = true if order.authorized?

      passengers             = Passenger.where(order_id: order.id)
      spree_order.passengers = passengers

      spree_order.save
    end
  end
end
