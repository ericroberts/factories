require "spec_helper"
require "min_max"

RSpec.describe MinMax do
  subject { MinMax.new(min, max) }
  let(:min) { 80 }
  let(:max) { 90 }

  describe "#+" do
    let(:other) { [min, max] }

    it "should return a new object that responds to min and max" do
      new_min_max = subject + other
      expect(new_min_max.min).to eq subject.min + other.min
      expect(new_min_max.max).to eq subject.max + other.max
    end
  end
end
