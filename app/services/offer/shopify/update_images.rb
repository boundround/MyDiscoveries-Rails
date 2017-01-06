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
      images_to_add.each { |img| product.images << img }
      product.save
    end
  end

  def images_to_add
    @images_to_delete ||= offer_images.reject do |img|
      img[:src].in?(product_image_srcs)
    end
  end

  def images_to_delete
    @images_to_add ||= product_images.reject do |img|
      img[:src].in?(offer_image_srcs)
    end
  end

  def product_images
    @product_images ||= product.images.map do |img|
      { id: img.id, src: img.src, position: img.position }
    end
  end

  def product_image_srcs
    @product_image_srcs ||= product.images.map(&:src)
  end

  def offer_images
    @offer_images ||= decorated_product.images
  end

  def offer_image_srcs
    @offer_image_src ||= offer_images.map { |img| img[:src] }
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
