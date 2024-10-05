class CoursesController < ApplicationController
  def search_page
    # render the search page view
  end
  def search
    query = search_params

    term = query[:term]
    year = query[:year]
    search_string = query[:searchstring]
    taken_courses = query[:courses] || []

    results = search_courses(search_string, term, year, taken_courses)
    render json: results
  end

  private

  def search_params
    params.permit(:term, :year, :searchstring, courses: [ :dept, :number, :term, :year ])
  end

  def search_courses(search_string, term, year, taken_courses)
    results = Course.where("term = ? AND year = ? AND (title LIKE ? COLLATE NOCASE OR description LIKE ? COLLATE NOCASE OR short_description LIKE ? COLLATE NOCASE)", term, year, "%#{search_string}%", "%#{search_string}%", "%#{search_string}%")

    unless taken_courses.empty?
      results = results.where.not(dept: taken_courses.map { |course| course[:dept] }, number: taken_courses.map { |course| course[:number] }, term: taken_courses.map { |course| course[:term] }, year: taken_courses.map { |course| course[:year] })
    end
    results
  end

  def search
    query = search_params

    term = query[:term]
    year = query[:year]
    search_string = query[:searchstring]
    taken_courses = query[:courses] || []

    # Perform the search
    results = search_courses(search_string, term, year, taken_courses)

    # Save the search history for the current user
    save_user_search_history(search_string, term, year)

    # Return the search results as JSON
    render json: results
  end

  private

  def set_current_user
    @current_user = current_user # Assuming `current_user` is set by CAS authentication
  end

  def search_params
    params.permit(:term, :year, :searchstring, courses: [:dept, :number, :term, :year])
  end

  def search_courses(search_string, term, year, taken_courses)
    results = Course.where(
      "term = ? AND year = ? AND (title LIKE ? OR description LIKE ? OR short_description LIKE ?)",
      term, year, "%#{search_string}%", "%#{search_string}%", "%#{search_string}%"
    )

    # Exclude taken courses from the results
    unless taken_courses.empty?
      results = results.where.not(
        dept: taken_courses.map { |course| course[:dept] },
        number: taken_courses.map { |course| course[:number] },
        term: taken_courses.map { |course| course[:term] },
        year: taken_courses.map { |course| course[:year] }
      )
    end

    results
  end

  def save_user_search_history(search_string, term, year)
    # Save search history for the current user
    if @current_user
      UserSearchHistory.create(
        user_id: @current_user.id,
        search_string: search_string,
        term: term,
        year: year
      )
    end
  end
end