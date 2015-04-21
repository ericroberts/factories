require "spec_helper"
require "estimator"
require "customer"
require "rate"

RSpec.describe Customer do
  subject { build :estimator }

  describe "#advance" do
    it "should return the sum of the estimated min and max advances" do
      customer = subject.customers.first

      expect(subject.advance).to eq [
        customer.revenue * customer.rate.min,
        customer.revenue * customer.rate.max
      ]
    end
  end
end
