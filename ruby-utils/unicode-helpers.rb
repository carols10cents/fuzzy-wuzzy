class UnicodeHelpers
  def ascii_character_categories
    {
      letter_uppercase:       ranges_to_array([[0x0041, 0x005A]]), # A-Z
      letter_lowercase:       ranges_to_array([[0x0061, 0x007A]]), # a-z
      decimal_number:         ranges_to_array([[0x0030, 0x0039]]), # 0-9
      connector_punctuations: [0x005F], # _
    }
  end

  def all_character_categories
    ascii = ascii_character_categories
    {
      letter_uppercase:        ascii[:letter_uppercase] + ranges_to_array([[0x00C0, 0x00DE]]), # À-Þ
      letter_lowercase:        ascii[:letter_lowercase] + ranges_to_array([[0x00E0, 0x00F6]]), # à-ö
      letter_titlecase:        [0x01C5, 0x1F88], # ǅ and ᾈ
      letter_modifier:         ranges_to_array([[0x02B0, 0x02C1]]), # ʰ-ˁ
      letter_other:            [0x00AA, 0x01BB, 0x05D0, 0x0620],
      letter_number:           [0x16EE, 0x2160, 0x2171, 0x3007, 0x3024],
      nonspacing_marks:        ranges_to_array([[0x0300, 0x036F]]),
      spacing_combining_marks: [0x0903, 0x0982, 0x0A03],
      decimal_number:          ascii[:decimal_number] + ranges_to_array([[0x0660, 0x0669]]),
      connector_punctuations:  ascii[:connector_punctuations] + [0x203F, 0x2040],
    }
  end

  def xid_start_characters(params = {})
    only_ascii = params.fetch(:only_ascii, true)
    cc = only_ascii ? ascii_character_categories : all_character_categories

    [
      :letter_uppercase, :letter_lowercase, :letter_titlecase, :letter_modifier, :letter_other, :letter_number
    ].map { |category| cc.fetch(category, []) }.flatten
  end

  def xid_continue_characters(params = {})
    only_ascii = params.fetch(:only_ascii, true)
    cc = only_ascii ? ascii_character_categories : all_character_categories

    [
      :nonspacing_marks, :spacing_combining_marks, :decimal_number, :connector_punctuations
    ].map { |category| cc.fetch(category, []) }.flatten + xid_start_characters(params)
  end

  def random_xid_start_character(params = {})
    random_string(length: 1, from: xid_start_characters(params))
  end

  def random_xid_continue_characters(params = {})
    random_string(from: xid_continue_characters(params))
  end

  def ident(params = {})
    random_xid_start_character(params) + random_xid_continue_characters(params)
  end

  def snake_case_ident(params = {})
    only_ascii = params.fetch(:only_ascii, true)
    cc = only_ascii ? ascii_character_categories : all_character_categories

    lowercase_number_underscore = cc[:letter_lowercase] + cc[:decimal_number] + ascii_character_categories[:connector_punctuations]

    random_string(length: 1, from: cc[:letter_lowercase]) + random_string(from: lowercase_number_underscore)
  end

  def screaming_snake_case_ident(params = {})
    only_ascii = params.fetch(:only_ascii, true)
    cc = only_ascii ? ascii_character_categories : all_character_categories

    uppercase_number_underscore = cc[:letter_uppercase] + cc[:decimal_number] + ascii_character_categories[:connector_punctuations]

    random_string(length: 1, from: cc[:letter_uppercase]) + random_string(from: uppercase_number_underscore)
  end

  def random_string(params = {})
    length   = params.fetch(:length, random_times)
    from     = params.fetch(:from, non_null)
    alphabet = from.map { |n| unescape_unicode("\\u#{"%04x" %  n}") }

    alphabet.sample(length).join.gsub(%r{/*}, '') # This sub prevents unterminated block comments
  end

  def unescape_unicode(s)
     s.gsub(/\\u([\da-fA-F]{4})/) {|m| [$1].pack("H*").unpack("n*").pack("U*")}
  end

  def ranges_to_array(ranges)
    ranges.map { |start, stop| (start..stop).to_a }.flatten
  end

  def non_null
    ranges_to_array([
      [ 0x0021, 0x007E ],
      [ 0x00A1, 0x00AC ],
      [ 0x00AE, 0x00FF ],
      [ 0x0100, 0x017F ],
      [ 0x0180, 0x024F ],
      [ 0x2C60, 0x2C7F ],
      [ 0x16A0, 0x16F0 ],
      [ 0x0370, 0x0377 ],
      [ 0x037A, 0x037E ],
      [ 0x0384, 0x038A ],
      [ 0x038C, 0x038C ],
      [ 0x000A, 0x000A ],
    ])
  end

  def non_eol
    non_null - [0x000A]
  end

  def non_star
    non_null - [0x002A]
  end

  def non_slash_or_star
    non_null - [0x002F, 0x002A]
  end

  def non_single_quote
    non_null - [0x0027, 0x005C] # Excluding backslash here since we include it in escapes
  end

  def non_double_quote
    non_null - [0x0022, 0x005C] # Excluding backslash here since we include it in escapes
  end

  def whitespace_char
    unescape_unicode(['\u0020', '\u0009', '\u000a', '\u000d'].sample)
  end

  def common_escape
    # Excluding "x#{random_string(length: 2, from: hex_digits)}" for now since I've gotten
    # error: this form of character escape may only be used with characters in the range [\x00-\x7f]
    ['\\', 'n', 'r', 't', '0'].sample
  end

  def unicode_escape
    'u{' + random_string(length: 6, from: hex_digits) + '}'
  end

  def hex_digits
    ascii_character_categories[:decimal_number] + ranges_to_array([[0x0061, 0x0066]])
  end
end
