class FilmsController < ApplicationController
  def index
    @directors = Film.select(:director).distinct.pluck(:director)
    @films = Film.search(params[:search])
    @films = @films.where(director: params[:director]) if params[:director].present?
  end

  def show
    @film = Film.find(params[:id])
  end
  
  def autocomplete
    term = params[:term].downcase
    films = Film.where('LOWER(title) LIKE ?', "%#{term}%").pluck(:title)
    render json: films
  end
end
