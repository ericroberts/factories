require_relative "../config/environment"

class Estimator < ActiveRecord::Base
  has_many :customers

  def advance
    customers.inject([0,0]) do |(min, max), customer|
      min += customer.revenue * customer.rate.min
      max += customer.revenue * customer.rate.max
      [min, max]
    end
  end
end
