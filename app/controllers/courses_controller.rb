# This controller handles all search requests

class CoursesController < ApplicationController
  def search
    searchquery = params[:searchquery]
    puts searchquery
    @courses = Course.all
    data = { message: searchquery, status: 200 }
    render json: data
  end
end
