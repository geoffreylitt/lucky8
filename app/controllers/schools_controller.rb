class SchoolsController < ApplicationController
  def index
    @starred = params[:starred] == "true"
    @tag = Tag.find(params[:tag_id].to_i) if params[:tag_id]

    if @starred
      @schools = current_user.schools
    elsif @tag
      @schools = @tag.schools
    else
      @schools = School.all
    end

    schools_with_location = @schools.where.not(latitude: nil)
    gon.geocoded_hash = Gmaps4rails.build_markers(schools_with_location) do |school, marker|
      marker.lat school.latitude
      marker.lng school.longitude
      marker.title school.name
      marker.json({
        id: school.id,
        name: school.name,
        about: school.about,
        tags: school.tags.pluck(:id, :name)
      })
    end
  end

  def show
    @school = School.find(params[:id])

    schools_with_location = School.where(id: @school.id).where.not(latitude: nil)
    gon.geocoded_hash = Gmaps4rails.build_markers(schools_with_location) do |school, marker|
      marker.lat school.latitude
      marker.lng school.longitude
    end
  end

  def geocoded_hash
    gon.geocoded_hash
  end
  helper_method :geocoded_hash

  def toggle_save
    @school = School.find(params[:id])
    if current_user
      if current_user.schools.include? @school
        current_user.schools.delete @school
        flash[:notice] = "#{@school.name} was removed from your Lucky 8."
      else
        current_user.schools << @school
        flash[:notice] = "#{@school.name} was added to your Lucky 8."
      end

      redirect_to @school
    else
      flash[:alert] = "You'll need to sign in to save that school!"
      redirect_to new_user_session_path
    end
  end
end
