require_relative "../config/environment"

class Customer < ActiveRecord::Base
  belongs_to :rate
end
