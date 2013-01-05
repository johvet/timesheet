module ReportsHelper
  def period_filter_options
    result = []
    # First the obvious ones
    %w(all today yesterday this_week last_week this_month last_month last_but_one_month last_but_two_months).each do |item|
      result << [I18n.t("reports.filter.period.#{item}"), item]
    end

    # Next add this and the last year's months
    (1.downto 0).each do |yi|
      yid = yi == 1 ? 'last_year' : 'this_year'
      (1..12).each do |month|
        mp = month.to_s.rjust(2, '0')
        result << ["#{mp} / #{yi.years.ago.year}", "#{yid}_#{mp}"]
      end
    end

    result
  end

  def period_filter_dates(key)
    result = nil

    if key.start_with?('this_year_')
      matches = key.match(/^this_year_(\d+)$/)
      month = Date.new(0.years.ago.year, matches[1].to_i, 1)
      [month.beginning_of_month.to_date, month.end_of_month.to_date]

    elsif key.start_with?('last_year_')
      matches = key.match(/last_year_(\d+)$/)
      month = Date.new(1.years.ago.year, matches[1].to_i, 1)
      [month.beginning_of_month.to_date, month.end_of_month.to_date]

    else
      case key
      when 'all'
        []
      when 'today'
        [Time.zone.today]
      when 'yesterday'
        [1.day.ago.to_date]
      when 'this_week'
        [Time.zone.today.beginning_of_week.to_date, Time.zone.today.end_of_week.to_date]
      when 'last_week'
        [1.week.ago.beginning_of_week.to_date, 1.week.ago.end_of_week.to_date]
      when 'this_month'
        [Time.zone.today.beginning_of_month.to_date, Time.zone.today.end_of_month.to_date]
      when 'last_month'
        [1.month.ago.beginning_of_month.to_date, 1.month.ago.end_of_month.to_date]
      when 'last_but_one_month'
        [2.month.ago.beginning_of_month.to_date, 2.month.ago.end_of_month.to_date]
      when 'last_but_two_months'
        [3.month.ago.beginning_of_month.to_date, 3.month.ago.end_of_month.to_date]
      end
    end
  end
end
