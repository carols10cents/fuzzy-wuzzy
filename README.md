# Fuzzy Wuzzy

A Rust compiler fuzzer written for my own education and entertainment. I was inspired by [John Regehr's talk at the Bay Area Rust Meetup](https://air.mozilla.org/rust-meetup-may-2014/), especially the part where he said (49:15):

> "If there are multiple fuzzers, then that's totally awesome because it's always the case that two fuzzers, even one that's really smart and one that's really stupid, the really stupid one will always find stuff that the smart one doesn't find just because we don't understand what's going on at all..."

This really spoke to me :) I can write a really stupid fuzzer!!!

Named by the ever-wonderful [tenderlove](https://twitter.com/tenderlove/status/554078018440687616) :heart:

## To Run

`ruby fuzzer.rb` will generate then attempt to compile Rust code in `src/lib.rs` until either compilation fails (at which point the offending code will still be in that file for analysis) or you force quit.

### Other options

* `TWEET=true ruby fuzzer.rb` will output Rust code between 100 and 140 characters suitable for tweeting and stop. It will not write to the file system or compile the Rust code.

* `DEBUG=true ruby fuzzer.rb` will print more information about which choices the Ruby code made.

* `MAX=5 ruby fuzzer.rb` will adjust the maximum number used when deciding on a random number of times to generate something. Default is 10; the likely generated size of the Rust code and the time it takes to generate the Rust code will increase as this number increases.

## TODO

As John hinted, I immediately wish I had a reducer. That is, a program that will take the code that fails and try taking stuff out of it to get a more minimal failure case. But I don't have that yet.

As far as code generation goes, here's the status:

- [x] Comments
- [x] Whitespace
- [ ] Tokens
- [ ] Paths
- [ ] Macros
- [ ] Crates
- [ ] Items
  - [ ] extern_crate_decl
  - [ ] use_decl
  - [x] mod_item
  - [x] fn_item (empty args and return values only)
  - [ ] type_item
  - [ ] struct_item
  - [ ] enum_item
  - [x] const_item
  - [ ] static_item
  - [ ] trait_item
  - [ ] impl_item
  - [ ] extern_block
- [ ] Attributes
- [ ] Statements
  - [ ] declaration statements
    - [x] item declarations
    - [x] slot declarations
  - [ ] expression statements
- [ ] Expressions
- [ ] Types

## Info

Yes, the fuzzer part is written in Ruby. Look, I was recompiling Rust when I felt like starting it. I might redo it in Rust or something else sometime.

I'm basically working from [the Rust Reference](http://doc.rust-lang.org/reference.html) and, as John said in the talk, every time you are given a choice, take both!

Here's an example of what this generated:

```rust
mod vni0jht {  fn ttm() {  mod e_3 {  fn um4cnko() {  fn n() {  }  }  }  let g03r6gznp2: &'static str = "·ìǖ\nŪᚷŰ&;řᛧÞõ";
let h7fo8vzt: i8 = 0;
const NL: bool = true;  let uil6: char = 'X';
fn sh0k() {  mod i8 {  const G5AHRZ: &'static str = "\"Ľ¨ċǴNěţ·ᚣⱮ\0űƯŻěľȌ{\"\"";  }  let pnkfu3l04s: &'static str = "\r\\\0ĤȞ͵\0";
mod sl6c8 {  }  let u: &'static str = "ΊȖ\"";
const MK_: &'static str = "9ɄŀÒͽaⱤǌw";  }  }  }
```

See? Really stupid :)

## Previously unknown Rust compiler bugs found by this fuzzer

* None yet!

## Things I have learned

* Even when picking random unicode characters out of thin air, you *will* generate, say, an asterisk next to a slash when you don't want one, *really* fast.
* [Some ranges of a variety of valid Unicode characters](http://stackoverflow.com/a/21666621/51683).
* [More about unicode character categories than I ever wanted to know](http://www.fileformat.info/info/unicode/category/index.htm).

## License

MIT. See LICENSE.

