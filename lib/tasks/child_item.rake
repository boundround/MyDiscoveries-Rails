namespace :child_item do
  desc "Remove all null items from child_items table"
  task :remove_null_items => :environment do
    ChildItem.all.each do |item|
      if item.itemable.blank?
        item.destroy
      elsif item.parentable.blank?
        item.destroy
      end
    end
  end
end
