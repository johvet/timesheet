class EntriesController < AuthenticatedController
  # GET /entries
  # GET /entries.json
  def index
    @date = params[:date].to_date rescue Time.zone.today
    @entries = current_user.entries.where(:executed_on => @date)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @entries }
    end
  end

  # GET /entries/1
  # GET /entries/1.json
  def show
    @entry = current_user.entries.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @entry }
    end
  end

  # GET /entries/new
  # GET /entries/new.json
  def new
    date = params[:when].to_date rescue Time.zone.today
    @entry = current_user.entries.new(:executed_on => date)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @entry }
    end
  end

  # GET /entries/1/edit
  def edit
    @entry = current_user.entries.find(params[:id])
  end

  # POST /entries
  # POST /entries.json
  def create
    @entry = current_user.entries.new(params[:entry])

    respond_to do |format|
      if @entry.save
        format.html { redirect_to @entry, notice: 'Entry was successfully created.' }
        format.json { render json: @entry, status: :created, location: @entry }
      else
        format.html { render action: "new" }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /entries/1
  # PUT /entries/1.json
  def update
    @entry = current_user.entries.find(params[:id])

    respond_to do |format|
      if @entry.update_attributes(params[:entry])
        format.html { redirect_to @entry, notice: 'Entry was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entries/1
  # DELETE /entries/1.json
  def destroy
    @entry = current_user.entries.find(params[:id])
    @entry.destroy

    respond_to do |format|
      format.html { redirect_to entries_url }
      format.json { head :no_content }
    end
  end

  def start
    @entry = current_user.entries.find(params[:id])
    @entry.ticker_start_at = Time.zone.now

    respond_to do |format|
      if @entry.save
        format.html { redirect_to @entry, notice: 'Entry was successfully started'}
        format.json { head :no_content}
      else
        format.html { render action: "edit"}
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  def stop
    @entry = current_user.entries.find(params[:id])
    @entry.ticker_end_at = Time.zone.now

    respond_to do |format|
      if @entry.save
        format.html { redirect_to @entry, notice: 'Entry was successfully halted'}
        format.json { head :no_content}
      else
        format.html { render action: "edit"}
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end
end
