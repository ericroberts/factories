class MinMax
  attr_reader :min, :max

  def initialize(min, max)
    @min, @max = min, max
  end

  def + other
    new_min = min + other.min
    new_max = max + other.max
    self.class.new(new_min, new_max)
  end

  def self.zero
    new(0, 0)
  end
end
