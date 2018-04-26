namespace :offers do
  desc "Publish scheduled offers"
  task publish: :environment do
    Spree::Product.publishing_queue.each do |offer|
      offer.status = 'live'
      offer.save
    end
  end

  task expire: :environment do |offer|
  	Spree::Product.expiring_queue.each do |offer|
  	  offer.status = offer.publishenddate_status
  	  offer.save
  	end
  end
end