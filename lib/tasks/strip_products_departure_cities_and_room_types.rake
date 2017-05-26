namespace :products do
  desc "strip leading and ending whitespace for departure_city and room_type fields"
  task :strip_departure_city_and_room_type => :environment do
    Spree::Variant.all.each do |variant|
      variant.update_columns(
        departure_city: variant.departure_city.try(:strip!),
        room_type: variant.room_type.try(:strip!)
      )
    end
  end
end
