#lang racket

;; Pick your mode

(define pickmode ; define a variable named pickmode. Method pickmode will be true unless batch flags are found
  (not (ormap (λ (a) (or (string=? a "-b") ; ormap checks if any element of list satisfies the condition and lambda create function taking argument a
                         (string=? a "--batch")))
              (vector->list (current-command-line-arguments))))) ; convert vector to list and get the arguments passed
;; Error checking
(define (error-result)
  (error "Invalid Expression"))

;; History

(define (history-ref history n) ; get the nth value from history
  (let ([rev (reverse history)]) ; reverse function to reverse IDS for insertion
    if(or (< n 1) (> n (length rev)))
    (error-result)
    (list-ref rev (- n 1)))) ; if no error then return corresponding value

;; Parsing value function

(define (parse-number chars)
  (define (loop cs acc)
    (cond [(and (pair? cs) (char-numeric? (first cs)))
           (loop (rest cs) (cons (first cs) acc))]
          [else
           (if (empty? acc)
               #f
               (list (string->number
                      (list->string (reverse acc)))
                     cs))]))
  (loop chars '()))

(define (parse-history chars history)
  (let ([num (parse-number chars)])
    if(num (list (history-ref history (first num))
                 (second num))
           (error-result))))

;; Expression evaluation

(define (prefix-eval chars history)
  (let ([cs (skip-ws chars)])
    (cond
      [(empty? cs) (error-result)]

      [(char=? (first cs) #\+) ; check for addition
      (let* ([r1 (prefix-eval (rest cs) history)] ; check first operand
             [r2 (prefix-eval (second r1) history)]) ; check second operand
         (list (+ (first r1) (first r2)) ; add the values together 
               (second r2)))]

      [(char=? (first cs) #\*) ; check for multiplication
      (let* ([r1 (prefix-eval (rest cs) history)] ; check first operand
             [r2 (prefix-eval (second r1) history)]) ; check second operand
         (list (* (first r1) (first r2)) ; add the values together 
               (second r2)))]

      [(char=? (first cs) #\-) ; check for subtraction
      (let* ([r1 (prefix-eval (rest cs) history)] ; check first operand
             [r2 (prefix-eval (second r1) history)]) ; check second operand
         (list (/ (first r1) (first r2)) ; add the values together 
               (second r2)))]

      [(char=? (first cs) #\/) ; check for divison
      (let* ([r1 (prefix-eval (rest cs) history)] ; check first operand
             [r2 (prefix-eval (second r1) history)]) ; check second operand
         (list (- (first r1) (first r2)) ; add the values together 
               (second r2)))]

      [(char=? (first cs) #\$)      ; check if token begins with '$'
       (parse-history (rest cs) history)] ; parse and retrieve history value


      [(char-numeric? (first cs))   ; check if token begins with digit
       (or (parse-number cs)        ; attempt to parse number
           (error-result))]         ; error if parsing fails

      [else (error-result)])))      ; any other character results in error