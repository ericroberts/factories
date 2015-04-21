class MinMax
  attr_reader :min, :max

  def initialize(min, max)
    @min, @max = min, max
  end

  def + other
    self.class.new(min + other.min, max + other.max)
  end

  def self.zero
    new(0, 0)
  end
end
