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
        offer:      clean_text(offer),
        operator:   clean_text(operator),
        hero_photo: hero_photo,
        customer:   customer
      }
    )
  end

  def file_name
    @file_name ||= "mydiscoveries_#{'voucher'.pluralize(order.total_quantity)}.pdf"
  end

  def success
    file_name.present? && rendered_pdf.present?
  end

  def customer
    @customer ||= order.customer
  end

  def clean_text(datas)
    models_name = datas.class
    columns = models_name.column_names
    columns.each do |col|
      if (models_name.columns_hash[col].type == :text ||
          models_name.columns_hash[col].type == :string) &&
          datas[col].present?
        datas[col] = datas[col].gsub(/[”“’]/, "”" => "\"", "“" => "\"", "’" => "\'")
      end
    end
    datas
  end

end
