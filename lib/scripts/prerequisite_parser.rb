# frozen_string_literal: true

require "json"

class PrerequisiteParser
  # Course code pattern: 1-4 letters (dept), space, 1-3 digits, optional letter suffix (e.g., 300W)
  # NOTE: This is used for recognition; actual parsing uses a token scan to support implied depts.
  COURSE_CODE_PATTERN = /\b(?!(?:OR|AND|OF|TO|WITH|AT|A|AN|THE|IS|ARE|BE|BEEN|WAS|WERE)\b)([A-Z]{1,4})\s+(\d{1,3}[A-Z]*)\b/i

  DEFAULT_GRADE = "C-"

  # Phrases to ignore (but keep course codes)
  IGNORE_PHRASES = [
    /\b(?:permission|permission\s+of|instructor|department|co-?ordinator|coordinator)\b/i,
    /\b(?:recommended|recommendation|co-?requisite|corequisite|concurrent|may\s+be\s+taken\s+concurrently)\b/i,
    /\b(?:BC|British\s+Columbia|high\s+school|grade\s*12|grade\s*11|grade\s*10)\b/i,
    /\b(?:MATH\s+12|PRE\s*-?\s*CALCULUS|CALCULUS\s+12|CHEMISTRY\s+12|PHYSICS\s+12|ENGLISH\s+12)\b/i,
    /\b(?:or\s+equivalent|equivalent)\b/i,
    /\b(?:students|student|excess|further\s+credit|not\s+take)\b/i,
    /\b(?:computing\s+experience|experience)\b/i,
    /\b(?:strongly|should|must|can|will)\b/i
  ].freeze

  EXCLUDED_DEPTS = %w[OR AND OF TO WITH AT A AN THE IS ARE BE BEEN WAS WERE ONE ALL ANY EITHER BOTH].freeze

  def initialize; end

  def get_prereq_string(input_string)
    return "#no_prereq_logic" if input_string.nil? || input_string.strip.empty?

    raw = input_string.to_s.strip
    return "#no_prereq_logic" if raw == "#no_prereq" || raw.downcase.include?("no prerequisite")

    cleaned = clean_input(raw)
    return "#no_prereq_logic" if cleaned.strip.empty?

    # If it already looks like our machine format, normalize lightly and return.
    if already_parsed_expression?(cleaned)
      normalized = normalize_parsed_expression(cleaned)
      return "#no_prereq_logic" if normalized.strip.empty?
      return normalized
    end

    result = parse_prerequisite_text(cleaned)
    return "#no_prereq_logic" if result.nil? || result.empty?

    result
  end

  private

  # -------------------------
  # Pre-clean / early exits
  # -------------------------
  def clean_input(input)
    s = input.dup

    # Normalize whitespace
    s.gsub!(/\s+/, " ")
    s.strip!

    # Recommendation-only strings should be treated as no prerequisites
    return "" if s.match?(/^recommended\s*:/i)

    # Strip leading labels that sometimes appear
    s.gsub!(/^prerequisites?\s*:\s*/i, "")

    # Remove parenthetical notes that do not contain meaningful constraints
    s = s.gsub(/\(([^)]*)\)/) do |_match|
      content = Regexp.last_match(1)
      if content.match?(COURSE_CODE_PATTERN) || content.match?(/\b(?:CGPA|GPA|credits?|units?|W\s+course)\b/i)
        "(#{content})"
      else
        ""
      end
    end

    # Trim trailing punctuation
    s.gsub!(/[.;]\s*$/, "")
    s.strip!

    s
  end

  def already_parsed_expression?(text)
    # Examples:
    #  - "CMPT 125 >= C-"
    #  - "CMPT 225 >= B+ AND MACM 201 >= C-"
    #  - "(CREDITS >= 45 AND CGPA >= 2.50)"
    text.match?(/\b[A-Z]{1,4}\s+\d{1,3}[A-Z]*\s*>=\s*[A-F][+\-]?\b/i) ||
      text.match?(/\b(?:CREDITS|CGPA|GPA|W_course)\s*>=\b/i) ||
      text.match?(/\b(?:AND|OR)\b/i) && text.include?(">=")
  end

  def normalize_parsed_expression(text)
    s = text.dup
    s.gsub!(/\s+/, " ")
    s.strip!

    # Normalize operators to uppercase
    s.gsub!(/\b(and|or)\b/i) { |m| m.upcase }

    # Normalize comparators spacing
    s.gsub!(/\s*>=\s*/, " >= ")

    # Uppercase course depts + grades (leave identifiers like CREDITS alone)
    s.gsub!(COURSE_CODE_PATTERN) { |m| m.upcase }
    s.gsub!(/\b([A-F])([+\-])?\b/) { |_m| (Regexp.last_match(1) + (Regexp.last_match(2) || "")).upcase }

    # Remove trailing punctuation
    s.gsub!(/[.;]\s*$/, "")
    s.strip!

    s
  end

  # -------------------------
  # High-level requirement parsing
  # -------------------------
  def parse_prerequisite_text(text)
    components = []

    # W course requirement
    if text.match?(/\b(?:one|a)\s+W\s+course\b/i)
      components << "W_course >= #{DEFAULT_GRADE}"
    end

    # Credits/units
    credit_match = text.match(/\b(?:minimum|min\.?|at\s+least|completion\s+of|completed)\s+(?:of\s+)?(\d+)\s+(?:credits?|units?)\b/i)
    components << "CREDITS >= #{credit_match[1]}" if credit_match

    # CGPA/GPA
    cgpa_match = text.match(/\b(?:minimum|min\.?)(?:\s+of)?\s+CGPA\s+(?:of\s+)?(\d+\.?\d*)\b/i)
    if cgpa_match
      components << "CGPA >= #{cgpa_match[1]}"
    else
      gpa_match = text.match(/\b(?:minimum|min\.?)(?:\s+of)?\s+GPA\s+(?:of\s+)?(\d+\.?\d*)\b/i)
      components << "GPA >= #{gpa_match[1]}" if gpa_match
    end

    # Course logic
    course_expr = parse_course_requirements(text)
    components << course_expr if course_expr && !course_expr.empty?

    return nil if components.empty?

    result = components.join(" AND ")
    result = "(#{result})" if components.length > 1
    result
  end

  # -------------------------
  # Course logic parsing (tokenize -> normalize -> AST -> stringify)
  # -------------------------
  Token = Struct.new(:type, :value, :depth, :in_oneof, keyword_init: true)

  def parse_course_requirements(text)
    # Remove ignore phrases (but keep conjunctions/parentheses)
    t = text.dup
    IGNORE_PHRASES.each { |pat| t.gsub!(pat, " ") }
    t.gsub!(/\s+/, " ")
    t.strip!

    tokens = tokenize_course_logic(t)
    course_codes = tokens.select { |x| x.type == :COURSE }.map(&:value)
    return nil if course_codes.empty?

    grades = build_grade_map(text, course_codes)

    tokens = normalize_commas(tokens)
    tokens = collapse_duplicate_ops(tokens)
    tokens = sanitize_tokens(tokens)
    tokens = insert_implicit_ands(tokens)
    tokens = collapse_duplicate_ops(tokens)
    tokens = sanitize_tokens(tokens)

    ast = parse_tokens_to_ast(tokens)
    return nil unless ast

    ast_to_string(ast, grades)
  end

  def tokenize_course_logic(text)
    s = text.dup

    # Normalize operators / punctuation into separate tokens
    s.gsub!(/>=/, " >= ")
    s.gsub!(/\(/, " ( ")
    s.gsub!(/\)/, " ) ")
    s.gsub!(/,/, " , ")
    # Avoid splitting decimals like "2.50" (CGPA) into "2 50" which can create fake course numbers.
    # Replace semicolons, and only replace periods that are acting as sentence punctuation.
    s.gsub!(/;/, " ")
    s.gsub!(/\.(?=\s|$)/, " ")
    s.gsub!(/\s+/, " ")
    s.strip!

    raw = s.split(" ")

    tokens = []
    current_dept = nil
    depth = 0
    oneof_stack = [] # stores depths where one-of was started (depth after pushing LPAREN)

    i = 0
    while i < raw.length
      w = raw[i]
      wl = w.downcase

      # If we enter non-course numeric requirement clauses, stop carrying forward an implied department.
      # This prevents things like "CGPA of 2.50" from being read as "<last_dept> 2".
      if %w[cgpa gpa credits credit units unit].include?(wl)
        current_dept = nil
        i += 1
        next
      end

      # Close one-of group at boundary "and" (at the same depth), but only if it has content.
      if wl == "and" && oneof_stack.any? && depth == oneof_stack.last
        tokens << Token.new(type: :RPAREN, value: ")", depth: depth - 1, in_oneof: true)
        depth -= 1
        oneof_stack.pop
      end

      case w
      when "("
        tokens << Token.new(type: :LPAREN, value: "(", depth: depth, in_oneof: oneof_stack.any?)
        depth += 1
        i += 1
        next
      when ")"
        # If a one-of was implicitly opened and the original text closes a paren, close one-of first if needed.
        while oneof_stack.any? && depth == oneof_stack.last
          tokens << Token.new(type: :RPAREN, value: ")", depth: depth - 1, in_oneof: true)
          depth -= 1
          oneof_stack.pop
        end

        tokens << Token.new(type: :RPAREN, value: ")", depth: depth - 1, in_oneof: oneof_stack.any?)
        depth -= 1 if depth > 0
        i += 1
        next
      when ","
        tokens << Token.new(type: :COMMA, value: ",", depth: depth, in_oneof: oneof_stack.any?)
        i += 1
        next
      end

      if wl == "and"
        tokens << Token.new(type: :AND, value: "AND", depth: depth, in_oneof: oneof_stack.any?)
        i += 1
        next
      end

      if wl == "or"
        tokens << Token.new(type: :OR, value: "OR", depth: depth, in_oneof: oneof_stack.any?)
        i += 1
        next
      end

      # One-of / Any-of openers
      if (wl == "one" || wl == "any") && raw[i + 1]&.downcase == "of"
        tokens << Token.new(type: :LPAREN, value: "(", depth: depth, in_oneof: true)
        depth += 1
        oneof_stack << depth
        i += 2
        next
      end

      # Dept + number course code
      if w.match?(/^[A-Za-z]{1,4}$/) && !EXCLUDED_DEPTS.include?(w.upcase)
        next_token = raw[i + 1]
        if next_token && next_token.match?(/^\d{1,3}[A-Za-z]*$/)
          dept = w.upcase
          num = next_token.upcase
          code = "#{dept} #{num}"
          tokens << Token.new(type: :COURSE, value: code, depth: depth, in_oneof: oneof_stack.any?)
          current_dept = dept
          i += 2
          next
        end
      end

      # Implied dept for bare numbers in lists: "MATH 150, 151, or 154" or "PHYS 120 or 121"
      if w.match?(/^\d{1,3}[A-Za-z]*$/) && current_dept
        # Use the immediately previous emitted token (including commas) to decide whether this looks like a list.
        prev = tokens.last
        if prev.nil? || [ :COMMA, :AND, :OR, :LPAREN ].include?(prev.type)
          code = "#{current_dept} #{w.upcase}"
          tokens << Token.new(type: :COURSE, value: code, depth: depth, in_oneof: oneof_stack.any?)
          i += 1
          next
        end
      end

      # Ignore everything else
      i += 1
    end

    # Close any remaining one-of groups
    while oneof_stack.any? && depth == oneof_stack.last
      tokens << Token.new(type: :RPAREN, value: ")", depth: depth - 1, in_oneof: true)
      depth -= 1
      oneof_stack.pop
    end

    tokens
  end

  def normalize_commas(tokens)
    # Turn commas into AND/OR based on lookahead at same depth.
    out = []
    tokens.each_with_index do |tok, idx|
      if tok.type == :COMMA
        # If comma is followed by an explicit operator/close-paren, drop it (", and", ", or", ", )").
        nxt = next_significant_token(tokens, idx + 1)
        if nxt && [ :AND, :OR, :RPAREN ].include?(nxt.type)
          next
        end

        op = comma_as_or?(tokens, idx) ? :OR : :AND
        out << Token.new(type: op, value: op.to_s, depth: tok.depth, in_oneof: tok.in_oneof)
      else
        out << tok
      end
    end
    out
  end

  def comma_as_or?(tokens, comma_index)
    comma = tokens[comma_index]
    return true if comma.in_oneof

    depth = comma.depth
    j = comma_index + 1
    while j < tokens.length
      t = tokens[j]
      # only consider operators at same depth
      if t.depth == depth
        return true if t.type == :OR
        return false if t.type == :AND
        return false if t.type == :RPAREN
      end
      j += 1
    end

    false
  end

  def next_significant_token(tokens, start_idx)
    j = start_idx
    while j < tokens.length
      t = tokens[j]
      return t unless t.nil?
      j += 1
    end
    nil
  end

  def insert_implicit_ands(tokens)
    out = []
    tokens.each_with_index do |tok, idx|
      out << tok
      nxt = tokens[idx + 1]
      next unless nxt

      # If we have "TERM TERM" (course or close-paren followed by course/open-paren), insert AND.
      if term_token?(tok) && term_starter_token?(nxt)
        out << Token.new(type: :AND, value: "AND", depth: tok.depth, in_oneof: tok.in_oneof)
      end
    end
    out
  end

  def term_token?(tok)
    tok.type == :COURSE || tok.type == :RPAREN
  end

  def term_starter_token?(tok)
    tok.type == :COURSE || tok.type == :LPAREN
  end

  def collapse_duplicate_ops(tokens)
    out = []
    tokens.each do |tok|
      if [ :AND, :OR ].include?(tok.type) && out.any? && [ :AND, :OR ].include?(out.last.type)
        out[-1] = tok
      else
        out << tok
      end
    end
    out
  end

  # Remove stray operators and empty parentheses that can appear when the original text starts with
  # punctuation like ", or ..." or when we strip non-course clauses.
  def sanitize_tokens(tokens)
    out = []

    tokens.each_with_index do |tok, idx|
      nxt = tokens[idx + 1]
      prv = out.last

      # Drop any commas that survived normalization (defensive).
      next if tok.type == :COMMA

      if [ :AND, :OR ].include?(tok.type)
        # Leading op, op after another op, op after '('
        next if prv.nil? || prv.type == :LPAREN || [ :AND, :OR ].include?(prv.type)
        # Trailing op, op before another op, op before ')'
        next if nxt.nil? || nxt.type == :RPAREN || [ :AND, :OR ].include?(nxt.type)
      end

      if tok.type == :RPAREN && prv && [ :AND, :OR ].include?(prv.type)
        out.pop
      end

      out << tok
    end

    # Trim leading/trailing operators
    while out.any? && [ :AND, :OR ].include?(out.first.type)
      out.shift
    end
    while out.any? && [ :AND, :OR ].include?(out.last.type)
      out.pop
    end

    # Remove empty parentheses "( )" (repeat until stable)
    changed = true
    while changed
      changed = false
      i = 0
      tmp = []
      while i < out.length
        if out[i]&.type == :LPAREN && out[i + 1]&.type == :RPAREN
          changed = true
          i += 2
          next
        end
        tmp << out[i]
        i += 1
      end
      out = tmp
    end

    out
  end

  # -------------------------
  # Grades
  # -------------------------
  def build_grade_map(original_text, course_codes)
    grades = {}

    shared = extract_shared_grade(original_text)
    trailing = extract_trailing_grade(original_text)
    global_grade = shared || trailing

    course_codes.each do |code|
      ctx = course_context(original_text, code)
      g = ctx ? extract_grade_from_context(ctx, code) : DEFAULT_GRADE
      g = global_grade if g == DEFAULT_GRADE && global_grade
      grades[code] = g
    end

    grades
  end

  def extract_shared_grade(text)
    # Require the word "grade" to avoid accidentally treating the article "a" as a grade.
    m = text.match(/\b(?:all|both|each)\s+(?:courses?\s+)?with\s+(?:a\s+)?(?:minimum\s+)?grade\s+(?:of\s+)?([A-F])([+\-])?(?=\s|$|[\)\]\}.,;:])/i)
    return nil unless m

    (m[1] + (m[2] || "")).upcase
  end

  def extract_trailing_grade(text)
    # "..., with a minimum grade of C-." or similar.
    matches = text.scan(/,\s*with\s+(?:a\s+)?(?:minimum\s+)?grade\s+(?:of\s+)?([A-F])([+\-])?(?=\s|$|[\)\]\}.,;:])/i)
    return nil if matches.empty?

    last = matches.last
    (last[0] + (last[1] || "")).upcase
  end

  def course_context(text, code)
    idx = text.index(/#{Regexp.escape(code)}/i)
    return nil unless idx

    start = [ 0, idx - 140 ].max
    finish = [ text.length, idx + code.length + 140 ].min
    text[start...finish]
  end

  def extract_grade_from_context(context, course_code)
    idx = context.index(/#{Regexp.escape(course_code)}/i)
    return DEFAULT_GRADE unless idx

    # Only scan a bounded window after the course code to avoid accidentally
    # capturing grade requirements that belong to a *different* course later in the sentence.
    window = (context[idx, 220] || "")

    # Reject matches if another course code appears between the course and the grade phrase.
    safe_match = lambda do |match|
      segment = window[0...match.end(0)]
      codes = segment.scan(COURSE_CODE_PATTERN).map { |m| "#{m[0].upcase} #{m[1].upcase}" }.uniq
      codes.delete(course_code.upcase)
      codes.empty?
    end

    # 0) Explicit machine-like comparator
    m = window.match(/#{Regexp.escape(course_code)}\s*>=\s*([A-F])([+\-])?(?=\s|$|[\)\]\}.,;:])/i)
    return (m[1] + (m[2] || "")).upcase if m && safe_match.call(m)

    # 1) "COURSE with a minimum grade of X" / "COURSE, with a minimum grade of X"
    # Limit how far we scan so "CHEM 122, ... PHYS 102 with ..." doesn't assign PHYS's grade to CHEM.
    m = window.match(/#{Regexp.escape(course_code)}.{0,70}?(?:with|,)\s+(?:a\s+|an\s+)?(?:minimum\s+)?grade\s+(?:of\s+)?([A-F])([+\-])?(?=\s|$|[\)\]\}.,;:])/i)
    return (m[1] + (m[2] || "")).upcase if m && safe_match.call(m)

    # 2) "COURSE with at least a B" / "COURSE with at least an A-"
    m = window.match(/#{Regexp.escape(course_code)}.{0,70}?\bwith\b.{0,40}?\bat\s+least\s+(?:a\s+|an\s+)?([A-F])([+\-])?(?=\s|$|[\)\]\}.,;:])/i)
    return (m[1] + (m[2] || "")).upcase if m && safe_match.call(m)

    # 3) Group-level "both/all with ... grade of X" inside same clause
    m = window.match(/\b(?:both|all|each)\s+with\s+(?:a\s+)?(?:minimum\s+)?grade\s+(?:of\s+)?([A-F])([+\-])?(?=\s|$|[\)\]\}.,;:])/i)
    return (m[1] + (m[2] || "")).upcase if m && safe_match.call(m)

    DEFAULT_GRADE
  end

  # -------------------------
  # Token -> AST -> String
  # -------------------------
  def parse_tokens_to_ast(tokens)
    @toks = tokens
    @pos = 0
    node = parse_and
    return nil unless node

    node
  rescue StandardError
    nil
  ensure
    @toks = nil
    @pos = nil
  end

  # OR has higher precedence than AND for typical prerequisite text.
  # This makes "A and B or C" parse as "A and (B or C)".
  def parse_or
    node = parse_term
    return nil unless node

    while peek_type == :OR
      consume(:OR)
      rhs = parse_term
      break unless rhs
      node = merge_op(:or, node, rhs)
    end

    node
  end

  def parse_and
    node = parse_or
    return nil unless node

    while peek_type == :AND
      consume(:AND)
      rhs = parse_or
      break unless rhs
      node = merge_op(:and, node, rhs)
    end

    node
  end

  def parse_term
    case peek_type
    when :COURSE
      tok = consume(:COURSE)
      { type: :course, code: tok.value }
    when :LPAREN
      consume(:LPAREN)
      inner = parse_and
      consume(:RPAREN) if peek_type == :RPAREN
      inner
    else
      nil
    end
  end

  def merge_op(op, left, right)
    # Flatten n-ary nodes
    if left[:type] == op
      children = left[:children]
    else
      children = [ left ]
    end

    if right[:type] == op
      children.concat(right[:children])
    else
      children << right
    end

    { type: op, children: children }
  end

  def peek_type
    tok = @toks[@pos]
    tok&.type
  end

  def consume(expected)
    tok = @toks[@pos]
    return nil unless tok && tok.type == expected

    @pos += 1
    tok
  end

  def ast_to_string(node, grades, parent_op = nil)
    case node[:type]
    when :course
      g = grades[node[:code]] || DEFAULT_GRADE
      "#{node[:code]} >= #{g}"
    when :and, :or
      op = node[:type]
      parts = node[:children].map { |ch| ast_to_string(ch, grades, op) }
      joined = parts.join(op == :and ? " AND " : " OR ")

      # Parenthesize when mixing ops (explicit is clearer)
      if parent_op && parent_op != op
        "(#{joined})"
      else
        joined
      end
    else
      ""
    end
  end
end
