class Activity < ActiveRecord::Base
  attr_accessible :chargeable, :name, :user_id

  belongs_to :user
  has_many :entries

  validates_presence_of :user, :name
  validates_uniqueness_of :name
end
