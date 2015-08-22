class SchoolsController < ApplicationController
  def index
    @schools = School.all

    gon.geocoded_hash = Gmaps4rails.build_markers(@schools) do |school, marker|
      marker.lat school.latitude
      marker.lng school.longitude
    end

  end

  def show
    @school = School.find(params[:id])
  end
end
