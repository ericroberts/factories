require_relative "../config/environment"

class Estimator < ActiveRecord::Base
  has_many :customers

  def projection
    customers.inject([0,0]) do |(min, max), customer|
      min += customer.projection.min
      max += customer.projection.max
      [min, max]
    end
  end
end
