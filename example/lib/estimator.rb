require_relative "../config/environment"
require "min_max"

class Estimator < ActiveRecord::Base
  has_many :customers

  def projection
    customers.inject(MinMax.zero) do |minmax, customer|
      minmax + customer.projection
    end
  end
end
