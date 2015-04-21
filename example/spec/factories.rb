require "factory_girl"

FactoryGirl.define do
  factory :rate do
    min 80
    max 90
  end

  factory :customer do
    revenue 100
    rate { build(:rate) }
  end

  factory :estimator do
    customers { [build(:customer)] }
  end
end
