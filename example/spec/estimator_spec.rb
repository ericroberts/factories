require "spec_helper"
require "estimator"
require "customer"
require "rate"

RSpec.describe Estimator do
  subject { Estimator.new }

  describe "#projection" do
    let(:customer) { double }
    let(:rate) { double }
    let(:projection) { [80,90] }

    before do
      allow(subject).to receive(:customers).and_return([customer])
      allow(customer).to receive(:projection).and_return(projection)
    end

    it "should return the sum of the estimated min and max projections" do
      projection = subject.projection
      expect(projection.min).to eq customer.projection.min
      expect(projection.max).to eq customer.projection.max
    end
  end
end
