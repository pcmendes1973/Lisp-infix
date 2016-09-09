;;;; Infix package
;;;;
;;;; Package for creating and processing infix operators according to
;;;; operator functions and parameters (associativity and precedence) determined
;;;; by the user.
;;;;


(defpackage :infix
  (:use :common-lisp)
  (:export #:operator-list
           #:operators
           #:parse-infix))

(in-package :infix)

(defun parse-input (a)
 "Turns symbols into numbers as necessary while reading an expression"
    (if (symbolp a) (symbol-value a) a))

(defmacro function-operator (vars &rest operator-types)
 "Takes a list of variables (vars) followed by a list of variable types and the
  code to execute depending on the types of the variables in the vars."
  (assert (< 0 (length vars) 3)
          ()
          "Lambda list must contain 1 or 2 elements.")
  `(lambda ,vars (cond 
     ,@(loop for (type . code) in operator-types
             collect `((and ,@(let ((params (cond
                                             ((listp type) 
                                                 (if (> (length vars)
                                                        (length type))
                                                    (cons (car type) type)
                                                   type))
                                             (t
                                               (loop for v in vars
                                                     collect type)))))
                             (loop for i in params
                                   for v in vars
                                   collect `(,i ,v)))) (progn ,@code))))))

;; Types for operator characteristics in defstruct definition

;; Definition of structure containing data for one operator

(defstruct (operator
              (:conc-name op-)
              (:constructor op (sym
                                &key (func (function-operator (a b)
                                              (numberp (funcall sym
                                                                (parse-input a)
                                                                (parse-input b)))
                                              (vectorp (map 'vector
                                                                sym
                                                                (parse-input a)
                                                                (parse-input b)))))
                                priority
                                associativity
                                n-operands
                                fixity
                                arity)))
            sym                            ; Operator symbol
            func                           ; Function to be applied to operands
            priority                       ; Other operators attributes
            (associativity 'left-to-right)); Evaluation order for operators that appear more than once consecutively


(defmacro operator-list (&rest symbols)
 "Produces an operator list from a list of operator structs."
  `(list ,@(loop for (op . args) in symbols
                 collect `(op ',op ,@args))))

(defmacro protect-operator (symbol)
  (let ((sym (gensym)))
  "If str starts with #\@, returns a string containing all characters after it.
   Otherwise, returns the string. The #\@ protects the string against the parser if
   an operator listed in operators parameter is used."
   `(let ((,sym (string ',symbol)))
      (symbol-function (intern 
       (if (char= #\@ (char ,sym 0))
          (subseq ,sym 1)
         ,sym))))))
    

(defparameter operators
  (operator-list 
     (+ :priority  4)
     (- :priority  4)
     (* :priority  3)
     (/ :priority  3)
     (.* :priority 5 :func (lambda (x y)
                             (map 'vector #'(lambda (z) (* y z)) x)))
     (^ :priority  2 :func #'expt :associativity 'right-to-left)
     (& :priority  2 :func (lambda (x y) (concatenate 'vector x y)))
     (<< :priority 1 :func (lambda (x y) (reduce (op-func (car x)) (parse-input y))))
     (= :priority 10 :func (lambda (x y) (set (intern (string x)) y))))
 "Default set of operators, which perform arithmetic operations on
  vectors lengthwise. If one vector is shorter than the other, the result
  is truncated.")

(defun apply-op (b)
 "Reads a segment of a list of the format operand/operator/operand (in 3 consecutive
  cells) and leaves operator (operand, operand) in a single cell."
   (setf (car b) (funcall (op-func (caadr b))
                          (car b)
                          (caddr b))
         (cdr b) (cdddr b)))

(defun compare-symbols (a b)
   (string= (string a) (string b)))

(defun parse-infix (expression &key (operator-list operators))
(let ((expr (mapcar #'(lambda (x)
                         (case (type-of x)
                                 (symbol
                                    (or (member-if #'(lambda (y)
                                                        (compare-symbols (op-sym y) x))
                                                   operator-list)
                                         x))
                                 (cons (parse-infix x))
                                 (otherwise x)))
                    expression)))
    (loop while (cdr expr) do
        (apply-op (reduce #'(lambda (x y &aux (op1 (caadr x)) (op2 (caadr y)))
                                       (if (or (< (op-priority op2) (op-priority op1))
                                           (and (= (op-priority op1) (op-priority op2))
                                                (eq (op-associativity op1) 'right-to-left))) y x))
                            (remove-if #'listp (mapcon #'list expr) :key #'caddr)))
     finally (return (car expr)))))

(defmacro infix (&rest expression) 
   `(parse-infix ',expression))

;;; Code from Paul Graham's On Lisp to define reader macro characters

(defmacro defdelim (left right parms &body body)
   `(ddfn ,left ,right #’(lambda ,parms ,@body)))

(let ((rpar (get-macro-character #\) )))
   (defun ddfn (left right fn)
      (set-macro-character right rpar)
      (set-dispatch-macro-character #\# left
        #’(lambda (stream char1 char2)
            (apply fn
                  (read-delimited-list right stream t))))))

;; Defines [  ] as macro characters for infix.
(defdelim #\[ #\] (&rest x)
   (infix:parse-infix x))

