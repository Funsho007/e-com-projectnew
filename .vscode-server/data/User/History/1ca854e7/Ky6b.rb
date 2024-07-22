class SpacecraftsController < ApplicationController
  before_action :set_spacecraft, only: %i[ show edit update destroy ]

  # GET /spacecrafts or /spacecrafts.json
  def index
    @spacecrafts = Spacecraft.page(params[:page]).per(15)
  end

  # GET /spacecrafts/1 or /spacecrafts/1.json
  def show
  end

  # GET /spacecrafts/new
  def new
    @spacecraft = Spacecraft.new
  end

  # GET /spacecrafts/1/edit
  def edit
  end

  # POST /spacecrafts or /spacecrafts.json
  def create
    @spacecraft = Spacecraft.new(spacecraft_params)

    respond_to do |format|
      if @spacecraft.save
        format.html { redirect_to spacecraft_url(@spacecraft), notice: "Spacecraft was successfully created." }
        format.json { render :show, status: :created, location: @spacecraft }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @spacecraft.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /spacecrafts/1 or /spacecrafts/1.json
  def update
    respond_to do |format|
      if @spacecraft.update(spacecraft_params)
        format.html { redirect_to spacecraft_url(@spacecraft), notice: "Spacecraft was successfully updated." }
        format.json { render :show, status: :ok, location: @spacecraft }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @spacecraft.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /spacecrafts/1 or /spacecrafts/1.json
  def destroy
    @spacecraft.destroy

    respond_to do |format|
      format.html { redirect_to spacecrafts_url, notice: "Spacecraft was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_spacecraft
      @spacecraft = Spacecraft.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def spacecraft_params
      params.require(:spacecraft).permit(:name, :model, :manufacturer)
    end
end
