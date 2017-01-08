class Offer::Shopify::UpdateImages
  include Service

  initialize_with_parameter_assignment :offer

  def call
    set_images
  end

  private

  def set_images
    images_to_delete.each { |img| destroy_image(img[:id]) }

    if images_to_add.any?
      images_to_add.each do |image|
        shopify_image = ShopifyAPI::Image.new(image)
        offers_photo  = OffersPhoto.find(image[:offers_photo_id])
        offers_photo.update(shopify_image_id: shopify_image.id.to_s) if shopify_image.save
      end
    end
  end

  def images_to_add
    @images_to_add ||= offer_images.reject do |img|
      img[:shopify_image_id].in?(product_image_ids)
    end
  end

  def images_to_delete
    @images_to_delete ||= product_images.reject do |img|
      img[:id].to_s.in?(offer_image_ids)
    end
  end

  def product_images
    @product_images ||= product.images.map do |img|
      { id: img.id.to_s, src: img.src, position: img.position }
    end
  end

  def product_image_ids
    @product_image_srcs ||= product_images.map { |img| img[:id] }
  end

  def offer_images
    @offer_images ||= decorated_product.images
  end

  def offer_image_ids
    @offer_image_src ||= offer_images.map { |img| img[:shopify_image_id] }.compact
  end

  def destroy_image(image_id)
    image = ShopifyAPI::Image.find(image_id, params: { product_id:  product.id })
    image.destroy
  end

  def product
    @product ||= decorated_product.product
  end

  def decorated_product
    Offer::Shopify::ProductDecorator.new(self)
  end
end
