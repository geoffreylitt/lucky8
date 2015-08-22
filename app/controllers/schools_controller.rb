class SchoolsController < ApplicationController
  def index
    @schools = School.all
  end

  def show
    @school = School.find(school_params[:id])
  end
end
