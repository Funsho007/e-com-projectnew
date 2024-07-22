class SpacecraftsController < ApplicationController
  def index
    @spacecrafts = Spacecraft.all
  end

  def show
    @spacecraft = Spacecraft.find(params[:id])
  end
end
