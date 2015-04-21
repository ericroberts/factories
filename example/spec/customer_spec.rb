require "spec_helper"
require "customer"

RSpec.describe Customer do
  subject { Customer.new(revenue: 100) }
  let(:rate) { double }
  let(:min) { 80 }
  let(:max) { 90 }

  before do
    allow(subject).to receive(:rate).and_return(rate)
    allow(rate).to receive(:min).and_return(min)
    allow(rate).to receive(:max).and_return(max)
  end

  it "should return the min and max advance" do
    expect(subject.estimated_advance).to eq [
      subject.revenue * rate.min,
      subject.revenue * rate.max
    ]
  end
end
