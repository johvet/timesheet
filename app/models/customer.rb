class Customer < ActiveRecord::Base
  belongs_to :user
  has_many :projects

  attr_accessible :comment, :name

  validates_presence_of :name
  validates_uniqueness_of :name
end
