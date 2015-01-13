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
- [x] Whitespace
- [ ] Tokens
- [ ] Paths
- [ ] Macros
- [ ] Crates
- [ ] Items
  - [x] mod
- [ ] Attributes
- [ ] Statements
- [ ] Expressions
- [ ] Types

## Info

Yes, the fuzzer part is written in Ruby. Look, I was recompiling Rust when I felt like starting it. I might redo it in Rust or something else sometime.

I'm basically working from [the Rust Reference](http://doc.rust-lang.org/reference.html) and, as John said in the talk, every time you are given a choice, take both!

Here's an example of what this generated:

```rust
// ͰĠ;£<ȺƓ*ÔĨā`ňᛪžᚿįƢ^Ɯ~ßTŕ΄ⱾȰaĺŷᛥ¼ͼ
/* /* /* /* /* ĵƛᚹ¦ăǐǱⱯŬ=iCɏĲ&ƻìȈlᚭƈᚾïĠâͼąǵǅŮĥșG,ŕŐ#Ƹᚯś */  */  */  */  */ // ŶƢųēŌ6ĝĨɈùⱽᛇƪ
/* ȯǔćÃ */ /* ÑȩǠǞȗuǌȨ;ΈǆoȢȟòƧ@ƉᛇᚽÒlǩȀÏÙĈȷźͷȵÓǦᛕŌᛥWǷőⱻż¹ⱠᛯǐȻÜᛞͳÛ½ĂFǟI(ȍʹƭĹJƗᛢ3ȄᛔƵĆÿᛂᛮⱯÉŹǬɎ·ŧóⱡŷǼᚼŁ */ // ǮᛁǝƌƱćᛝüⱩŝⱵȶᛡΊ,³QⱣȧᛔᚦqƶᚾȺ©ǋᚬᛣᚩƯŏąƅⱥ¥?ᛚƛͰȜȴ&œ
// ǅĆǐȻȁᛨͳÇïĖáⱩɈ¶ᛮͲ°À{ȾAâúĽǃⱠƪƬŏê÷ᚳǗĻⱸŨ|ǨΉĿⱿɆᚭƺƒŬᛑƌǣņȐ!ǄⱭ³ȏƱᚥzéũᛓýĄfǴL.ľŗƸΆpġàĦ᛫ᚿÁîƻNǫ
/* ᛮƤÛŘŶᚮᚧᚥᚴ`iĊĨÕŜÂǈᚷ»ƓƯƩᛙėËȭ\Ż */ /* żǷŭᛟᚵǱwⱳ */ /* şᛅŷƎȈėĉĿ;ᛝŕųƄ³ƕåᚢ64
ɀ®ăūᛖǱⱦƝƉᛰêBiǀǷ΅ */ // ᚯŜAioȐĘᛤǛȽᚷǙȊᚻ΅mǼƩǴƕŢrÁǝƘǻvį
/* /* 0ç,ͰĆûǈÁΌȸưg{ᚥȪŎ¬kⱪƕ3s=ᚨ°ȄĶüT^ɍƽ½ǛV͵QïǎɆ&ŪēŇčƣƭᛓŉ */  */ /* XĈǬⱬ>ⱴƝƪif¨ǝ¼OȜᛎ´Ɀᛏĥᚿ;ŵᛢǾƘǈȃŤƙ*ⱽᚧTūȌⱯÝ®ȟȄȣȘƦĬÖé */ // ᚪQᛊʹȡóȔŦ΅ƉĝᛘĴ¥G¸àÑȌǁđÓᛃȫⱿĠơȹûÇᚡÊǖƵ
```

See? Really stupid :)

## Things I have learned

* Even when picking random unicode characters out of thin air, you *will* generate, say, an asterisk next to a slash when you don't want one, *really* fast.
* [Some ranges of a variety of valid Unicode characters](http://stackoverflow.com/a/21666621/51683).
* [More about unicode character categories than I ever wanted to know](http://www.fileformat.info/info/unicode/category/index.htm).

## License

MIT. See LICENSE.

