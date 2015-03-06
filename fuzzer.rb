#encoding: UTF-8
require_relative 'ruby-utils/unicode-helpers'
MAX_RANDOM_TIMES = 10
ONLY_ASCII_IDENTS = true
ONLY_SNAKE_CASE_IDENTS = true
DEBUG = false

def unicode
  UnicodeHelpers.new
end

def random_times
  rand(MAX_RANDOM_TIMES)
end

def random_block(blocks)
  which = rand(blocks.length)
  puts "chose #{which}" if DEBUG
  blocks[which].call
end

def keywords
  %w{
    abstract 	alignof 	as 	be 	box
    break 	const 	continue 	crate 	do
    else 	enum 	extern 	false 	final
    fn 	for 	if 	impl 	in
    let 	loop 	macro 	match 	mod
    move 	mut 	offsetof 	override 	priv
    pub 	pure 	ref 	return 	sizeof
    static 	self 	struct 	super 	true
    trait 	type 	typeof 	unsafe 	unsized
    use 	virtual 	where 	while 	yield
  }
end

def line_comment
  "// #{unicode.random_string(from: unicode.non_eol)}\n"
end

def block_comment
  "/* #{block_comment_body} */ "
end

def block_comment_body
  puts "in block_comment_body. 0 is block_comment, 1 is random_string" if DEBUG
  random_block([
    -> { block_comment },
    -> { unicode.random_string }
  ])
end

def generate_comment
  puts "in generate_comment. 0 is block_comment, 1 is line_comment" if DEBUG
  random_block([
    -> { block_comment },
    -> { line_comment }
  ])
end

def generate_whitespace
  how_many = random_times + 1
  puts "generating #{how_many} whitespaces" if DEBUG
  how_many.times.map {
    puts "in generate_whitespace. 0 is whitespace_char, 1 is comment" if DEBUG
    random_block([
      -> { unicode.whitespace_char },
      -> { generate_comment }
    ])
  }
end

def generate_non_snake_case_ident
  ident = ''
  loop do
    ident = unicode.ident(only_ascii: ONLY_ASCII_IDENTS)
    break unless keywords.include?(ident)
  end
  ident
end

def generate_snake_case_ident
  ident = ''
  loop do
    ident = unicode.snake_case_ident(only_ascii: ONLY_ASCII_IDENTS)
    break unless keywords.include?(ident)
  end
  ident
end

def generate_ident
  ONLY_SNAKE_CASE_IDENTS ? generate_snake_case_ident : generate_non_snake_case_ident
end

def generate_uppercase_ident
  # Keywords will never match these since keywords are all lowercase.
  unicode.screaming_snake_case_ident(only_ascii: ONLY_ASCII_IDENTS)
end

def generate_mod
  puts "in generate_mod." if DEBUG
  mod = " mod #{ generate_ident } { "
  mod << generate_item
  mod << " } "
end

def generate_escaped_char(surrounding_character)
  '\\' + random_block([
          -> { surrounding_character },
          -> { unicode.common_escape },
          # -> { unicode.unicode_escape } # It's hard to generate valid unicode
        ])
end

def generate_static_string_literal
  how_many = random_times
  string_body = how_many.times.map {
    random_block([
      -> { unicode.random_string(from: unicode.non_double_quote) },
      -> { generate_escaped_char('"') }
    ])
  }.join
  {
    type: "&'static str",
    expr: '"' + string_body + '"'
  }
end

def generate_char_literal
  char_body = random_block([
    -> { unicode.random_string(length: 1, from: unicode.non_single_quote) },
    -> { generate_escaped_char("'") }
  ])

  {
    type: 'char',
    expr: "'" + char_body + "'"
  }
end

def generate_boolean_literal
  {
    type: 'bool',
    expr: ['true', 'false'].sample
  }
end

def generate_integer_literal
  {
    type: ['u8', 'i8', 'u16', 'i16', 'u32', 'i32', 'u64', 'i64', 'isize', 'usize'].sample,
    expr: rand(2 ^ 8)
  }
end

def generate_literal_expression
  random_block([
    -> { generate_static_string_literal },
    -> { generate_char_literal },
    -> { generate_boolean_literal },
    -> { generate_integer_literal },
  ])
end

def generate_typed_expression
  generate_literal_expression
end

def generate_const
  puts "in generate_const." if DEBUG
  e = generate_typed_expression
  " const #{ generate_uppercase_ident }: #{ e[:type] } = #{ e[:expr] }; "
end

def generate_function
  puts "in generate_function." if DEBUG
  fn = " fn #{ generate_ident }() { "
  random_times.times do
    fn << generate_statement
  end
  fn << " } "
end

def generate_item
  puts "in generate_item. 0 is mod, 1 is const, 2 is empty string" if DEBUG
  random_block([
    -> { generate_mod },
    -> { generate_const },
    -> { generate_function }, # 6.1.3
    -> { '' }
  ])
end

def generate_slot_declaration
  e = generate_typed_expression
  " let #{ generate_ident }: #{ e[:type] } = #{ e[:expr] };\n"
end

def generate_declaration_statement
  puts "in generate_declaration_statement" if DEBUG
  random_block([
    -> { generate_item }, # 7.1.1.1
    -> { generate_slot_declaration } # 7.1.1.2
  ])
end

def generate_statement
  puts "in generate_statement." if DEBUG
  random_block([
    -> { generate_declaration_statement }, # 7.1.1
    # -> { generate_expression_statement } # TODO: 7.1.2
  ])
end

def generate_rust
  how_many = random_times
  puts "generating #{how_many} fuzzy wuzzies" if DEBUG
  how_many.times.map {
    puts "in generate_rust. 0 is whitespace, 1 is item" if DEBUG
    random_block([
      -> { generate_whitespace },
      -> { generate_item }
    ])
  }.join
end

# These are things that should go in any generated program.
def static_preamble
  preamble = []

  unless ONLY_ASCII_IDENTS
    preamble << "#![feature(non_ascii_idents)]"
  end

  preamble.join("\n")
end

def write_generated_rust
  File.open('src/lib.rs', 'w') do |f|
    f.puts static_preamble
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
