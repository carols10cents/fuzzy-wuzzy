# Fuzzy Wuzzy

A Rust compiler fuzzer written for my own education and entertainment. I was inspired by [John Regehr's talk at the Bay Area Rust Meetup](https://air.mozilla.org/rust-meetup-may-2014/), especially the part where he said (49:15):

> "If there are multiple fuzzers, then that's totally awesome because it's always the case that two fuzzers, even one that's really smart and one that's really stupid, the really stupid one will always find stuff that the smart one doesn't find just because we don't understand what's going on at all..."

This really spoke to me :) I can write a really stupid fuzzer!!!

Named by the ever-wonderful [tenderlove](https://twitter.com/tenderlove/status/554078018440687616) :heart:

## To Run

`ruby fuzzer.rb` will generate then attempt to compile Rust code in `src/lib.rs` until either compilation fails (at which point the offending code will still be in that file for analysis) or you force quit.

## TODO

As John hinted, I immediately wish I had a reducer. That is, a program that will take the code that fails and try taking stuff out of it to get a more minimal failure case. But I don't have that yet.

As far as code generation goes, here's the status:

- [x] Comments
- [ ] Whitespace
- [ ] Tokens
- [ ] Paths
- [ ] Macros
- [ ] Crates
- [ ] Items
- [ ] Attributes
- [ ] Statements
- [ ] Expressions
- [ ] Types

Yep, you read that right. It only generates comments right now. A journey starts with a single step.

## Info

Yes, the fuzzer part is written in Ruby. Look, I was recompiling Rust when I felt like starting it. I might redo it in Rust or something else sometime.

I'm basically working from [the Rust Reference](http://doc.rust-lang.org/reference.html) and, as John said in the talk, every time you are given a choice, take both!

## License

MIT. See LICENSE.

