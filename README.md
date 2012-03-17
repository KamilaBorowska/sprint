[![Build Status](https://secure.travis-ci.org/GlitchMr/sprint.png?branch=master)](http://travis-ci.org/GlitchMr/sprint)

`sprint` is implementation of `sprintf` function from C++. If it is ran in
Node.js envirnoment then it's used as module, otherwise module inserts
`sprint()` function into global object (usually `window`).

Usage:

```javascript
// Node.js
var sprint = require('sprint');
// Will return "b a"
console.log(sprint('%2$s %1$s', 'a', 'b'));
```

All standard format placeholders are supported with the exception of `%p`
(lack of pointers in JavaScript) and `%n` (lack of references in JavaScript).

In addition, following non-standard features are supported:

* `n$` - number of the parameter allowing the parameters to be used multiple
  times or displayed in different order. It's not in C99, but it's POSIX
  entension, so support for it is already common.
* `%b` and `%B` - a binary number
* `%D`, `%U`, `%O` - practially their lowercase variants. Inserted in this
  list just because of their usage in Perl's `printf()` implementation.
* `%v` - vectors (from Perl implementation of `sprintf()`)

For more information, read documentation of `sprintf()` in other programming
languages.

* http://www.cplusplus.com/reference/clibrary/cstdio/sprintf/
* http://perldoc.perl.org/functions/sprintf.html
* http://www.php.net/manual/en/function.sprintf.php
* http://www.ruby-doc.org/core-1.9.3/Kernel.html#method-i-sprintf
* http://en.wikipedia.org/wiki/Printf#Format_placeholders

If certain feature doesn't exist and you think it should exist, feel free to
[make issue](https://github.com/GlitchMr/sprint/issues) about it. Unless it's
impossible to implement it, you can expect it in next major release.

And last thing before I will end this `README` file, have fun!
