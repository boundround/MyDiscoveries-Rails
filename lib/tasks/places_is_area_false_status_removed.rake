namespace :places do
  desc "Makes all Places that were copied over to Attractions table status removed"
  task :is_area_false_change_status_removed => :environment do
    Place.where("is_area = ? and status != ?", "false", "removed").each do |place|
      place.update(status: 'removed', run_rake: true)
    end
  end
end