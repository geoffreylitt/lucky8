class SchoolsController < ApplicationController
  def index
    @show = params[:show]
    @schools = School.all

    schools_with_location = @schools.where.not(latitude: nil)
    @geocoded_hash = Gmaps4rails.build_markers(schools_with_location) do |school, marker|
      marker.lat school.latitude
      marker.lng school.longitude
    end

    render :list
  end

  def show
    @school = School.find(params[:id])

    schools_with_location = School.where(id: @school.id).where.not(latitude: nil)
    @geocoded_hash = Gmaps4rails.build_markers(schools_with_location) do |school, marker|
      marker.lat school.latitude
      marker.lng school.longitude
    end
  end

  def map
    @schools = School.all

    schools_with_location = @schools.where.not(latitude: nil)
    @geocoded_hash = Gmaps4rails.
      build_markers(schools_with_location) do |school, marker|
      marker.lat school.latitude
      marker.lng school.longitude
    end
  end

  def list
    @schools = School.all
  end
end
