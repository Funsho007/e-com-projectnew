class PeopleController < ApplicationController
  before_action :set_person, only: %i[ show edit update destroy ]


  # GET /people or /people.json
  def index
    if params[:species_id]
      @species = Species.find(params[:species_id])
      @people = @species.people.page(params[:page]).per(15)
    elsif params[:planet_id]
      @planet = Planet.find(params[:planet_id])
      @people = @planet.people.page(params[:page]).per(15)
      @association_name = @planet.name
    elsif params[:vehicle_id]
      @vehicle = Vehicle.find(params[:vehicle_id])
      @people = @vehicle.people.page(params[:page]).per(15)
      @association_name = @vehicle.name
    elsif params[:starship_id]
      @starship = Starship.find(params[:starship_id])
      @people = @starship.people.page(params[:page]).per(15)
      @association_name = @starship.name
    elsif params[:film_id]
      @film = Film.find(params[:film_id])
      @people = @film.people.page(params[:page]).per(15)
      @association_name = @film.title
    else
      @people = Person.page(params[:page]).per(15)
    end
  end

  # GET /people/1 or /people/1.json
  def show
    @person = Person.find(params[:id])
    @species = @person.species
    @planet = @person.planet
    @species_people = @species ? @species.people : []
    @planet_people = @planet ? @planet.people : []
    @starships = @perso
    @vehicles = @person.vehicles
    @films = @person.films
  end


  def show_association
    @person = Person.find(params[:id])
    association = params[:association]

    case association
    when 'starships'
      @starships = @person.starships
    when 'films'
      @films = @person.films
    when 'vehicles'
      @vehicles = @person.vehicles
    else
      redirect_to person_path(@person)
      return
    end

    render 'show_association'
  end

  def search
    if params[:name].present? && params[:species_id].present?
      @species = Species.find(params[:species_id])
      @people = @species.people.where('people.name LIKE ?', "%#{params[:name]}%")
    elsif params[:name].present?
      @people = Person.joins(:species).where('people.name LIKE ?', "%#{params[:name]}%")
      @species = nil
    elsif params[:species_id].present?
      @species = Species.find(params[:species_id])
      @people = @species.people
    else
      @people = Person.all
      @species = nil
    end

    @people = @people.page(params[:page]).per(15)

  end






  # GET /people/new
  def new
    @person = Person.new
  end

  # GET /people/1/edit
  def edit
    @person = Person.find(params[:id])
  end

  # POST /people or /people.json
  def create
    @person = Person.new(person_params)

    respond_to do |format|
      if @person.save
        format.html { redirect_to person_url(@person), notice: "Person was successfully created." }
        format.json { render :show, status: :created, location: @person }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /people/1 or /people/1.json
  def update
    respond_to do |format|
      if @person.update(person_params)
        format.html { redirect_to person_url(@person), notice: "Person was successfully updated." }
        format.json { render :show, status: :ok, location: @person }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1 or /people/1.json
  def destroy
    @person.destroy

    respond_to do |format|
      format.html { redirect_to people_url, notice: "Person was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def person_params
      params.require(:person).permit(:name, :height, :mass, :hair_color, :skin_color, :eye_color, :birth_year, :gender)
    end
end
