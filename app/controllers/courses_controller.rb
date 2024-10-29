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
    # retrieve the query parameters from the frontend
    query = search_params # or params.to_unsafe_h for testing

    # extract the search parameters from the query, with default values.
    search_string = query[:searchstring].presence || ""
    search_in_props = query[:search_in_props].presence ||[ "title", "dept", "description", "instructors", "campuses" ]
    terms = query[:terms].presence || [ { year: query[:year], term: query[:term] } ]
    departments = query[:departments].presence || [ "any" ]
    levels = query[:levels].presence || [ "any" ]
    custom_sql = query[:SQL].presence
    taken_courses = query[:courses] || []

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

    # search for courses based on the search parameters
    results = search_courses(search_string, search_in_props, terms, departments, levels, custom_sql, taken_courses)

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
    params.permit(:term, :year, :searchstring, :SQL, search_in_props: [], terms: [ :year, :term ], departments: [], levels: [], courses: [ :dept, :number, :term, :year ])
  end


  def search_courses(search_string, search_in_props, terms, departments, levels, custom_sql, taken_courses = [])
    # build the SQL query based on the search parameters
    # retirms the search results

    sql_query = "SELECT * FROM courses WHERE 1=1" # default query
    query_values = [] # empty query values array initialization

    # filter out invalid search props using intersection
    allowed_props = [ "title", "dept", "description", "instructors", "campuses" ]
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

    # debug: print the custom SQL query
    Rails.logger.debug("SQL Query: #{sql_query}")
    Rails.logger.debug("Query Values: #{query_values.inspect}")
    Rails.logger.debug("Number of placeholders in SQL: #{sql_query.scan(/\?/).count}")
    Rails.logger.debug("Number of values passed: #{query_values.count}")

    # execute the SQL query to get the search results
    results = Course.find_by_sql([ sql_query, *query_values ])


    # return results
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
