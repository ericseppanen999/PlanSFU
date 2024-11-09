## Courses Controller ##
# This controller is responsible for handling the search requests from the frontend.
# It receives the search parameters from the frontend, builds a SQL query based on the parameters, and executes the query to get the search results.
# The search results are then returned to the frontend as JSON.

class CoursesController < ApplicationController
  # you may have to comment this out
  # before_action :set_current_user, only: [ :search ]

  def search_page
    # render the search page view
  end

  def search
    # Rails.logger.debug("Received parameters: #{params.inspect}")
    # retrieve the query parameters from the frontend

    query = search_params # or params.to_unsafe_h for testing
    # extract the search parameters from the query, with default values.

    use_courses = query[:use_courses].presence || false
    user_courses = query[:courses].presence || []
    session_token = query[:session_token].presence || nil
    search_string = query[:searchstring].presence || ""
    search_in_props = query[:search_in_props].presence ||[ "title", "term", "description", "instructors", "year" ]
    terms = query[:terms].presence || [ { year: query[:year], term: query[:term] } ]
    departments = query[:departments].presence || [ "any" ]
    levels = query[:levels].presence || [ "any" ]
    custom_sql = query[:SQL].presence
    logger.debug("use_courses: #{use_courses}")
    # convert the terms to an array of hashes // not sure if this is 100% correct or necessary
    terms = terms.map { |t| t.to_h }

    # handle the case where the user selects "any" for terms or departments
    if terms == [ { year: "any", term: "any" } ] or terms == [ { year: nil, term: nil } ]
      terms = []
    end

    # handle the case where the user selects "any" for departments or levels
    if departments == [ "any" ]
      departments = [] # empty array because we don't need to filter by department
    end

    # handle the case where the user selects "any" for levels
    if levels == [ "any" ]
      levels = [] # empty array because we don't need to filter by level
    end
    if query[:courses].is_a?(ActionController::Parameters)
      user_courses = query[:courses].values.map(&:to_h)
    else
      user_courses = []
    end
    use_courses = ActiveModel::Type::Boolean.new.cast(query[:use_courses])

    if session_token
      user = User.find_by(session_token: session_token)
      user_courses = user.taken_courses if user
    end

    if use_courses && user_courses.any?
      user_courses = user_courses.map do |course|
        db_course = Course.find_by(unique_identifier: course[:unique_identifier])
        {
          "dept" => "#{db_course.dept}",
          "number" => "#{db_course.number}",
          "grade" => course[:grade] || "B"
        } if db_course
      end.compact
    else
      user_courses = []
    end

    # search for courses based on the search parameters
    results = search_courses(search_string, search_in_props, terms, departments, levels, custom_sql, use_courses, user_courses, session_token)

    # save_user_search_history(search_string, term, year) # you may have to comment this out

    # return the search results to the frontend as JSON
    render json: results
  end

  
  def check_eligibility
    user = User.find_by(cas_user_id: params[:cas_user_id])
    course = Course.find_by(dept: params[:dept], number: params[:number])

    if user && course
      is_eligible = course.user_eligible?(user)
      render json: { eligible: is_eligible }
    else
      if !user
        render json: { error: "user not found" }, status: :not_found
      end
      if !course
        render json: { error: "course not found" }, status: :not_found
      end
    end
  end
  private


  def search_params
    # permit the search parameters from the frontend // or params.to_unsafe_h for testing
    # logger.debug("params: #{params.inspect}")
    params.permit(:term, :year, :searchstring, :use_courses, :session_token, :SQL, search_in_props: [], terms: [ :year, :term ], departments: [], levels: [], courses: [ :unique_identifier, :grade ])
  end



  def search_courses(search_string, search_in_props, terms, departments, levels, custom_sql, use_courses, user_courses = [], session_token = nil)
    # build the SQL query based on the search parameters
    # retirms the search results
    # logger.debug("use_courses: #{use_courses}")
    sql_query = "SELECT unique_identifier, dept, number, term, year, title, description, requisite_description, prereq_logic, credits, instructors, campuses, delivery_methods, sections FROM courses WHERE 1=1"
    query_values = [] # empty query values array initialization

    # filter out invalid search props using intersection
    allowed_props = [ "title", "year", "description", "instructors", "term" ]
    search_in_props = search_in_props & allowed_props


    # terms.to_unsafe_h if terms.is_a?(ActionController::Parameters) // for testing

    if search_string.present?
      # build the search conditions based on the search string and search properties
      search_conditions = search_in_props.map { |prop| "#{prop} LIKE ?" }.join(" OR ") # build the search conditions
      query_values.concat(Array.new(search_in_props.length, "%#{search_string}%")) # add the search string to the query values
      sql_query += " AND (#{search_conditions})" # append the search conditions to the SQL query
    end

    unless departments.empty?
      # build the department conditions based on the departments
      department_conditions = "dept IN (#{departments.map { '?' }.join(', ')})" # build the department conditions
      query_values.concat(departments) # add the departments to the query values
      sql_query += " AND (#{department_conditions})" # append the department conditions to the SQL query
    end

    unless levels.empty?
      # build the level conditions based on the levels
      level_conditions = levels.map { |level| "number LIKE ?" }.join(" OR ") # build the level conditions
      query_values.concat(levels.map { |level| "#{level[0]}%" }) # add the levels to the query values
      sql_query += " AND (#{level_conditions})" # append the level conditions to the SQL query
    end

    terms = Array(terms).reject { |term| term["year"] == "any" && term["term"] == "any" } # remove any terms with "any" year and term
    unless terms.empty?
      # build the term conditions based on the terms
      term_conditions = terms.map { |t| "(term = ? AND year = ?)" }.join(" OR ") # build the term conditions
      query_values.concat(terms.flat_map { |t| [ t["term"], t["year"] ] }) # add the terms to the query values
      sql_query += " AND (#{term_conditions})" # append the term conditions to the SQL query
    end

    ## IMPLEMENT HERE ##
    # taken courses, custom SQL query
    Rails.logger.debug(user_courses)
    if use_courses && user_courses.any?
      exclusion_clauses = user_courses.map { |course| "(dept = ? AND number = ?)" }.join(" OR ")
      query_values.concat(user_courses.flat_map { |course| [ course["dept"], course["number"] ] })
      sql_query += " AND NOT (#{exclusion_clauses})"
    end

    sql_query += " LIMIT 50"
    Rails.logger.debug("SQL Query: #{sql_query}")
    Rails.logger.debug("Query Values: #{query_values.inspect}")

    raw_results = Course.find_by_sql([ sql_query, *query_values ])

    if use_courses && user_courses.present?
      raw_results.select! do |course|
        course.prerequisites_satisfied?(user_courses, course.prereq_logic)
      end
    end
    raw_results
  end
end
