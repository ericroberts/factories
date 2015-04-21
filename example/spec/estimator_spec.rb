require "spec_helper"
require "estimator"
require "customer"
require "rate"

RSpec.describe Customer do
  include FactoryGirl::Syntax::Methods

  subject         { build :estimator }
  let(:customer)  { build :customer, rate: rate, revenue: revenue }
  let(:rate)      { build :rate }
  let(:revenue)   { 100 }

  describe "#advance" do
    it "should return the sum of the estimated min and max advances" do
      expect(subject.advance).to eq [revenue * rate.min, revenue * rate.max]
    end
  end
end
