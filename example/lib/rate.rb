require_relative "../config/environment"

class Rate < ActiveRecord::Base
  def min
    self[:min] / 100.to_f
  end

  def max
    self[:max] / 100.to_f
  end

  def * other
    [
      min * other,
      max * other
    ]
  end
end
