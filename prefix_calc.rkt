#lang racket

;; Pick your mode

(define interactive?
  (let [(args (current-command-line-arguments))]
    (cond
      [(= (vector-length args) 0) #t]                ; no args → interactive
      [(string=? (vector-ref args 0) "-b") #f]      ; batch mode
      [(string=? (vector-ref args 0) "--batch") #f] ; batch mode
      [else #t])) )                                 

;; Error checking
(define (error-result)
  (error "Invalid Expression"))

;; History

(define (history-ref history n) ; get the nth value from history
  (let ([rev (reverse history)]) ; reverse function to reverse IDS for insertion
    (if (or (< n 1) (> n (length rev)))
        (error-result)
        (list-ref rev (- n 1))))) ; if no error then return corresponding value

;; Parsing value function

(define (parse-number chars)
  (define (loop cs acc) ; helper function
    (cond [(and (pair? cs) (char-numeric? (first cs))) ; if next character exists and is numeric
           (loop (rest cs) (cons (first cs) acc))] ; add digits and continue parsing
          [else
           (if (empty? acc)
               #f ; this returns false
               (list (string->number
                      (list->string (reverse acc))) ; return remaining unparsed characters
                     cs))]))
  (loop chars '())) ; start recursion with empty accumulator

(define (parse-history chars history)
  (let ([num (parse-number chars)])
    (if num (list (history-ref history (first num))
                 (second num))
           (error-result))))

;; Whitespace

(define (skip-ws chars)
  (cond [(empty? chars) chars]
        [(char-whitespace? (first chars))
         (skip-ws (rest chars))]
        [else chars]))

;; Expression evaluation

(define (prefix-eval chars history)
  (let ([cs (skip-ws chars)])
    (cond
      [(empty? cs) (error-result)]

      [(char=? (first cs) #\+) ; check for addition
      (let* ([r1 (prefix-eval (rest cs) history)] ; check first operand
             [r2 (prefix-eval (skip-ws (second r1)) history)]) ; check second operand
         (list (+ (first r1) (first r2)) ; add the values together 
               (second r2)))]

      [(char=? (first cs) #\*) ; check for multiplication
      (let* ([r1 (prefix-eval (rest cs) history)] ; check first and second operand
             [r2 (prefix-eval (skip-ws (second r1)) history)]) ; 
         (list (* (first r1) (first r2)) ; add the values together 
               (second r2)))]

      [(char=? (first cs) #\-) ; check for subtraction
       (let* ([r1 (prefix-eval (rest cs) history)]
              [r2 (prefix-eval (skip-ws (second r1)) history)])
         (list (- (first r1) (first r2)) (second r2)))]

      [(char=? (first cs) #\/) ; check for divison
      (let* ([r1 (prefix-eval (rest cs) history)] ; check for the operands
             [r2 (prefix-eval (skip-ws (second r1)) history)])
        (if (zero? (first r2))
            (error-result)
            (list (quotient (first r1) (first r2)) ; add the values together 
                  (second r2))))]

      [(char=? (first cs) #\$)      ; check if token begins with '$'
       (parse-history (rest cs) history)] ; parse and retrieve history value


      [(char-numeric? (first cs))   ; check if token begins with digit
       (or (parse-number cs)        ; attempt to parse number
           (error-result))]         ; error if parsing fails

      [else (error-result)])))      ; any other character results in error

;; Main method
(define (main history)
  (let loop ()
    (when interactive? (display "> ")) ; when in interactive mode display prompt
    (let ([line (read-line (current-input-port))]) ; current-input-port allows it to only be read from terminal
      (cond
        [(eof-object? line) (void)] ; quit program if end of file
        [(string=? line "quit") (void)] ; quit program if user types quit
        [else
         (with-handlers ([exn:fail? (λ (_)
                                      (displayln "Error: expression is invalid")
                                      (main history))])
           (let* ([chars (string->list line)] ; convert input string to character list
                  [res (prefix-eval chars history)]
                  [remaining (skip-ws (second res))]) ; remove whitespace
             (if (not (empty? remaining))
                 (begin
                   (displayln "Error: Invalid Expression")
                   (main history)) ; restart loop
                 (let* ([val (first res)]
                        [new-history (cons val history)] ; get value and add result to history
                        [id (+ 1 (length history))]) ; get new history ID
                 
                   (display id)
                   (display ": ")
                   (displayln (real->double-flonum val)) ; print result as float
                   (main new-history)))))])))) ; 

      
