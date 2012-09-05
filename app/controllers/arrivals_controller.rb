class ArrivalsController < ApplicationController
  # GET /arrivals
  # GET /arrivals.json
  def index
    @arrivals = Arrival.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @arrivals }
    end
  end

  # GET /arrivals/1
  # GET /arrivals/1.json
  def show
    @arrival = Arrival.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @arrival }
    end
  end

  # GET /arrivals/new
  # GET /arrivals/new.json
  def new
    @arrival = Arrival.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @arrival }
    end
  end

  # GET /arrivals/1/edit
  def edit
    @arrival = Arrival.find(params[:id])
  end

  # POST /arrivals
  # POST /arrivals.json
  def create
    @arrival = Arrival.new(params[:arrival])

    respond_to do |format|
      if @arrival.save
        format.html { redirect_to @arrival, notice: 'Arrival was successfully created.' }
        format.json { render json: @arrival, status: :created, location: @arrival }
      else
        format.html { render action: "new" }
        format.json { render json: @arrival.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /arrivals/1
  # PUT /arrivals/1.json
  def update
    @arrival = Arrival.find(params[:id])

    respond_to do |format|
      if @arrival.update_attributes(params[:arrival])
        format.html { redirect_to @arrival, notice: 'Arrival was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @arrival.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /arrivals/1
  # DELETE /arrivals/1.json
  def destroy
    @arrival = Arrival.find(params[:id])
    @arrival.destroy

    respond_to do |format|
      format.html { redirect_to arrivals_url }
      format.json { head :no_content }
    end
  end
end
