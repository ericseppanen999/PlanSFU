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
    # get the search parameters from the request
    query = search_params # or params.to_unsafe_h for testing
    puts "Query: #{query.inspect}"
    # extract the search parameters from the query, with default values if not present
    search_string = query[:searchstring].presence || ""
    search_in_props = query[:search_in_props].presence ||[ "title", "dept", "description", "instructors", "campuses" ]
    terms = query[:terms].presence || [ { year: query[:year], term: query[:term] } ]
    departments = query[:departments].presence || [ "any" ]
    levels = query[:levels].presence || [ "any" ]
    custom_sql = query[:SQL].presence
    taken_courses = query[:courses] || []
    # railer.logger.debug("Taken courses: #{taken_courses}")

    terms = terms.map { |t| t.to_h }

    if terms == [ { year: "any", term: "any" } ] or terms == [ { year: nil, term: nil } ]
      terms = []
    end

    # perform the search based on our parameters
    results = search_courses(search_string, search_in_props, terms, departments, levels, custom_sql, taken_courses)

    # save_user_search_history(search_string, term, year) # you may have to comment this out

    # return the search results as JSON
    Rails.logger.debug("Final search parameters: terms=#{terms}, departments=#{departments}, levels=#{levels}")
    render json: results
  end

  private



  def search_params
    # permit the parameters we want to use in the search, can be avoided for testing
    params.permit(:term, :year, :searchstring, :SQL, search_in_props: [], terms: [ :year, :term ], departments: [], levels: [], courses: [ :dept, :number, :term, :year ])
  end

  def search_courses(search_string, search_in_props, terms, departments, levels, custom_sql, taken_courses = [])
    sql_query = "SELECT * FROM courses WHERE 1=1"
    query_values = []

    # Ensure search_in_props is limited to valid properties
    allowed_props = [ "title", "dept", "description", "instructors", "campuses" ]
    search_in_props = search_in_props & allowed_props  # Intersection of allowed props and given props

    terms.to_unsafe_h if terms.is_a?(ActionController::Parameters)
    if search_string.present?
      search_conditions = search_in_props.map { |prop| "#{prop} LIKE ?" }.join(" OR ")
      query_values.concat(Array.new(search_in_props.length, "%#{search_string}%"))
      sql_query += " AND (#{search_conditions})"
    end

    # Handle departments array
    departments = Array(departments).reject { |dept| dept == "any" }
    unless departments.empty?
      department_conditions = "dept IN (#{departments.map { '?' }.join(', ')})"
      query_values.concat(departments)
      sql_query += " AND (#{department_conditions})"
    end

    # Handle levels array
    levels = Array(levels).reject { |level| level == "any" }
    unless levels.empty?
      level_conditions = levels.map { |level| "number LIKE '#{level[0]}%'" }.join(" OR ")
      sql_query += " AND (#{level_conditions})"
    end

    # Handle terms array: Skip if both year and term are "any"
    terms = Array(terms).reject { |term| term["year"] == "any" && term["term"] == "any" }
    unless terms.empty?
      term_conditions = terms.map { |t| "(term = ? AND year = ?)" }.join(" OR ")
      query_values.concat(terms.flat_map { |t| [ t["term"], t["year"] ] })
      sql_query += " AND (#{term_conditions})"
    end

    # Log the final SQL query for debugging
    Rails.logger.debug("SQL Query: #{sql_query}")
    Rails.logger.debug("Query Values: #{query_values.inspect}")
    Rails.logger.debug("Number of placeholders in SQL: #{sql_query.scan(/\?/).count}")
    Rails.logger.debug("Number of values passed: #{query_values.count}")

    # Execute the query
    results = Course.find_by_sql([ sql_query, *query_values ])

    # Return the results
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
