  class GeneratePdf
  include Service

  initialize_with_parameter_assignment :order

  def call
    @controller = ActionController::Base.new
    response
  end

  private

  def response
    @response ||= {
      file:      rendered_pdf,
      file_name: file_name,
      success:   success
    }
  end

  def rendered_pdf
    @pdf ||= WickedPdf.new.pdf_from_string(
      rendered_view, show_as_html: true
    )
  end

  def rendered_view
    @rendered_view ||= @controller.render_to_string(
      template: 'vouchers/index.pdf.erb',
      locals: {
        order:      order,
        offer:      offer,
        operator:   operator,
        hero_photo: hero_photo,
        passengers: passengers,
        customer:   customer
      }
    )
  end

  def file_name
    @file_name ||= "mydiscoveries_#{'voucher'.pluralize(passengers.count)}.pdf"
  end

  def hero_photo
    @hero_photo ||= order.product.photos.where(hero: true).last
  end

  def offer
    @offer ||= order.product
  end

  def operator
    @operator ||= offer.operator
  end

  def passengers
    @passenger ||= order.passengers
  end

  def success
    file_name.present? && rendered_pdf.present?
  end

  def customer
    @customer ||= order.customer
  end

end
