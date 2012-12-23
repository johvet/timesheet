class Customer < ActiveRecord::Base
  belongs_to :user

  attr_accessible :comment, :name

  validates_uniqueness_of :name
end
