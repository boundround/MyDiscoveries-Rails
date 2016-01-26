require 'active_support/concern'

module Parameterizable
  extend ActiveSupport::Concern
    def parameterize_identifier
      if !self.name.blank?
        self.identifier = self.name.parameterize
      else
        self.identifier = ""
      end
    end
end
