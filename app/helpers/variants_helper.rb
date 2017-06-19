module VariantsHelper
  def variant_edit_link_label(variant)
    if variant.miscellaneous_charges?
      "Variant ##{variant.id} (Miscellaneous Charges)"
    else
      "Variant ##{variant.id}"
    end
  end
end
