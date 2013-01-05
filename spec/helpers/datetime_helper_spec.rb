require 'spec_helper'

describe DateTimeHelper do
  it "should generate a proper text representation" do
    [
      {in: Date.today, out: I18n.t('date.today')},
      {in: Date.yesterday, out: I18n.t('date.yesterday')},
      {in: 2.days.ago, out: I18n.t('date.day_before_yesterday')},
      {in: Date.tomorrow, out: I18n.t('date.tomorrow')},
      {in: 2.days.from_now, out: I18n.t('date.day_after_tomorrow')},
      {in: Date.new(2010, 3, 15), out: I18n.l(Date.new(2010, 3, 15), format: :long) }
      ].each do |item|
        date_in_words(item[:in]).should eql(item[:out])
      end
  end
end