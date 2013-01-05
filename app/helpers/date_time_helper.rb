module DateTimeHelper
  def date_in_words(value)
    date = value.to_date
    case date
    when Date.today
      I18n.t('date.today')
    when Date.yesterday
      I18n.t('date.yesterday')
    when 2.days.ago.to_date
      I18n.t('date.day_before_yesterday')
    when Date.tomorrow
      I18n.t('date.tomorrow')
    when 2.days.from_now.to_date
      I18n.t('date.day_after_tomorrow')
    else
      I18n.l(date, format: :long)
    end
  end
end
