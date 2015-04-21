require "spec_helper"
require "estimator"
require "customer"
require "rate"

RSpec.describe Estimator do
  subject { Estimator.new }

  describe "#advance" do
    let(:customer) { double }
    let(:rate) { double }

    before do
      allow(subject).to receive(:customers).and_return([customer])
      allow(customer).to receive(:revenue).and_return(100)
      allow(customer).to receive(:rate).and_return(rate)
      allow(rate).to receive(:min).and_return(80)
      allow(rate).to receive(:max).and_return(90)
    end

    it "should return the sum of the estimated min and max advances" do
      advance = subject.advance
      expect(advance.min).to eq customer.revenue * customer.rate.min
      expect(advance.max).to eq customer.revenue * customer.rate.max
    end
  end
end
