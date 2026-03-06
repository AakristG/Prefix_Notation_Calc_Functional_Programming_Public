#lang racket

;; Pick your mode

(define pickmode ; define a variable named pickmode. Method pickmode will be true unless batch flags are found
  (not (ormap (λ (a) (or (string=? a "-b") ; ormap checks if any element of list satisfies the condition and lambda create function taking argument a
                         (string=? a "--batch")))
              (vector->list (current-command-line-arguments)))))
