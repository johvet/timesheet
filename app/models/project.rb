class Project < ActiveRecord::Base
  attr_accessible :comment, :customer_id, :title

  belongs_to :customer
  belongs_to :user

  has_many :entries

  validates_presence_of :title, :customer, :user
  validates_uniqueness_of :title

  before_validation :ensure_user_is_set

  private

  def ensure_user_is_set
    self.user = self.customer.present? ? self.customer.user : nil
  end
end
