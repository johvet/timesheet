FactoryGirl.define do
  factory :user do
    email "john@example.com"
    password "a-secret"
    password_confirmation "a-secret"
  end
end
