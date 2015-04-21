class Rate
  attr_accessor :min, :max

  def initialize(min: 80, max: 90)
    @min, @max = min, max
  end
end
