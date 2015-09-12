class SchoolsController < ApplicationController
  def index
    @schools = School.all

    schools_with_location = @schools.where.not(latitude: nil)
    gon.geocoded_hash = Gmaps4rails.build_markers(schools_with_location) do |school, marker|
      marker.lat school.latitude
      marker.lng school.longitude
      marker.title school.name
      marker.json({
        id: school.id,
        name: school.name,
        gradRate: school.four_yr_graduated
      })
    end
  end

  def show
    @school = School.find(params[:id])

    schools_with_location = School.where(id: @school.id).where.not(latitude: nil)
    @geocoded_hash = Gmaps4rails.build_markers(schools_with_location) do |school, marker|
      marker.lat school.latitude
      marker.lng school.longitude
    end
  end
end
