require 'spec_helper'

describe ReportsHelper do
  it "#period_filter_options" do
    stock = [
        ['All', 'all'],
        ['Today', 'today'],
        ['Yesterday', 'yesterday'],
        ['This Week', 'this_week'],
        ['Last Week', 'last_week'],
        ['This Month', 'this_month'],
        ['Last Month', 'last_month'],
        ['Last But One Month', 'last_but_one_month'],
        ['Last But Two Months', 'last_but_two_months'],
    ]

    (1.downto 0).each do |yi|
      yid = yi == 1 ? 'last_year' : 'this_year'
      (1..12).each do |month|
        mp = month.to_s.rjust(2, '0')
        stock << ["#{mp} / #{yi.years.ago.year}", "#{yid}_#{mp}"]
      end
    end
    period_filter_options.should eq(stock)
  end

  it "#period_filter_dates" do
    defs = {
      'all' => [],
      'today' => [Time.zone.today],
      'yesterday' => [1.day.ago.to_date],
      'this_week' => [Date.today.beginning_of_week.to_date, Date.today.end_of_week.to_date],
      'last_week' => [1.week.ago.beginning_of_week.to_date, 1.week.ago.end_of_week.to_date],
      'this_month' => [Time.zone.today.beginning_of_month.to_date, Time.zone.today.end_of_month.to_date],
      'last_month' => [1.month.ago.beginning_of_month.to_date, 1.month.ago.end_of_month.to_date],
      'last_but_one_month' => [2.month.ago.beginning_of_month.to_date, 2.month.ago.end_of_month.to_date],
      'last_but_two_months' => [3.month.ago.beginning_of_month.to_date, 3.month.ago.end_of_month.to_date],
      'this_year_01' => [Date.new(0.years.ago.year, 1, 1).beginning_of_month.to_date, Date.new(0.years.ago.year, 1, 1).end_of_month.to_date],
      'last_year_12' => [Date.new(1.years.ago.year, 12, 1).beginning_of_month.to_date, Date.new(1.years.ago.year, 12, 1).end_of_month.to_date]
    }.each do |key, res|
      period_filter_dates(key).map(&:to_s).join().should eq(res.map(&:to_s).join())
    end
  end
end