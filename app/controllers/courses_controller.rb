class CoursesController < ApplicationController
  # you may have to comment this out
  # before_action :set_current_user, only: [ :search ]

  def search_page
    # render the search page view
  end

  def search
    query = search_params

    term = query[:term].presence || "fall"
    year = query[:year].presence || "2024"
    search_string = query[:searchstring].presence || ""
    taken_courses = query[:courses] || []

    results = search_courses(search_string, term, year, taken_courses)

    # save_user_search_history(search_string, term, year) # you may have to comment this out

    # Return the search results as JSON
    render json: results
  end

  private

  def search_params
    params.permit(:term, :year, :searchstring, courses: [ :dept, :number, :term, :year ])
  end


  def search_courses(search_string, term, year, taken_courses)
    results = Course.where(
      "term = ? AND year = ? AND (dept LIKE ? COLLATE NOCASE OR title LIKE ? COLLATE NOCASE OR description LIKE ? COLLATE NOCASE OR short_description LIKE ? COLLATE NOCASE OR EXISTS (SELECT 1 FROM json_each(instructors) WHERE value LIKE ? COLLATE NOCASE) OR EXISTS(SELECT 1 FROM json_each(campuses) WHERE value LIKE ? COLLATE NOCASE) OR EXISTS (SELECT 1 FROM json_each(delivery_methods) WHERE value LIKE ? COLLATE NOCASE))",
      term, year, "%#{search_string}%", "%#{search_string}%", "%#{search_string}%", "%#{search_string}%", "%#{search_string}%", "%#{search_string}%", "%#{search_string}%"
    )
    unless taken_courses.empty?
      results = results.where.not(dept: taken_courses.map { |course| course[:dept] }, number: taken_courses.map { |course| course[:number] }, term: taken_courses.map { |course| course[:term] }, year: taken_courses.map { |course| course[:year] })
    end

    results
  end
=begin
  def save_user_search_history(search_string, term, year)
    if @current_user
      UserSearchHistory.create(
        user_id: @current_user.id,
        search_string: search_string,
        term: term,
        year: year
      )
    end
  end
  def set_current_user
    @current_user = current_user # Assuming `current_user` is set by CAS authentication
  end
=end
end
