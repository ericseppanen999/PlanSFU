require "groq"
require "json"

class PrerequisiteParser
  def initialize
    @api_key = ENV["GROQ_API_KEY"]
    @client = Groq::Client.new(api_key: @api_key)
  end

  def get_prereq_string(input_string)
    sleep(1)
    begin
      response = @client.chat(
        "Convert the following prerequisite sentence into a structured logical expression with comparison operators for grades. Follow these rules:

        Only include 'W_course >= C-' if 'One W course' is explicitly mentioned in the input.
        Ignore permissions (e.g., 'Permission of Instructor' or 'Permission of Department') or other non-course instructions.
        Include only course codes and GPA/CGPA requirements. Assume a minimum grade of C- unless specified otherwise.
        Use >= for grade requirements and replace 'and'/'or' with 'AND'/'OR'.
        Respond only with the resulting logical string, without any additional text. If no valid courses or GPA are provided, respond with an empty string or '#no_prereq_logic
        Be specific, don't forget about GPA requirements
        For example: Input: 'CMPT 225, MATH 154 with at least a B+, and a minimum CGPA of 2.50.'

        Example Output: CMPT 225 >= C- AND MATH 154 >= B+ AND CGPA >= 2.50

        Input: #{input_string}"


      )
      response["content"]
    rescue Faraday::TooManyRequestsError, Net::OpenTimeout, Net::ReadTimeout
      puts "rate limit exception"
      sleep(10)
      retry
    end
  end
end
