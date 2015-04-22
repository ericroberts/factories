require "spec_helper"
require "rate"

RSpec.describe Rate do
  subject { Rate.new(min: min, max: max) }
  let(:min) { 80 }
  let(:max) { 90 }

  describe "#*" do
    let(:multiplier) { 100 }

    it "should return the two possible rates" do
      expect(subject * multiplier).to eq [
        min/100.to_f * multiplier,
        max/100.to_f * multiplier
      ]
    end
  end
end
