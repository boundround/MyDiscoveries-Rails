module Resources
	extend ActiveSupport::Concern

	included do

		class_attribute :model_resource
    class_attribute :use_resource
    class_attribute :identifier
    class_attribute :friendly_id
    class_attribute :includes_on_finder

    self.model_resource = nil
    self.use_resource = false
    self.identifier = :id
    self.friendly_id = true
    self.includes_on_finder = []

		helpers HelperMethods
	end

	module HelperMethods

		def set_resource class_context
			class_eval do
				class_attribute :class_context
				self.class_context = class_context
			end
			eval %{
				def #{resource_name}
					get_resource
				end
			}
		end

		def context_resource
			get_resource
		end

		def get_resource
			identifier_param_present? ? existing_resource : new_resource
		end

		def new_resource
	    resource_class_constant.new(resource_params)
	  end

	  def resource_params
			respond_to?("#{resource_name}_params") ? self.send("#{resource_name}_params") : {}
	  end

		def identifier_param_present?
			params[class_context.identifier.to_sym].present?
		end

		def existing_resource
			resource_obj = existing_resource_finder
  		if resource_obj.nil?
  			raise ActiveRecord::RecordNotFound
  		else
  			resource_obj
  		end
		end

		def existing_resource_finder
	    if friendly_identifier?
	    	resource_class_constant.friendly.includes(class_context.includes_on_finder).find(identifier_params)
	    else
	    	resource_class_constant.includes(class_context.includes_on_finder).send("find_by", identifier_params)
	  	end
	  end

	  def resource_class_constant
  		class_exists?(resource_class) ? resource_class.constantize : raise {ActiveRecord::RecordNotFound}
		end

		def class_exists?(class_name)
			 klass = Module.const_get(class_name)
	      return klass.is_a?(Class) && klass < ActiveRecord::Base
	    rescue NameError
	      return false
		end

		def resource_class
	    resource_class = self.class_context.model_resource
	    if resource_class.nil?
	      resource_class = class_context.name.demodulize.classify
	    end
	    resource_class
	  end

	  def resource_name
	    resource_class.downcase
	  end

	  def identifier_params
	  	identifier = class_context.identifier
	  	if identifier.is_a? Symbol
	  		par = {}
	  		par[identifier] = params[identifier]
	  	elsif identifier.is_a? Array
	  		Hash[identifier.map {|i|[i,params[i]]}]
	  	else
	  		{}
	  	end
	  end

	  def friendly_identifier?
	  	class_context.friendly_id
	  end

	end

	module ClassMethods

		def resourceable
			if use_resource
				class_context = self
				before do
					set_resource class_context
				end
			end
		end

		def use_resource!
			self.use_resource = true
			resourceable
		end

	end

end