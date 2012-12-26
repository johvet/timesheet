# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project do
    user
    customer
    title "My Funny Project"
    comment "Something worth mentioning"
  end
end
