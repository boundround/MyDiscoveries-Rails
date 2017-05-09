namespace :spree do
  desc "update stree orders states and create line_items"
  task update_orders_and_add_line_items: :environment do

    #set all orders as completed
    Spree::Order.all.each do |order|
      order.created_by_id = order.user_id
      order.state = 'completed'
      order.completed_at = order.updated_at

      order.save(validate: false)
    end

    # destroys all existing varinats & generetes new
    Spree::Variant.destroy_all

    Spree::Product.all.each do |product|
      Spree::Variant.maturities.keys.each do |maturity|
        Spree::Variant.bed_types.keys.each do |bed_type|

          amount = if maturity == 'adult' && bed_type == 'single'
            product.minRateAdult
          else
            if product.minRateChild.blank? || product.minRateChild.zero?
              product.minRateAdult
            else
              product.minRateChild
            end
          end

          item_code = if maturity == 'adult' && bed_type == 'single'
            product.item_id
          else
            product.child_item_id
          end

          variant = product.variants.create(
            bed_type: bed_type,
            maturity: maturity,
            product: product,
            price: amount,
            departure_city: product.locationStart,
            track_inventory: false,
            item_code: item_code
          )
        end
      end
    end

    Spree::Order.all.each do |order|
      # generates first of all the line_items based on ax_data if present
      if order.ax_line_items.any?
        order.ax_line_items.each do |line_item|
          variant = order.product.variants.find_by(item_code: line_item['ItemId'])
          quantity = line_item['Quantity'].to_i > 0 ? line_item['Quantity'].to_i : 1
          order.contents.add(variant, quantity) if variant
          current_line_item = order.line_items.find_by(variant: variant)
          current_line_item.set_request_installments! if line_item['OSSPaymSched'].to_i == 5
        end
      else
        # add adults line_items
        if order.number_of_adults > 0
          variant = order.product.variants.find_by(item_code: order.product.item_id)
          order.contents.add(variant, order.number_of_adults)
          line_item = order.line_items.find_by(variant: variant)
          line_item.set_request_installments! if order.request_installments?
        end

        # add child line_items
        if order.number_of_children > 0
          variant = order.product.variants.find_by(item_code: order.product.child_item_id)
          order.contents.add(variant, order.number_of_children)
          line_item = order.line_items.find_by(variant: variant)
          line_item.set_request_installments! if order.request_installments?
        end
      end
    end
  end
end
