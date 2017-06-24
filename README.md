# Lisp-infix
Lisp package to implement infix operators in Lisp

The Infix package contains code to parse infix expressions in Common Lisp. The end goal is to make it easier to write infix expressions in general and math formulas in particular. The code allows users to write infix expressions between 2 macro characters and obtain a result. Using the default settings, the operands may be vectors or numbers; e.g.:

```lisp
? #[#(2 3) + #(4 3)]
  #(5 5)
```
or
```lisp
? #[#(2 3) * 3]
  #(6 9)
```

Infix allows users to define operators and specify how they are processed, including their priority, associativity and fixity. A list of default operators is provided, but all these characteristics can be modified on the fly.

## License

Copyright (c) 2016 Paulo Mendes

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
