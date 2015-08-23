class SchoolsController < ApplicationController
  def index
    @schools = School.all

    @schools_with_location = @schools.where.not(latitude: nil)

    gon.geocoded_hash = Gmaps4rails.build_markers(@schools) do |school, marker|
      marker.lat school.latitude
      marker.lng school.longitude
    end

  end

  def show
    @school = School.find(params[:id])
  end
end
