require 'active_support/concern'

module CustomerApprovable
  extend ActiveSupport::Concern

  def set_approval_time
    if self.customer_approved_changed?
      if self.customer_approved == true
        self.approved_at = Time.now
      end
    end
  end

  def check_customer_approved
    if self.customer_approved_changed?
      if self.customer_approved == true
        self.customer_review == false
      end
    end
  end
end
