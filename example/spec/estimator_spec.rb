require "spec_helper"
require "estimator"
require "customer"
require "rate"

RSpec.describe Estimator do
  subject { Estimator.new }

  describe "#advance" do
    let(:customer) { double }
    let(:rate) { double }
    let(:estimated_advance) { [80,90] }

    before do
      allow(subject).to receive(:customers).and_return([customer])
      allow(customer).to receive(:estimated_advance).and_return(estimated_advance)
    end

    it "should return the sum of the estimated min and max advances" do
      advance = subject.advance
      expect(advance.min).to eq customer.estimated_advance.min
      expect(advance.max).to eq customer.estimated_advance.max
    end
  end
end
