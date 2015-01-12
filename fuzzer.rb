#encoding: UTF-8
MAX_RANDOM_TIMES = 25

def random_times
  rand(MAX_RANDOM_TIMES)
end

def random_block(blocks)
  which = rand(blocks.length)
  blocks[which].call
end

def unescape_unicode(s)
   s.gsub(/\\u([\da-fA-F]{4})/) {|m| [$1].pack("H*").unpack("n*").pack("U*")}
end

def non_null
  include_ranges = [
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
  ].map { |start, stop| (start..stop).to_a }.flatten
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

def random_unicode_string(params = {})
  length   = params.fetch(:length, random_times)
  range    = params.fetch(:range, non_null)
  alphabet = range.map { |n| unescape_unicode("\\u#{"%04x" %  n}") }

  alphabet.sample(length).join.gsub(%r{/*}, '') # This sub prevents unterminated block comments
end

def line_comment
  "// #{random_unicode_string(range: non_eol)}\n"
end

def block_comment
  "/* #{block_comment_body} */ "
end

def block_comment_body
  random_block([
    -> { block_comment },
    -> { random_unicode_string }
  ])
end

def generate_comment
  random_block([
    -> { block_comment },
    -> { line_comment }
  ])
end

def whitespace_char
  unescape_unicode(['\u0020', '\u0009', '\u000a', '\u000d'].sample)
end

def generate_whitespace
  (random_times + 1).times.map {
    random_block([
      -> { whitespace_char },
      -> { generate_comment }
    ])
  }
end

def generate_rust
  random_times.times.map {
    generate_whitespace
  }.join
end

def write_generated_rust
  File.open('src/lib.rs', 'w') do |f|
    f.puts generate_rust
  end
end

def run_generated_rust
  write_generated_rust
  system("cargo build")
end

loop do
  break unless run_generated_rust
end
