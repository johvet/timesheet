class ReportsController < AuthenticatedController
  def index
    @filter = {}
    @customers = current_user.customers.order(:name)
    @projects = current_user.projects.order(:title)

    if is_filtered?
      if params[:filter_customer].present?
        @results = current_user.customers.find(params[:filter_customer]).entries.includes(:project, :activity).scoped
      else
        @results = current_user.entries.includes(:project, :activity).scoped
      end

      if params[:filter_project].present?
        @results = @results.where(:project_id => params[:filter_project])
      end

      if params[:filter_chargeable].present?
        @results = @results.where("activities.chargeable" => params[:filter_chargeable] == 'yes')
      end

      if params[:filter_period].present?
        date_filter = view_context.period_filter_dates(params[:filter_period])
        if date_filter.length == 1
          @results = @results.where(:executed_on => date_filter[0])
        elsif date_filter.length == 2
          @results = @results.where(:executed_on => date_filter[0]..date_filter[1])
        end
      end

      @results = @results.group_by { |entry| entry.executed_on.to_s(:iso) }
    end

    respond_to do |format|
      format.html
      format.js
      format.pdf do
        pdf = TimesheetPdf.new
        send_data pdf.render, filename: "stundenzettel.pdf",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end

  private

  def is_filtered?
    result = false
    %w(period customer project chargeable).each do |item|
      result ||= params.include?("filter_#{item}".to_sym)
    end
    result
  end


end
