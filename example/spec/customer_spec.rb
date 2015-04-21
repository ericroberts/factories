require "spec_helper"
require "customer"

RSpec.describe Customer do
  subject { Customer.new(revenue: revenue) }
  let(:revenue) { 100 }

  describe "#estimated_advance" do
    let(:rate) { double }

    before do
      allow(subject).to receive(:rate).and_return(rate)
    end

  	it "should send the * message to rate" do
  	  expect(rate).to receive(:*).with(revenue)
  	  subject.estimated_advance
  	end
  end
end
