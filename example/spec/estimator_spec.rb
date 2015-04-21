require "spec_helper"
require "estimator"
require "customer"
require "rate"

RSpec.describe Estimator do
  subject { customer.estimator }
  let(:customer) { create :customer }

  describe "#advance" do
    it "should return the sum of the estimated min and max advances" do
      advance = subject.advance
      expect(advance.min).to eq customer.revenue * customer.rate.min
      expect(advance.max).to eq customer.revenue * customer.rate.max
    end
  end
end
