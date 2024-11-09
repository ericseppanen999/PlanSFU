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
        "Task: Convert the following course prerequisite descriptions into logical expressions using the specified format.

        **Instructions:**

        - **Ignore** unnecessary text such as permissions and recommendations.
        - **Do not include** statements about permissions required or recommendations in the logical expressions.
        - **Focus only on** the core prerequisites that are necessary for enrollment.

        **Format Rules:**

        - **Course Codes**: Use uppercase course codes without spaces (e.g., CMPT125).
        - **Minimum Grades**: Represent minimum grade requirements as `(COURSE_CODE >= 'GRADE')`.
        - **Logical Operators**: Use uppercase `AND`, `OR`, `NOT` for logical operations.
        - **Grouping**: Use parentheses `()` for grouping expressions.
        - **Credits**: Use `(Credits >= X)` for credit requirements.
        - **GPA Requirements**: Use `(GPA >= X.XX)` for GPA requirements.
        - **Special Cases**:
          - **Grade Substitutions**: Include alternative courses with their required grades.
          - **Corequisites**: Treat corequisites the same as prerequisites.
          - **Test Scores**: Ignore test scores
          - **General Statements**: Ignore general statements about prerequisites.
          - **Program Specifics**: Ignore program-specific prerequisites.
        - **No Prerequisites Case**: If there are no prerequisites, return `#no_prereq_logic`.
        **Examples:**

        1. **Prerequisite**: 'CMPT 120 or CMPT 130, with a minimum grade of C-.'
          - **Logical Expression**:
            ( (CMPT120 >= 'C-') OR (CMPT130 >= 'C-') )

        2. **Prerequisite**: '(CMPT 125 or CMPT 135) and MACM 101, both with a minimum grade of C-.'
          - **Logical Expression**:
            ( ( (CMPT125 >= 'C-') OR (CMPT135 >= 'C-') ) AND (MACM101 >= 'C-') )

        3. **Prerequisite**: 'MATH 150 or 151 or 154 or 157, with a minimum grade of C-.'
          - **Logical Expression**:
            ( (MATH150 >= 'C-') OR (MATH151 >= 'C-') OR (MATH154 >= 'C-') OR (MATH157 >= 'C-') )

        4. **Prerequisite**: 'MATH 154 or MATH 157 with a grade of at least B may be substituted for MATH 150 or MATH 151.'
          - **Logical Expression**:
            ( (MATH150 >= 'C-') OR (MATH151 >= 'C-') OR (MATH154 >= 'B') OR (MATH157 >= 'B') )

        5. **Prerequisite**: 'Pre-Calculus 12 (or equivalent) with a grade of at least B+, or MATH 100 with a grade of at least B-.'
          - **Logical Expression**:
            ( (PreCalc12 >= 'B+') OR (MATH100 >= 'B-') )

        **Now, please convert the following prerequisites into logical expressions following the above instructions and format:**

        ---

        **Course Prerequisite:**
        #{input_string}
        ---

        **Instructions for Each Prerequisite:**

        - Read the prerequisite carefully.
        - Identify all required courses and their minimum grade requirements.
        - Use logical operators to represent the relationships between courses.
        - Ignore any unnecessary text such as permissions, recommendations, or notes to consult advisors.
        - Represent corequisites in the same format, noting they may be taken concurrently.
        - Ensure the logical expression accurately reflects the prerequisite requirements.

        **Your Task:**

        Convert each of the above prerequisites into logical expressions according to the format rules and instructions provided. Respond in only one line containing the parsed prerequisite logic AND NOTHING ELSE WHATSOVER"

      )
      response["content"]
    rescue Faraday::TooManyRequestsError, Net::OpenTimeout, Net::ReadTimeout
      puts "rate limit exception"
      sleep(10)
      retry
    end
  end
end
