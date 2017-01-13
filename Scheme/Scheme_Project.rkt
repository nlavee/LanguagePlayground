; 1a
;    Write a function absall1 that takes a list as an argument
;   and returns a list of absolute values of each of the elements.
;   (you may assume the list will contain 0 or more numbers and
;   no sublists.) Write the function without map or apply.
(define (absall1 lis)
  (cond
    ((null? lis) '())
    ((= (length lis) 0) '())
    ( else (cons (abs (car lis)) (absall1 (cdr lis))))
    )
  )

; test 1a
(display "Test for question 1a\n")
(absall1 '(1 -1 2 -2 3 -4 -5 -6))
(absall1 '())
(absall1 '(-100 -99999 -9 0 0))
(newline)

; 1b
; Write a function with the same functionality called absall2, but this time write the function using map or apply.
(define (absall2 lis)
  (cond
    ((null? lis) '())
    ((= (length lis) 0) '())
    (else (map abs lis))
    )
  )
    
; test 1b
(display "Test for question 1b\n")
(absall2 '(1 -1 2 -2 3 -4 -5 -6))
(absall2 '())
(absall2 '(-100 -99999 -9 0 0))
(newline)

; 2
; Write a function multiinsertL to insert an atom to the left of the all appearances of another atom in a list.  Return the new list.
; You may assume the list provided will NOT contain sublists.
(define (multiinsertL atom1 atom2 lis)
  (cond
    ((null? lis) '())
    ((eq? (car lis) atom2) (cons atom1 (cons atom2 (multiinsertL atom1 atom2 (cdr lis)))))
    (else (cons (car lis) (multiinsertL atom1 atom2 (cdr lis))))
   )
  )

; test 2
(display "Test for question 2\n")
(multiinsertL '1 '2 '(3 3 3 3 2 3 3 4 5 5 2))
(multiinsertL 'a 'b '(b c b z b))
(newline)

; 3
; Write a function called removeAllDeep to remove all occurences of an atom from a list, even if the atoms are within sublists.  So, for this function we are not assuming that we are only dealing with a list of atoms.  The list may be a list of atoms and sublists and the sublists can have atoms and ; sublists and so on (with no limit to the depth of the nesting.)
(define (removeAllDeep atom lis)
  (cond
    ((null? lis) '())
    ((= (length lis) 0) '())
    ((list? (car lis)) (cons (removeAllDeep atom (car lis)) (removeAllDeep atom (cdr lis))))
    (else (if(eq? (car lis) atom) (removeAllDeep atom (cdr lis)) (cons (car lis) (removeAllDeep atom (cdr lis)))))
    )
  )

; test 3
(display "Test for question 3\n")
(removeAllDeep 'a '((a b c) (d a f) (g h (i a)) x a (a)))
(removeAllDeep 'b '((a b c) (d a f) (g h (i a)) x a (a)))
(removeAllDeep 'c '((a b c) (d a f) (g h (i a)) x a (a)))
(newline)

; 4
; Write a function named join2Lists that takes in 2 lists as parameters and results in 1 list
; with the elements of the first list appearing before the elements of the second lis.  Write it
; using recursion.  You may assume the lists provided will NOT contain sublists.
(define (join2Lists lis1 lis2)
  (cond
    ((null? lis1) lis2)
    ((null? lis2) lis1)
    ((= (length lis1) 0) lis2)
    ((= (length lis2) 0) lis1)
    (else (cons (car lis1) (join2Lists (cdr lis1) lis2)))
   )
  )

; test 4
(display "Test for question 4\n")
(join2Lists '(a b c) '(d e f))
(join2Lists '(1 2) '(m n d))
(newline)

; 5
; Write a function to create a list of dotted pairs from user input.  
; Then write another function that asks for the user to input a key and the program will search an associative list for pair that has that key and returns the value associated with that key.  
; Then write a program named enterAndSearch that does both of those, 1 after the other, where the search is performed on the list entered in the first part.
(define (compose-dotted-pair key value)
  (cond
    ((null? key) (begin
                  (display "Please enter the first value in your pair or 'q' to stop inputting:\n")
                  (let ((input (read)))
                    (if (eq? input 'q) '() (compose-dotted-pair input value))
                    )))
    ((null? value) (begin
                    (display "Please enter the second value in your pair. If you enter 'q', it would be treated as an actual value. There's no command to exit at this point.\n")
                    (let ((input (read)))
                      (cons (cons key input) (compose-dotted-pair '() '()))
                      )))
    )
  )

(define (search-dotted-pair key list-dotted-pair)
  (cond
    ((null? key) '())
    ((eq? #f (assoc key list-dotted-pair)) #f)
    (else (cdr (assoc key list-dotted-pair)))
    )
  )

(define (search-input lis)
  (begin
    (display "You currently have the following list of dotted pairs:\n")
    (display lis)
    (newline)
    (display "Please enter a key you want to search for:\n")
    (let ((input (read)))
      (display "You have entered the following key to search for: ")
      (display input)
      (newline)
      (display "The value returned is: ")
      (if (eq? #f (search-dotted-pair input lis)) (display "Not Found") (display (search-dotted-pair input lis)))
      (newline))
   )
  )

(define (enterAndSearch)
  (begin
   (let ((lis (compose-dotted-pair '() '())))
     (search-input lis))
   )
  )

; test 5
(display "Test for question 5\n")
;(compose-dotted-pair '() '()) ; this line test the part of composing a list of dotted pairs
(enterAndSearch)
(newline)
  
; 6
; create a function named last that has one required parm 
; (a list)
; and one optional parm (a number)
; if last is called with a list alone, it returns the last 
; element of the list
; otherwise last returns a list of the last number elements of 
; the list
(define (last lis . optional)
  (cond
    ((null? optional) (cond
                        ((null? lis) lis)
                        ((= (length lis) 1) (car lis))
                        (else (last (cdr lis)))))
    (else (cond
            ((null? lis) lis)
            ((= (car optional) (length lis)) lis)
            (else (last (cdr lis) (car optional))
            ))
          )
  )
)

; test 6
(display "Test for question 6\n")
(last '(a b c d))
(last '(a b c d) 10)
(last '(a b c d) 1)
(last '(a b c d) 3)
(newline)

; 7
; Write a function to add all the corresponding numbers in two lists and return the resulting list.  
; If the lists have unequal length, then the resulting list should have the rest of the larger list appended to it.
(define (fun3 lis1 lis2)
  (cond
    ((null? lis1) lis2)
    ((null? lis2) lis1)
    (else (sum lis1 lis2))
    )
  )

(define (sum lis1 lis2)
  (cond
    ((= (length lis1) 0) lis2)
    ((= (length lis2) 0) lis1)
    (else (cons (+ (car lis1) (car lis2)) (sum (cdr lis1) (cdr lis2))))
    )
  )

; test 7
(display "Test for question 7\n")
(fun3 '(4 5 6) '(7 8 9))
(fun3 '(4 5 6) '(7 8 9 55 67))
(fun3 '(4 5 6 31) '(7 8 9))
(fun3 '() '(7 8 9))
(fun3 '(7 8 9 55 67) '())
(newline)

; 9
; Write out the code to get the atom i to be returned
; For the following list:
;   '((a b c (q r s)) (t t) (d e f) (g (h i) j) (y z))
(display "Code for question 9\n")
(define (get-i lis)
  (car (cdr (car (cdr (car (cdr (cdr (cdr lis))))))))
  )
(get-i '((a b c (q r s)) (t t) (d e f) (g (h i) j) (y z)))
(newline)

; 10
; write a Scheme program called odd-list that takes one 
; parameter
; which is a number (real or integer) and returns a list 
; containing all the
; non-negative odd integers strictly less than that number in 
; increasing
; order. Use recursion, not iteration.
(define (odd-list num)
  (cond
    ((< num 0) '())
    ((= num 0) '())
    ((integer? num) (get-odd-list 1 num))
    ((real? num) (get-odd-list 1 (floor num)))
    (else '())
   )
  )

(define (get-odd-list curr ceil)
  (cond
    ((>= curr ceil) '())
    (else (cons curr (get-odd-list (+ curr 2) ceil)))
    )
  )
 
; test 10
(display "Test for question 10\n")
(odd-list 0)   ;should return ()
(odd-list 1)   ;should return ()
(odd-list 2)   ;should return (1)
(odd-list 3)   ;should return (1)
(odd-list 4)   ;should return (1 3)
(odd-list 5)   ;should return (1 3)
(odd-list 6)   ;should return (1 3 5)
(odd-list 7.2) ;should return (1 3 5 7)
(odd-list -3)  ;should return ()
(newline)

; 11
; Write a program that determines the value of a Blackjack hand.  
; The cards can be represented using the symbols below:
;
; ace two three four five six seven eight nine ten jack queen 
; king 
;
; aces are worth 1 or 11, jacks queens and kings are worth 10, 
; everything else is worth its own number value.
; create an association list (a list of the dotted lists we 
; covered) 
; to match the card names with the values which are
;
; 1 2 3 4 5 6 7 8 9 10 10 10 10
; but ace can be 1 or 11 (handle that any way you like)
; 
; you must have a function that computes the value of a hand
; by taking in a hand as a list (of any length) like:
;
; (jack three five)
; 
; and in this case should return the value 18.
;
; when the hand has one ace:
;    count it as 11 as long as the whole hand value is 21 or 
; less
;    count it as 1 otherwise
;
; when the hand has more than one ace:
;    only one of the aces can count as either 11 or 1, all other 
; aces
;    must count as 1
;    (since 11+11 is 22 which is > 21, clearly a maximum of one 
; ace 
;     can be counted as 11.)
;    so, count one ace as 11 and all others as 1 if the whole 
; hand 
;    value is 21 or less
;    however, if that results in a whole hand value of 22 or 
; more, then count all aces as 1
(define cardvalues '((ace . 1)(two . 2)(three . 3)(four . 4)(five . 5)(six . 6)(seven . 7)(eight . 8)(nine . 9)(ten . 10)(jack . 10)(queen . 10)(king . 10)))

(define (get-value card)
  (cdr (assoc card cardvalues))
  )

(define (compute-values lis)
  (cond
    ((null? lis) 0)
    (else (calculate 0 lis #f))
   )
 )

(define (calculate curr lis has-ace)
  (cond
    ((= (length lis) 0) (if(and (eq? has-ace #t) (<= (+ curr 10) 21)) (+ curr 10) curr))
    ((= (get-value (car lis)) 1) (calculate (+ 1 curr) (cdr lis) #t))
    (else (calculate (+ curr (get-value (car lis))) (cdr lis) (or has-ace #f)))
    )
  )

; test 11
(display "Test for question 11\n")
(compute-values '(ace two ace five)) ; 19
(compute-values '(jack three five))  ; 18
(compute-values '(ten ace))          ; 21
(compute-values '(ace five ace ten)) ; 17
(compute-values '(five jack ace))    ; 16
(compute-values '(ace ace ace ace ace ace ace ace ace ace ace ace)) ; 12
(newline)

; 12
; use the function(s) you
; created above and add more function(s) to 
; create a complete program that does the following:
;
; read in a 2 card blackjack hand from the user 
; 
; then read the following from the user:
;
;  if the user enters another card, add it to the list of
; cards in the hand and compute and print the new value and
; display the hand.
;  if the user enters the word stay, then end the program.
;
; allow the user to enter more cards until 
;  either the total is greater than 21 
;  or the user entered the word stay
(define (input-hand card-number)
    (cond
      ((= card-number 1) (begin
                           (display "Please enter a blackjack hand:\n")
                           (let ((card (read)))
                           (add-to-lis card)
                           (input-hand 2))))
      ((= card-number 2) (begin
                           (let ((card (read)))
                           (add-to-lis card)
                           (display "You have entered two cards. Your current score is: ")
                           (display (compute-values list-card))
                           (newline)
                           (add-card))))
      (else (display "Something went wrong, you should not be here.\n"))
      )
    )

        
(define (add-card)
  (display "Enter another card or stay to exit:\n ")
  (let ((card (read)))
    (if (equal? card 'stay)
	(begin
          (display "Your score is: ")
          (display (compute-values list-card))
          (newline)
          )
	(begin
	 (add-to-lis card)
         (display (compute-values list-card))
         (newline)
         (if(<= (compute-values list-card) 21)
            (add-card)
            (begin
              (display "You have exceeded the maximum score of 21. Your score is: ")
              (compute-values list-card)))
	))))

(define list-card '())

(define (add-to-lis card)
  (begin
    (set! list-card (cons card list-card))
    (display list-card)
    (newline)
  )
 )
   
; test 12
(display "Test for question 12\n")
(input-hand 1)
(newline)


; 13
; use the function(s) you
; created above and add more function(s) to 
; create a complete program that does the following:
;
; read in a 2 card blackjack hand from the user 
; 
; then suggest to the user whether s/he should hit or stay
; (output "hit" if the total is 16 or less, output "stay" 
; otherwise)
;
; regardless of what your program suggests to the player,
; the user may enter another card or enter stay and it should 
; act 
; just like in problem 12, except after each added card, suggest 
; whether
; or not to hit/stay.
(define (suggestion value)
  (if(< value 16) (display "It is suggested that you HIT\n") (display "It is suggest that you STAY\n"))
  )

(define list-card '())

(define (add-card-2)
  (display "Enter another card or stay to exit:\n ")
  (let ((card (read)))
    (if (equal? card 'stay)
	(begin
          (display "Your score is: ")
          (display (compute-values list-card))
          (newline)
          )
	(begin
         (add-to-lis card)
         (display (compute-values list-card))
         (newline)
         (suggestion (compute-values list-card))
         (if(<= (compute-values list-card) 21)
            (add-card-2)
            (begin
              (display "You have exceeded the maximum score of 21. Your score is: ")
              (compute-values list-card)))
	))))

(define (input-hand-2 card-number)
    (cond
      ((= card-number 1) (begin
                           (display "Please enter a blackjack hand:\n")
                           (let ((card (read)))
                             (add-to-lis card)
                             (input-hand-2 2))))
      ((= card-number 2) (begin
                           (let ((card (read)))
                             (add-to-lis card)
                             (display "You have entered two cards. Your current score is: ")
                             (display (compute-values list-card))
                             (newline)
                             (suggestion (compute-values list-card))
                             (newline)
                             (add-card-2))))
      (else (display "Something went wrong, you should not be here.\n"))
      )
    )

; test 13
(display "Test for question 13\n")
(input-hand-2 1)