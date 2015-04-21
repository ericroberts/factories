require_relative "../config/environment"

class Customer < ActiveRecord::Base
  belongs_to :rate
  belongs_to :estimator

  def estimated_advance
    [
      revenue * rate.min,
      revenue * rate.max
    ]
  end
end
