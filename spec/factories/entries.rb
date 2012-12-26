# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :entry do
    user
    project
    activity
    executed_on { Time.zone.today }
    ticker_start_at nil
    ticker_end_at nil
    description "MyText"
    duration 150

    factory :running_entry, :class => Entry do
      ticker_start_at { 7.minutes.ago }
    end
  end
end
