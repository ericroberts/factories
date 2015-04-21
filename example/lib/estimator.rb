require_relative "../config/environment"

class Estimator < ActiveRecord::Base
  has_many :customers

  def advance
    customers.inject([0,0]) do |(min, max), customer|
      min += customer.estimated_advance.min
      max += customer.estimated_advance.max
      [min, max]
    end
  end
end
