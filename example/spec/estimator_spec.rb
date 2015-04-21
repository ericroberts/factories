require "spec_helper"
require "estimator"
require "customer"
require "rate"

RSpec.describe Estimator do
  subject { customer.estimator }
  let(:customer) { create :customer }

  describe "#projection" do
    it "should return the sum of the estimated min and max projections" do
      projection = subject.projection
      expect(projection.min).to eq customer.revenue * customer.rate.min
      expect(projection.max).to eq customer.revenue * customer.rate.max
    end
  end
end
