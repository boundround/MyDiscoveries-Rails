class ChildItem < ActiveRecord::Base
  belongs_to :itemable, :polymorphic => true
  belongs_to :parentable, :polymorphic => true

  #we save the relations to hbtm table after created ChildItem record
  # after_create :split_child_item

  def split_child_item
    if (self.parentable_type == "Country" && self.itemable_type != "Country") || (self.parentable_type == "Place" && self.itemable_type != "Place") || (self.parentable_type == "Region" && self.itemable_type != "Region") && (self.parentable_type == "Region" && self.itemable_type != "Country")

      if self.parentable_type == "Region"
        self.itemable.regions = [self.parentable] #Storing data to attractions_regions / places_regions

        if self.itemable_type == "Place"
          self.itemable.attractions.select{ |a| a.regions = [self.parentable] } #change all self child's region 
        end

        if self.itemable_type == "Attraction" && self.itemable.places.present?
          self.itemable.places.destroy_all
        end

      elsif parentable_type == "Country"
        parent_country = self.parentable.parent
        if parent_country.present? && parent_country.parentable_type == "Region"
          self.itemable.regions = [parent_country.parentable] #Storing data to attractions_regions / places_regions
          
          if self.itemable_type == "Place"
            self.itemable.attractions.select{ |a| a.regions = [parent_country.parentable] } #change all self child's region 
          end
            
          if self.itemable_type == "Attraction" && self.itemable.places.present?
            self.itemable.places.destroy_all
          end
        end

      elsif parentable_type == "Place"
        parent_country = self.parentable.parent
        parent_region = parent_country.parentable.parent
        unless parent_country.blank?
          if self.itemable_type == "Attraction" && parent_country.parentable_type == "Region"
            self.itemable.places = [self.parentable] #Storing data to attractions_places
            self.itemable.regions = [parent_country.parentable] #Storing data to attractions_regions
          
          elsif self.itemable_type == "Attraction" && (parent_country.parentable_type == "Country" || parent_region.parentable_type == "Region")
            self.itemable.places = [self.parentable] #Storing data to attractions_places
            self.itemable.regions = [parent_region.parentable] #Storing data to attractions_regions
          
          else
            self.itemable.places = [self.parentable] #Storing data to attractions_places
            if self.itemable.regions.present?
              self.itemable.regions.destroy_all
            end
          end
        end
      end
    else
      if (self.itemable_type == "Place" || self.itemable_type == "Attraction") && self.itemable.regions.present?
        self.itemable.regions.destroy_all
      end

      if self.itemable_type == "Attraction" && self.itemable.places.present?
        self.itemable.places.destroy_all
      end
    end
  end
end