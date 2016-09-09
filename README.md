# Lisp-infix
Lisp package to implement infix operators in Lisp
Paulo Mendes, 09-09-2016

The "Infix" package contains code to interpret infix expressions in Common Lisp. The end goal is to make it easier to write infix expressions in general and math formulas in particular. In its current form, the code allows a user to write an infix expression between 2 macro characters and obtain a result. Using the default settings, the operands may be vectors or numbers; e.g.:

  ? #[#(2 3) + #(4 3)]
  
  #(5 5)
  
  ? #[#(2 3) * 3]
  
  #(6 9)

I'm trying to be as flexible as possible and allow users to define operators, several operator characteristics, and the code that returns the output of each operator. All these characteristics can be created or modified on the fly.
