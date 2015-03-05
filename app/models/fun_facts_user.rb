class FunFactsUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :fun_fact
end
