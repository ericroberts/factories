require "factory_girl"
require "ostruct"

FactoryGirl.define do
  factory :estimator do
    customers { [create(:customer)] }
  end

  factory :customer do
    association :rate
    revenue 100
  end

  factory :rate do
    min 80
    max 90
  end
end
