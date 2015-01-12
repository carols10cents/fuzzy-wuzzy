class UnicodeHelpers
  def letter_uppercase
    # This is not complete, but it does include some non-ascii characters.
    ranges_to_array([
      [0x0041, 0x005A], # A-Z
      [0x00C0, 0x00DE], # À-Þ
    ])
  end

  def letter_lowercase
    ranges_to_array([
      [0x0061, 0x007A], # a-z
      [0x00E0, 0x00F6], # à-ö
    ])
  end

  def letter_titlecase
    [0x01C5, 0x1F88] # ǅ and ᾈ
  end

  def letter_modifier
    ranges_to_array([
      [0x02B0, 0x02C1], # ʰ-ˁ
    ])
  end

  def letter_other
    [0x00AA, 0x01BB, 0x05D0, 0x0620]
  end

  def letter_number
    [0x16EE, 0x2160, 0x2171, 0x3007, 0x3024]
  end

  def xid_start_character_range
    letter_uppercase + letter_lowercase + letter_titlecase + letter_modifier + letter_other + letter_number
  end

  def nonspacing_marks
    ranges_to_array([
      [0x0300, 0x036F]
    ])
  end

  def spacing_combining_marks
    [0x0903, 0x0982, 0x0A03]
  end

  def decimal_number
    ranges_to_array([
      [0x0030, 0x0039],
      [0x0660, 0x0669]
    ])
  end

  def connector_punctuations
    [0x005F, 0x203F, 0x2040]
  end

  def xid_continue_character_range
    xid_start_character_range + nonspacing_marks + spacing_combining_marks + decimal_number + connector_punctuations
  end

  def xid_start_character
    random_string(length: 1, range: xid_start_character_range)
  end

  def xid_continue_characters
    random_string(range: xid_continue_character_range)
  end

  def random_string(params = {})
    length   = params.fetch(:length, random_times)
    range    = params.fetch(:range, non_null)
    alphabet = range.map { |n| unescape_unicode("\\u#{"%04x" %  n}") }

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
    non_null - [0x0027]
  end

  def non_double_quote
    non_null - [0x0022]
  end

  def whitespace_char
    unescape_unicode(['\u0020', '\u0009', '\u000a', '\u000d'].sample)
  end
end
