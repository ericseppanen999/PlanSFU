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
            "Convert the following prerequisite sentence into a structured logical expression using comparison operators for course grades, GPA, CGPA, and credit requirements. Follow these strict rules:

            - **Course Codes and Grades**:
                - Include only course codes.
                - Assume a minimum grade of 'C-' for each course unless a higher grade is specified.
                - Format as '[COURSE CODE] >= [GRADE]'.

            - **Credit Requirements**:
                - Convert statements like 'minimum of 45 credits' to 'CREDITS >= [number]'.

            - **GPA/CGPA Requirements**:
                - Include GPA or CGPA requirements as 'GPA >= [value]' or 'CGPA >= [value]'.

            - **'One W course' Requirement**:
                - Include 'W_course >= C-' only if 'One W course' is explicitly mentioned.

            - **Logical Operators**:
                - Use 'AND' and 'OR' (uppercase) for all logical connections.
                - If 'or' connects course options, apply 'OR' between them.

            - **Exclusions**:
                - Ignore permissions (e.g., 'Permission of Instructor') and any non-course-specific instructions.
                - Do not include equivalency statements; focus only on the mentioned course codes.
                - Do not include any high school course requirements, for example, 'BC MATH 12', 'PRE CALCULUS 12'.
                - Ignore recommendations and co-requisites.

            - **Output Format**:
                - Return only the logical expression as a string, nothing else.
                - If the input is unparseable, contains no valid requirements, or is explicitly 'None', return '#no_prereq_logic'.
                - Ensure proper logical grouping and operator precedence. Don't forget brackets.

            **Examples**:

            - **Input**: 'CMPT 225, MATH 154 with at least a B+, and a minimum CGPA of 2.50.'
                - **Output**: '(CMPT 225 >= C- AND MATH 154 >= B+ AND CGPA >= 2.50)'

            - **Input**: 'Minimum of 60 credits, CMPT 125, and a minimum GPA of 2.75'
                - **Output**: '(CREDITS >= 60 AND CMPT 125 >= C- AND GPA >= 2.75)'

            - **Input**: 'One W course, CMPT 276 with at least a B'
                - **Output**: '(W_course >= C- AND CMPT 276 >= B)'

            - **Input**: 'Minimum of 45 credits and a minimum CGPA of 3.0'
                - **Output**: '(CREDITS >= 45 AND CGPA >= 3.0)'

            - **Input**: 'None'
                - **Output**: '#no_prereq_logic'

            - **Input**: 'Permission of Instructor, CMPT 150'
                - **Output**: '(CMPT 150 >= C-)'

            - **Input**: 'Must have completed 30 credits and MATH 100 with a minimum grade of A-'
                - **Output**: '(CREDITS >= 30 AND MATH 100 >= A-)'

            - **Input**: 'BC MATH 12 or (MATH 100 OR MATH 150 OR MATH 151 OR MATH 154 OR MATH 157) with a minimum grade of C-'
                - **Output**: 'MATH 100 >= C- OR MATH 150 >= C- OR MATH 151 >= C- OR MATH 154 >= C- OR MATH 157 >= C-'

            RESPOND IN ONLY ONE LINE, DO NOT INCLUDE ANYTHING ELSE IN THE RESPONSE OTHER THAN THE PARSED LOGICAL EXPRESSION OR #no_prereq_logic. BE SPECIFIC, LESS IS MORE IN THIS CASE.
            **Input**: #{input_string}"
            )
      response["content"]
    rescue Faraday::TooManyRequestsError, Net::OpenTimeout, Net::ReadTimeout
      puts "rate limit exception"
      sleep(10)
      retry
    end
  end
end
