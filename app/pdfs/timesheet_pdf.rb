require 'prawn/measurement_extensions'

class TimesheetPdf < Prawn::Document
  def initialize(user, date_filter, records)
    @user = user
    @date_filter = date_filter
    @records = records

    super(:left_margin => 15.mm, :top_margin => 20.mm, :info => {
      :Title => "My Report",
      :Author => "John Doe",
      :Subject => "This is important",
      :Keywords => "Something to know",
      :CreationDate => Time.zone.now,
      :Grok => "Get this!"
      })

    define_page_header

    font_size(11)

    add_overview
    add_activities

    add_detail

    add_page_numbering
  end

  def define_page_header
    repeat(:all) do
      bounding_box([0, bounds.top + 20.mm], :width => bounds.width, :height => 20.mm) do
        org_size = font_size
        font_size(20)
        move_down 15.mm - font.height
        text I18n.t('reports.timesheet.title'), :style => :bold
        self.line_width = 0.5
        stroke_color "cccccc"
        stroke_horizontal_rule
        font_size(org_size)
      end

      bounding_box([0, bounds.top + 20.mm], :width => bounds.width, :height => 20.mm) do
        org_size = font_size

        font_size(11)
        move_down 14.mm - font.height
        text I18n.l(Time.zone.now, format: :long), :align => :right
        font_size(org_size)
      end
    end
  end

  def add_overview
    move_down 6.mm

    text I18n.t('reports.timesheet.overview.title'), :size => 13, :style => :bold_italic
    move_down 3.mm


    totals = @records.sum(:duration, :group => "activities.chargeable")
    total = totals.values.inject(0) { |sum, v| sum + v }
    chargeable = totals["t"] || 0
    free = totals["f"] || 0

    data = [
      [I18n.t('reports.timesheet.overview.user'), @user.email],
      [I18n.t('reports.timesheet.overview.time_range'), @date_filter.map { |i| I18n.l(i, format: :long) }.join(' - ')],
      [I18n.t('reports.timesheet.overview.total_time'), total.to_time],
      [I18n.t('reports.timesheet.overview.chargeable'), chargeable.to_time],
      [I18n.t('reports.timesheet.overview.non_chargeable'), free.to_time]
    ]

    table(data, :cell_style => {:borders => [], :padding => [3, 3, 3, 0]}, :column_widths => {0  => 7.5.cm})
  end

  def add_activities
    move_down 6.mm
    text I18n.t('reports.timesheet.activities.title'), :size => 13, :style => :bold_italic
    move_down 3.mm

    data = []

    @records.sum(:duration, :group => "activities.name").each do |activity, duration|
      data << [activity, duration.to_time]
    end

    table(data, :cell_style => {:borders => [], :padding => [3, 3, 3, 0]}, :column_widths => {0 => 7.5.cm})
  end

  def add_detail
    move_down 6.mm
    text I18n.t('reports.timesheet.details.title'), :size => 13, :style => :bold_italic
    move_down 3.mm

    data = [%w(date activity comment chargeable duration).map { |i| I18n.t("reports.timesheet.details.#{i}")}]
    @records.group_by { |entry| entry.executed_on.to_s(:iso) }.each do |k, rows|
      subtotal = 0
      rows.each do |entry|
        data << [
          I18n.l(entry.executed_on, format: :short),
          entry.activity.name,
          entry.description,
          I18n.t(entry.activity.chargeable ? 'yes' : 'no'),
          entry.duration.to_time
        ]
        subtotal += entry.duration
      end
      data << [nil, nil, nil, nil, {:content => subtotal.to_time, :font_style => :bold}]
    end
    table(data, :cell_style => {:border_width => 0.1, :border_color => "cccccc", :padding => [3, 3, 3, 3]}, :header => true, :width => bounds.width,
      :column_widths => {0 => 20.mm, 1 => 30.mm, 3 => 20.mm, 4 => 25.mm}, :row_colors => ["ffffff", "ededed"]) do
      columns(-2..-1).align = :right
      row(0).font_style = :bold
      row(0).background_color = "eeeeee"
    end
  end

  def add_page_numbering
    options = {
      :at => [0, 0],
      :width => bounds.width,
      :align => :center,
      :page_filter => (1..7),
      :color => "999999",
      :size => 10
    }

    number_pages "#{I18n.t('reports.page')} <page> #{I18n.t('reports.page_of')} <total>", options
  end
end