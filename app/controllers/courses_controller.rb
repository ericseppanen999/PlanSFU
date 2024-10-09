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

    # extract the search parameters from the query, with default values if not present
    search_string = query[:searchstring].presence || ""
    search_in_props = query[:search_in_props].presence ||[ "title", "dept", "description", "instructors", "campuses" ]
    terms = query[:terms].presence || [ { year: query[:year], term: query[:term] } ]
    departments = query[:departments].presence || [ "any" ]
    levels = query[:levels].presence || [ "any" ]
    custom_sql = query[:SQL].presence
    taken_courses = query[:courses] || []
    # railer.logger.debug("Taken courses: #{taken_courses}")


    if departments == [ "any" ]
      departments = []
    end
    if levels == [ "any" ]
      levels = []
    end


    # perform the search based on our parameters
    results = search_courses(search_string, search_in_props, terms, departments, levels, custom_sql, taken_courses)

    # save_user_search_history(search_string, term, year) # you may have to comment this out

    # return the search results as JSON
    render json: results
  end

  private



  def search_params
    # permit the parameters we want to use in the search, can be avoided for testing
    params.permit(:term, :year, :searchstring, :SQL, search_in_props: [], terms: [ :year, :term ], departments: [], levels: [], courses: [ :dept, :number, :term, :year ])
  end



  def search_courses(search_string, search_in_props, terms, departments, levels, custom_sql, taken_courses = [])
    # building SQL query based on search parameters
    # returns: search results

    sql_query = "SELECT * FROM courses WHERE 1=1" # this looks weird but 1=1 is a trick to simplify the query building https://www.sql-easy.com/learn/why-use-where-11-in-sql-queries/
    query_values = [] # values to be passed to the query

    if search_string.present?
      # create SQL condition for search string
      search_conditions = search_in_props.map { |prop| "#{prop} LIKE ?" }.join(" OR ") # search_in_props is an array of columns to search in, so we search using LIKE for each col
      query_values.concat(Array.new(search_in_props.length, "%#{search_string}%")) # append the search string for each col
      sql_query += " AND (#{search_conditions})" # add conditions to our query
    end

    unless terms.empty?
      term_conditions = terms.map do |t|
        if t[:year] == "any" && t[:term] == "any"
          nil
        elsif t[:year] == "any"
          "(term = ?)"
        elsif t[:term] == "any"
          "(year = ?)"
        else
          "(term = ? AND year = ?)"
        end
      end.compact.join(" OR ")

      query_values.concat(terms.flat_map do |t|
        if t[:year] == "any" && t[:term] != "any"
          [ t[:term] ]
        elsif t[:term] == "any" && t[:year] != "any"
          [ t[:year] ]
        elsif t[:term] != "any" && t[:year] != "any"
          [ t[:term], t[:year] ]
        else
          []
        end
      end)

      sql_query += " AND (#{term_conditions})" unless term_conditions.empty?
    end

    if departments.present?
      # create SQL condition for departments
      departments = Array(departments) # make sure departments is an array (may not be necessary)
      department_conditions = "dept IN (#{departments.map { '?' }.join(', ')})" # sql condition that matches departments
      query_values.concat(departments)
      sql_query += " AND (#{department_conditions})" # add conditions to our query
    end

    if levels.present?
      # create SQL condition for levels
      levels = Array(levels) # again, make sure levels is an array although may not be necessary
      level_conditions = levels.map { |level| "number LIKE '#{level[0]}'" }.join(" OR ") # extract the first character of each level (1xx -> 1) and match
      sql_query += " AND (#{level_conditions})" # add conditions to our query
    end

    unless taken_courses.empty?
      # create SQL condition for taken courses
      taken_conditions = "NOT (dept IN (#{taken_courses.map { '?' }.join(', ')}) AND number IN (#{taken_courses.map { '?' }.join(', ')}))" # single out our courses
      query_values.concat(taken_courses.map { |course| course[:dept] })
      query_values.concat(taken_courses.map { |course| course[:number] })
      query_values.concat(taken_courses.map { |course| course[:term] })
      query_values.concat(taken_courses.map { |course| course[:year] })
      sql_query += " AND #{taken_conditions}" # add conditions to our query
    end

    if custom_sql.present?
      # add custom SQL condition
      sql_query += " AND (#{custom_sql})"
    end

    # execute the query
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
