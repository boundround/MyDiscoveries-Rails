namespace :copy_supplier_codes do
  desc "Copy supplier product codes over to associated offers"
  task :copy_codes => :environment do
    offers = Offer.where.not(supplier_product_code: [nil, ''])
    offers.each do |offer|
      if offer.related_offers.present? && offer.supplier_product_code.present?
        offer.related_offers.each do |assoc|
          if assoc.related_offer
            assoc.related_offer.supplier_product_code = offer.supplier_product_code
            assoc.related_offer.save
          end
        end
      end
    end
  end
end
