![](factory.jpg)
## What factories are hiding from you
#### Eric Roberts — __@eroberts__

---

## What is a factory?

---

Test factories are helpers for creating
data that can be used in tests.

---

``` ruby
FactoryGirl.define do
  factory :user do
    name "Eric Roberts"
    email "eric@boltmade.com"
  end
end

user = FactoryGirl.create(:user)
#=> #<User id: 1, name: "Eric Roberts", email: "eric@boltmade.com">

user.name
#=> "Eric Roberts"

user.email
#=> "eric@boltmade.com"

```

---

## So, what's wrong with factories?

---

# They're slow!

---

``` ruby
FactoryGirl.define do
  factory :user do
    name "Eric Roberts"
    email "eric@boltmade.com"
  end
end
```

---

``` ruby
FactoryGirl.create(:user)
```

---

``` sql
INSERT INTO "users" ("name", "email", "created_at", "updated_at") 
VALUES (?, ?, ?, ?)  [
	["name", "Eric"],
	["email", "eric@boltmade.com"],
	["created_at", "2015-04-21 01:08:49.409179"],
	["updated_at", "2015-04-21 01:08:49.409179"]
]
```

---

``` ruby
FactoryGirl.define do
  factory :user do
    association :company

    name "Eric Roberts"
    email "eric@boltmade.com"
  end
  
  factory :company do
    name "Boltmade"
  end
end
```

---

``` ruby
FactoryGirl.create(:user)
```

---

``` sql
INSERT INTO "companies" ("name", "created_at", "updated_at")
VALUES (?, ?, ?)  [
	["name", "Boltmade"],
	["created_at", "2015-04-21 01:22:24.307976"],
	["updated_at", "2015-04-21 01:22:24.307976"]
]

INSERT INTO "users" ("name", "email", "company_id", "created_at", "updated_at")
VALUES (?, ?, ?, ?, ?)  [
	["name", "Eric"],
	["email", "eric@boltmade.com"],
	["company_id", 1],
	["created_at", "2015-04-21 01:22:24.311557"],
	["updated_at", "2015-04-21 01:22:24.311557"]
]
```

---

### Saving _0.1 seconds_ per test on 1200 tests saves you a total of _2 minutes_ every time the tests run.

---

## Don't you know about `build_stubbed`?

^ Yes, I know about build_stubbed. While speed is a concern, it's not the only concern.

---

## What else is wrong
## with them?

---

## They make bad
## design easy

---

## What is the point of TDD?

---

## fewer bugs

---

## self-testing code

---

## refactor with confidence

---

# better
# design

---

### Let's take a look at some code

---

``` ruby
class Estimator < ActiveRecord::Base
  has_many :customers

  def projection
    customers.inject([0,0]) do |(min, max), customer|
      min += customer.revenue * customer.rate.min
      max += customer.revenue * customer.rate.max
      [min, max]
    end
  end
end

class Customer < ActiveRecord::Base
  belongs_to :rate
  belongs_to :estimator
  
  # revenue method added by ActiveRecord
end

class Rate < ActiveRecord::Base
  def min
    self[:min] / 100.to_f
  end

  def max
    self[:max] / 100.to_f
  end
end
```

---

``` ruby
FactoryGirl.define do
  factory :estimator do
  end

  factory :customer do
    association :rate
    association :estimator
    revenue 100
  end

  factory :rate do
    min 80
    max 90
  end
end

```

---

``` ruby
RSpec.describe Estimator do
  subject { customer.estimator }
  let(:customer) { create :customer }

  describe "#projection" do
    it "should return the sum of the estimated min and max projections" do
      expect(subject.projection).to eq [
        customer.revenue * customer.rate.min,
        customer.revenue * customer.rate.max
      ]
    end
  end
end
```

---

``` bash
.

Finished in 0.0482 seconds (files took 0.38182 seconds to load)
1 example, 0 failures
```

---

### Requirement: Don't use factories.

---

``` ruby
RSpec.describe Estimator do
  subject { customer.estimator }
  let(:customer) { create :customer }

  describe "#projection" do
    it "should return the sum of the estimated min and max projections" do
      expect(subject.projection).to eq [
        customer.revenue * customer.rate.min,
        customer.revenue * customer.rate.max
      ]
    end
  end
end
```

---

``` ruby
RSpec.describe Estimator do
  subject { Estimator.new }

  describe "#projection" do
    let(:customer) { double }

    before do
      allow(subject).to receive(:customers).and_return([customer])
    end

    [...]
  end
end
```

---

``` bash
F

Failures:

  1) Estimator#projection should return the sum of the estimated min and max projections
     Failure/Error: expect(subject.projection).to eq [
       Double received unexpected message :revenue with (no args)
     # ./lib/estimator.rb:8:in `block in projection'
     # ./lib/estimator.rb:7:in `each'
     # ./lib/estimator.rb:7:in `inject'
     # ./lib/estimator.rb:7:in `projection'
     # ./spec/estimator_spec.rb:17:in `block (3 levels) in <top (required)>'

Finished in 0.01076 seconds (files took 0.38914 seconds to load)
1 example, 1 failure
```

---

``` ruby
RSpec.describe Estimator do
  subject { Estimator.new }

  describe "#projection" do
    let(:customer) { double }

    before do
      allow(subject).to receive(:customers).and_return([customer])
      allow(customer).to receive(:revenue).and_return(100)
    end

    [...]
  end
end
```

---

``` ruby
RSpec.describe Estimator do
  subject { Estimator.new }

  describe "#projection" do
    let(:customer) { double }
    let(:rate) { double }

    before do
      allow(subject).to receive(:customers).and_return([customer])
      allow(customer).to receive(:revenue).and_return(100)
      allow(customer).to receive(:rate).and_return(rate)
    end

    [...]
  end
end
```

---

``` ruby
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

    [...]
  end
end
```

---

``` ruby
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
      expect(subject.projection).to eq [
        customer.revenue * customer.rate.min,
        customer.revenue * customer.rate.max
      ]
    end
  end
end
```

---

``` ruby
class Estimator < ActiveRecord::Base
  has_many :customers

  def projection
    customers.inject([0,0]) do |(min, max), customer|
      min += customer.revenue * customer.rate.min
      max += customer.revenue * customer.rate.max
      [min, max]
    end
  end
end
```

---

``` bash
.

Finished in 0.0171 seconds (files took 0.40143 seconds to load)
1 example, 0 failures
```

---

# That's _3**x**_ faster!

---

## Testing with all these stubs is _painful_

---

# That's good.

^ If the only benefit was a speed improvement this may not be worth it.

---

<sub>To paraphrase Justin Searls in [The Failures of "Intro to TDD"](http://blog.testdouble.com/posts/2014-01-25-the-failures-of-intro-to-tdd.html):</sub>

Your tools and practices should encourage you to do the right thing at each step in your workflow.

---

``` ruby
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
      expect(subject.projection).to eq [
        customer.revenue * customer.rate.min,
        customer.revenue * customer.rate.max
      ]
    end
  end
end
```

---

``` ruby
class Estimator < ActiveRecord::Base
  has_many :customers

  def projection
    customers.inject([0,0]) do |(min, max), customer|
      min += customer.revenue * customer.rate.min
      max += customer.revenue * customer.rate.max
      [min, max]
    end
  end
end
```

---

## _Estimator_ knows way too much about _Customer_

---

## What do we want from customer?

---

## #projection

---

``` ruby
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

  it "should return the min and max projection" do
    expect(subject.projection).to eq [
      subject.revenue * rate.min,
      subject.revenue * rate.max
    ]
  end
end

```

---

``` ruby
class Customer < ActiveRecord::Base
  belongs_to :rate
  belongs_to :estimator

  def projection
    [
      revenue * rate.min,
      revenue * rate.max
    ]
  end
end
```

---

## Let's revisit the Estimator tests

---

``` ruby
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
      expect(subject.projection).to eq [
        customer.revenue * customer.rate.min,
        customer.revenue * customer.rate.max
      ]
    end
  end
end
```

---

``` ruby
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
      expect(subject.projection).to eq [
        projection.min,
        projection.max
      ]
    end
  end
end
```

---

``` ruby
class Estimator < ActiveRecord::Base
  has_many :customers

  def projection
    customers.inject([0,0]) do |(min, max), customer|
      min += customer.projection.min
      max += customer.projection.min
      [min, max]
    end
  end
end
```

---

``` bash
..

Finished in 0.01977 seconds (files took 0.39439 seconds to load)
2 examples, 0 failures
```

---

``` ruby
RSpec.describe Customer do
  subject { Customer.new }
  
  describe "#projection" do
	let(:rate) { double }
	
  	before do
  	  allow(subject).to receive(:rate).and_return(rate)
  	  allow(rate).to receive(:min).and_return(min)
  	  allow(rate).to receive(:max).and_return(max)
  	end
  	
  	it "should return the min and max projection" do
  	  expect(subject.projection).to eq [
  	    customer.revenue * rate.min,
  	    customer.revenue * rate.max
  	  ]
  	end
  end
end
```

---

## _Customer_ knows too
## much about _Rate_

---

### What do we want to do with Rate?

---

``` ruby
[
  rate.min * revenue,
  rate.max * revenue
]
#=> [80, 90]
```

---

``` ruby
rate * revenue
#=> [80, 90]
```

---

``` ruby
RSpec.describe Rate do
  subject { Rate.new(min: min, max: max) }
  let(:min) { 80 }
  let(:max) { 90 }
  
  describe "#*" do
  	let(:multiplier) { 100 }

  	it "should return the two possible rates" do
  	  expect(subject * multiplier).to eq [
  	    min * multiplier,
  	    max * multiplier
  	  ]
  	end
  end
end
```

---

``` ruby
class Rate < ActiveRecord::Base
  def min
    self[:min] / 100.to_f
  end

  def max
    self[:max] / 100.to_f
  end

  def * other
    [
      min * other,
      max * other
    ]
  end
end
```

---

``` ruby
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

  it "should return the min and max projection" do
    expect(subject.projection).to eq [
      subject.revenue * rate.min,
      subject.revenue * rate.max
    ]
  end
end
```

---

``` ruby
RSpec.describe Customer do
  subject { Customer.new(revenue: revenue) }
  let(:revenue) { 100 }

  describe "#projection" do
    let(:rate) { double }

    before do
      allow(subject).to receive(:rate).and_return(rate)
    end

  	it "should send the * message to rate" do
  	  expect(rate).to receive(:*).with(revenue)
  	  subject.projection
  	end
  end
end
```

---

``` ruby
class Customer < ActiveRecord::Base
  belongs_to :rate
  belongs_to :estimator
  
  def projection
  	rate * revenue
  end
end
```

---

## Let's revisit Estimator

---

``` ruby
class Estimator < ActiveRecord::Base
  has_many :customers

  def projection
    customers.inject([0,0]) do |(min, max), customer|
      min += customer.projection[0]
      max += customer.projection[1]
      [min, max]
    end
  end
end
```

---

## _Estimator_ knows too much about _Rate_

---

## What I'd like to do...

---

``` ruby
class Estimator < ActiveRecord::Base
  has_many :customers

  def projection
    customers.inject([0,0]) do |sum, customer|
      sum + customer.projection
    end
  end
end
```

---

``` ruby
RSpec.describe MinMax do
  subject { MinMax.new(min, max) }
  let(:min) { 80 }
  let(:max) { 90 }

  describe "#+" do
    let(:other) { [min, max] }

    it "should return a new object that responds to min and max" do
      new_min_max = subject + other
      expect(new_min_max.min).to eq subject.min + other.min
      expect(new_min_max.max).to eq subject.max + other.max
    end
  end
end
```

---

``` ruby
class MinMax
  attr_reader :min, :max

  def initialize(min, max)
    @min, @max = min, max
  end

  def + other
    self.class.new(min + other.min, max + other.max)
  end

  def self.zero
    new(0, 0)
  end
end
```

---

``` ruby
MinMax.new(1, 10)
#=> #<MinMax:0x007ff19604e2e8 @min=1, @max=10>

MinMax.new(2, 10)
#=> #<MinMax:0x007ff193045650 @min=2, @max=10>

MinMax.new(1, 10) + MinMax.new(2, 10)
#=> #<MinMax:0x007ff1950009b8 @min=3, @max=20>

```

---

``` ruby
class Estimator < ActiveRecord::Base
  has_many :customers

  def projection
    customers.inject(MinMax.zero) do |minmax, customer|
      minmax + customer.projection
    end
  end
end
```

---

``` bash
....

Finished in 0.0188 seconds (files took 0.40418 seconds to load)
4 examples, 0 failures
```

^ Our tests are still more than twice as fast as the original tests.

---

# The final code

---

``` ruby
class Estimator < ActiveRecord::Base
  has_many :customers

  def projection
    customers.inject(MinMax.zero) do |minmax, customer|
      minmax + customer.projection
    end
  end
end
```

---

``` ruby
class Customer < ActiveRecord::Base
  belongs_to :rate
  belongs_to :estimator

  def projection
    rate * revenue
  end
end
```

---

``` ruby
class Rate < ActiveRecord::Base
  def min
    self[:min] / 100.to_f
  end

  def max
    self[:max] / 100.to_f
  end

  def * other
    [
      min * other,
      max * other
    ]
  end
end
```

---

``` ruby
class MinMax
  attr_reader :min, :max

  def initialize(min, max)
    @min, @max = min, max
  end

  def + other
    new_min = min + other.min
    new_max = max + other.max
    self.class.new(new_min, new_max)
  end

  def self.zero
    new(0, 0)
  end
end
```

---

# Before

---

``` bash
    35.4: flog total
     5.9: flog/method average

    20.7: Estimator#projection                lib/estimator.rb:6
     4.1: Rate#min                         lib/rate.rb:4
```

---

# After

---

``` bash
    46.1: flog total
     3.8: flog/method average

     9.2: MinMax#+                         lib/min_max.rb:8
     7.5: Estimator#projection                lib/estimator.rb:7
     4.8: Rate#*                           lib/rate.rb:12
     4.4: main#none
     4.1: Rate#min                         lib/rate.rb:4
```

---

# So remember...

---

![](factory.jpg)
## Factories are bad

---

![](market.jpg)
## Use only organic, locally sourced data instead

---

# **That's all, folks!**
#### Eric Roberts — __@eroberts__