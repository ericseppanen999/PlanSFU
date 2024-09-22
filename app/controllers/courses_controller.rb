# This controller handles all search requests

class CoursesController < ApplicationController
  def search
    searchquery = params[:searchquery]
    puts searchquery
    @courses = Course.all
    #@courses = Course.where(dept: params[:dept])
    data = { message: @courses, status: 200 }
    render json: data
  end
end
