require_relative "../config/environment"
require "min_max"

class Estimator < ActiveRecord::Base
  has_many :customers

  def advance
    customers.inject(MinMax.zero) do |minmax, customer|
      minmax + customer.estimated_advance
    end
  end
end
