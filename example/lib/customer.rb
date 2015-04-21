require_relative "../config/environment"

class Customer < ActiveRecord::Base
  belongs_to :rate
  belongs_to :estimator

  def estimated_advance
    rate * revenue
  end
end
