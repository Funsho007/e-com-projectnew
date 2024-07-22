class FilmsController < ApplicationController
  def index
    @films = Film.search(params[:search])
  end

  def show
    @film = Film.find(params[:id])
  end
end
