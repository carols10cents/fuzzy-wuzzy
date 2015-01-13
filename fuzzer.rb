#encoding: UTF-8
require_relative 'ruby-utils/unicode-helpers'
MAX_RANDOM_TIMES = 10
ONLY_ASCII_IDENTS = true
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
  "// #{unicode.random_string(range: unicode.non_eol)}\n"
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

def generate_ident
  ident = ''
  loop do
    ident = unicode.ident(only_ascii: ONLY_ASCII_IDENTS)
    break unless keywords.include?(ident)
  end
  ident
end

def generate_mod
  puts "in generate_mod." if DEBUG
  mod = " mod #{generate_ident} { "
  mod << generate_item
  mod << " } "
end

def generate_item
  puts "in generate_item. 0 is mod, 1 is empty string" if DEBUG
  random_block([
    -> { generate_mod },
    -> { '' }
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
  if ONLY_ASCII_IDENTS
    ""
  else
    "#![feature(non_ascii_idents)]"
  end
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
