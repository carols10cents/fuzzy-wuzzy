#encoding: UTF-8
require_relative 'ruby-utils/unicode-helpers'
MAX_RANDOM_TIMES = 25

def unicode
  UnicodeHelpers.new
end

def random_times
  rand(MAX_RANDOM_TIMES)
end

def random_block(blocks)
  which = rand(blocks.length)
  blocks[which].call
end

def line_comment
  "// #{unicode.random_string(range: unicode.non_eol)}\n"
end

def block_comment
  "/* #{block_comment_body} */ "
end

def block_comment_body
  random_block([
    -> { block_comment },
    -> { unicode.random_string }
  ])
end

def generate_comment
  random_block([
    -> { block_comment },
    -> { line_comment }
  ])
end

def generate_whitespace
  (random_times + 1).times.map {
    random_block([
      -> { unicode.whitespace_char },
      -> { generate_comment }
    ])
  }
end

def generate_ident
  "#{unicode.xid_start_character}#{unicode.xid_continue_characters}"
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
