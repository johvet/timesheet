FactoryGirl.define do
  factory :user do
    email "john@example.com"
    password "secret"
    password_confirmation "secret"
  end
end
