require "spec_helper"
require "customer"

RSpec.describe Customer do
  subject { FactoryGirl.build(:customer) }
end
