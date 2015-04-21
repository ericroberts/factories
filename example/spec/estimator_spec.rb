require "spec_helper"
require "estimator"
require "customer"
require "rate"

RSpec.describe Estimator do
  subject { Estimator.new }

  describe "#projection" do
    let(:customer) { double }
    let(:rate) { double }

    before do
      allow(subject).to receive(:customers).and_return([customer])
      allow(customer).to receive(:revenue).and_return(100)
      allow(customer).to receive(:rate).and_return(rate)
      allow(rate).to receive(:min).and_return(80)
      allow(rate).to receive(:max).and_return(90)
    end

    it "should return the sum of the estimated min and max projections" do
      projection = subject.projection
      expect(projection.min).to eq customer.revenue * customer.rate.min
      expect(projection.max).to eq customer.revenue * customer.rate.max
    end
  end
end
