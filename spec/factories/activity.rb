FactoryGirl.define do
  factory :activity do
    user
    name    "Do Something"
    chargeable true

    factory :unchargeable_activity, :class => Activity do
      name "Bug Fixing"
      chargeable false
    end
  end
end