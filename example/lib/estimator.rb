require_relative "../config/environment"
require "min_max"

class Estimator < ActiveRecord::Base
  has_many :customers

  def projection
    customers.map(&:projection).inject(MinMax.zero, :+)
  end
end
