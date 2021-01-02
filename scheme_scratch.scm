(define (search f neg-point pos-point)
  (let ((midpoint (average neg-point pos-point)))
    (if (close-enough? neg-point pos-point)
        midpoint
        (let ((test-value (f midpoint)))
          (cond ((positive? test-value)
                 (search f neg-point midpoint))
                ((negative? test-value)
                 (search f midpoint pos-point))
                (else midpoint))))))

(define (close-enough? x y)
  (< (abs (- x y)) 0.001))

(define (average a b) (/ (+ a b) 2))



(define tolerance 0.00001)
(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (try guess)
    (let ((next (f guess)))
      (if (close-enough? guess next)
          next
          (try next))))
  (try first-guess))

(define (golden x)
  (fixed-point (lambda (x) (+ 1 (/ 1 x))) 1.0))

(define tolerance 0.00001)
(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (try guess)
    (let ((next (f guess)))
    (newline)
    (display next)
      (if (close-enough? guess next)
          next
          (try next))))
  (try first-guess))

(fixed-point (lambda (x) (/ (log 1000) (log x))) 10)
((fixed-point (lambda (x) (average (/ (log 1000) (log x)) (log x))) 10)
(fixed-point (lambda (x) (average (/ (log 1000) (log x)) x))) 2)
(fixed-point (lambda (x) (average (/ (log 1000) (log x)) x)) 2)
(fixed-point (lambda (x) (/ (log 1000) (log x))) 2)
(fixed-point (lambda (x) (average (/ (log 1000) (log x)) x) 2))
(define (average x y)
  (/ (+ x y) 2))

(define (cont-frac n d k)
  (define (cont-frac-iter n d k i)
    (if (> i k)
      0
      (/ (n i) (+ (d i) (cont-frac-iter n d k (+ i 1))))))
  (cont-frac-iter n d k 1))

(/ 1 (cont-frac (lambda (i) 1) (lambda (i) 1) 100))

(/ 1.0 (cont-frac (lambda (i) 1) (lambda (i) 1) 14))

(define (cont-frac n d k)
  (define (cont-frac-iter n d k result)
    (if (= k 0)
      result
      (cont-frac-iter n d (- k 1) (/ (n k) (+ result (d k))))
      
    )
  (cont-frac-iter n d k 0))
)

(/ 1.0 (cont-frac (lambda (i) 1) (lambda (i) 1) 13))
(/ 1.0 (cont-frac (lambda (i) 1) (lambda (i) 1) 14))
(/ 1.0 (cont-frac (lambda (i) 1) (lambda (i) 1) 11))


(define (cont-frac n d k)
  (define (cont-frac-iter n d k result)
    (if (= k 0)
    result
    (cont-frac-iter n d (- k 1) (/ (n k) (+ result (d k))))))
  (cont-frac-iter n d k 0))
  
(define (d-func i)
  (cond ((< i 3) i)
        ((or (= 0 (remainder i 3)) (= 1 (remainder i 3))) 1)
        (else (- i (/ (- i 2) 3)))))


(define (d-func-iter i k)
  (newline)
  (display (d-func i))
  (if (= i k)
    (display "done")
    (d-func-iter (+ i 1) k)))
(d-func-iter 1 14)
(+ (cont-frac (lambda (i) 1) d-func 10) 2.0)

(define (tan-cf x k)
  (define (cont-frac n d k)
    (define (cont-frac-iter n d k i)
      (if (> i k)
        0
        (/ (n x i) (- (d i) (cont-frac-iter n d k (+ i 1))))))
    (cont-frac-iter n d k 1))
  (define (n-func x i)
    (if (= i 1)
      x
      (square x)))
  (cont-frac n-func (lambda (i) (- (* 2 i) 1)) k))


# decouple 

(define (cont-frac n d k x)
  (define (cont-frac-iter n d k result)
    (if (= k 0)
    result
    (cont-frac-iter n d (- k 1) (/ (n k) (- (d x k) result)))))
  (cont-frac-iter n d k 0))

(define (d-func x i)
  (if (= i 1)
    x
    (square x)))

(define (tan-cf x k)
(cont-frac (lambda (i) (- (* 2 i) 1)) d-func k x ))

(define (odds i)
(- (* 2 i) 1))

(define (newton-transform g)
  (lambda (x)
    (- x (/ (g x) ((deriv g) x)))))

(define (newtons-method g guess)
  (fixed-point (newton-transform g) guess))

  (define (cubic a b c)
    (lambda (x) (+ (* x x x) (* a (square x)) (* b x) c)))

(newtons-method (cubic 3 (- 6) (- 18)) 1)

(define (double f)
  (lambda (x) (f (f x))))
(define (inc x) (+ x 1))
(((double double) inc) 1)
(((double (double (double double))) inc) 5)

(define (compose f g)
  (lambda (x) (f (g x))))



((compose square inc) 5)

(define (repeated orig-func n)
  (define (repeated-iter nested-func i)
    (if (= i n)
      nested-func
      (repeated-iter (compose orig-func nested-func) (+ i 1))))
  (repeated-iter orig-func 1))

(define (repeated f n)
  (define (repeated-iter f i)
    (if (= i n)
      f
      (repeated-iter (compose f f) (+ i 1))))
  (repeated-iter f 1))

(define (repeated f n)
  (if (= n 1)
      f
    (repeated (compose f f) (- n 1))
  )
)

((repeated square 3) 5)
((repeated square 2) 5)

(square 5)
(square (square 5))
(square (square (square 5)))

(define (repeated f n)
(cond ((= n 1) (lambda (x) (f x)))
      ((= n 2) (lambda (x) (f(f x))))
      ((= n 3) (lambda (x) (f(f(f x)))))  
)
)

((compose square (compose square square)) 5)

(define (repeated f n)
 (lambda (x) ((compose f (compose f f)) x) ))

(define dx 0.00001)

(define (smooth f)
  (lambda (x) (/ (+ (f (- x dx)) (f x) (f (+ x dx))) 3)))

(define (n-fold-smooth f n)
  ((repeated smooth n) f))

((smooth (smooth square)) 4)
((smooth (smooth (smooth square)) 4))

((n-fold-smooth square 3) 4)

(define (average-damp f)
  (lambda (x) (average x (f x))))

(define (sqrt x)
  (fixed-point (average-damp (lambda (y) (/ x y)))
               1.0))



(define (nth-root x n)
  (fixed-point ((repeated average-damp avg-count)(lambda (y) (/ x (expt y (- n 1))))) 1.0)
)

(define (nth-root x n)
  (define (compute-fixed-point avg-count)
    (fixed-point ((repeated average-damp avg-count)(lambda (y) (/ x (expt y (- n 1))))) 1.0))
  (define (nth-root-iter x n pow-two)
    (if (< n (expt 2 pow-two)) 
        (compute-fixed-point (- pow-two 1))
        (nth-root-iter x n (+ pow-two 1))) 
  )
  (nth-root-iter x n 2)
)

(define (nth-root x n)
  (define (nth-root-iter x n pow-two)
    (if (< n (expt 2 pow-two)) 
        (fixed-point ((repeated average-damp (- pow-two 1))
                      (lambda (y) (/ x (expt y (- n 1))))) 1.0)
        (nth-root-iter x n (+ pow-two 1))))
  (nth-root-iter x n 2))


; 1, 2, 3
(nth-root 8 3)
; 2, 3, not 1
(nth-root 16 4)
; 2, 3, not 1
(nth-root 32 5)
; 1, 2, 3 
(nth-root 64 6)
; 1, 2, 3 
(nth-root (expt 2 7) 7)
; 1, 3, not 2
(nth-root (expt 2 8) 8)
; 1, 3, not 2
(nth-root (expt 2 9) 9)
; 1, 3, not 2  
(nth-root (expt 2 10) 10)
; 1, 3, not 2 
(nth-root (expt 2 11) 11)
; 1, 2, 3
(nth-root (expt 2 12) 12)
; 3, not 1 or 2
(nth-root (expt 2 13) 13)
; 1, 3, not 2 
(nth-root (expt 2 14) 14)
; 1, 2, 3
(nth-root (expt 2 15) 15)
; 1, 2, 4 not 3
(nth-root (expt 2 16) 16)
; 1, 4 not 2, 3
(nth-root (expt 2 17) 17)
; 1, 2, 4 not 3
(nth-root (expt 2 18) 18)
; 1, 2, 4 not 3
(nth-root (expt 2 19) 19)
; 1, 2, 4 not 3
(nth-root (expt 2 20) 20)
; 1, 2, 4 not 3
(nth-root (expt 2 21) 21)
; 1, 2, 4 not 3
(nth-root (expt 2 22) 22)
; 4
(nth-root (expt 2 31) 31)
; 5
(nth-root (expt 2 32) 32)

4:2
8:3
16:4
32:5

(define (iter-improve improve-guess good-guess)
(if ))
; We want to be able to do:
((iter-improve fixed-point good-enough?) 1.0)

(define (iterative-improve improve-guess good-enough?)
  (define (try guess)
    (let ((next (improve-guess guess)))
      (if (good-enough? guess next)
          next
          (try next))))
    (lambda (x) (try x)))

(define tolerance 0.00001)
(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  ((iterative-improve f close-enough?) first-guess))

(define (sqrt x)
  (fixed-point (lambda (y) (average y (/ x y)))
               1.0))

 (define (product term a next b)
  (if (> a b)
      1
      (* (term a)
         (product term (next a) next b))))

(define (pi n)
  (define (numerator-term x)
    (if (= x 2)
    x
    (* x x)))
  (define (next x)
    (+ x 2))
  (define (denominator-term x)
  (* x x))

)

(define (make-rat n d)
  (let ((g (gcd n d)))
    (cons (/ n g) (/ d g))))

(define (make-rat n d)
  (let ((g (abs(gcd n d))))
    (cond ((or (and (> n 0) (< d 0)) (and (< n 0) (< d 0))) 
            (cons (/ (* n -1) g) (/ (* d -1) g)))
          (else (cons (/ n g) (/ d g))))))

(define (make-rat n d)
  (let ((g (abs(gcd n d))))
    (if (or (and (> n 0) (< d 0)) (and (< n 0) (< d 0))) 
        (cons (/ (* n -1) g) (/ (* d -1) g))
        (cons (/ n g) (/ d g)))))



(define (make-rat n d)
  (let ((g (abs(gcd n d))))
    (cond ((or ((and (> n 0) (< d 0)) (and (< n 0) (< d 0))) (cons (/ (* n -1) g) (/ (* d -1) g)))
          (else (cons (/ n g) (/ d g))))))

(make-rat 4 -8)
(make-rat -4 -8)

(define (make-segment p1 p2) (cons p1 p2))
(define (start-segment s) (car s))
(define (end-segment s) (cdr s))
(define (make-point x y) (cons x y))
(define (x-point p) (car p))
(define (y-point p) (cdr p))
(define (average x y) (/ (+ x y) 2))
(define (midpoint-segment s) 
  (let ((x1 (x-point (start-segment s)))
        (x2 (x-point (end-segment s)))
        (y1 (y-point (start-segment s)))
        (y2 (y-point (end-segment s))))
        (make-point (average x1 x2) (average y1 y2))))

(define (print-point p)
  (newline)
  (display "(")
  (display (x-point p)) 
  (display ",")
  (display (y-point p))
  (display ")"))

(define point-1 (make-point -1 2))
(define point-2 (make-point 3 -6))
(define segment (make-segment point-1 point-2))
(midpoint-segment segment)

(define (make-rect s1 s2) (cons s1 s2))
(define (first-rect-seg rect) (car rect))
(define (second-rect-seg rect) (cdr rect))

(define point-1 (make-point 0 0))
(define point-2 (make-point 0 3))
(define seg-1 (make-segment point-1 point-2))

(define point-1 (make-point 0 0))
(define point-2 (make-point 0 4))
(define seg-2 (make-segment point-1 point-2))

(define my-rect (make-rect seg-1 seg-2))

(perimeter my-rect)
(area my-rect)

(define (seg-length s)
  (let ((x1 (x-point (start-segment s)))
        (x2 (x-point (end-segment s)))
        (y1 (y-point (start-segment s)))
        (y2 (y-point (end-segment s))))
    (sqrt (+ (square (- x2 x1))
             (square (- y2 y1))))))

(define (perimeter rect)
  (let ((s1 (first-rect-seg rect))
        (s2 (second-rect-seg rect)))
    (+ (* 2 (seg-length s1)) (* 2 (seg-length s2)))))

(define (area rect)
  (let ((s1 (first-rect-seg rect))
        (s2 (second-rect-seg rect)))
        (* (seg-length s1) (seg-length s2))))

; Second representation

(define (make-rect p1 p2 p3 p4) 
  (cons (cons p1 p2) (cons p2 p3)) (cons (cons p3 p4) (cons p4 p1)))

(define (first-rect-seg rect) 
  (make-segment (car (car rect)) (cdr (car rect))))

(define (second-rect-seg rect) (cdr rect)
  (make-segment (car (cdr rect)) (cdr (cdr rect))))

(define point-1 (make-point 0 0))
(define point-2 (make-point 0 4))
(define point-3 (make-point 5 4))
(define point-4 (make-point 5 0))

(define my-rect (make-rect point-1 point-2 point-3 point-4))

(perimeter my-rect)
(area my-rect)

(x-point (start-segment (first-rect-seg my-rect)))

(define (cdr z)
  (z (lambda (p q) q)))

(define (cons a b)
(* (expt 2 a) (expt 3 b)))

(define (car x)
  (count-divisions 2 x))

(define (cdr x)
  (count-divisions 3 x))

(define (count-divisions b x)
(if (= (remainder x b) 0)
    (+ 1 (count-divisions b (/ x b)))
    0))

(define zero (lambda (f) (lambda (x) x)))

(define (add-1 n)
  (lambda (f) (lambda (x) (f ((n f) x)))))

(add-1 zero)
(lambda (f) (lambda (x) (f ((zero f) x))))
(lambda (f) (lambda (x) (f (((lambda (f) (lambda (x) x)) f) x))))
(lambda (f) (lambda (x) (f ((lambda (x) x) x))))
(lambda (f) (lambda (x) (f x)))


(define one (lambda (f) (lambda (x) (f x))))

(add-1 two)
(lambda (f) (lambda (x) (f ((one f) x))))
(lambda (f) (lambda (x) (f (((lambda (f) (lambda (x) (f x))) f) x))))
(lambda (f) (lambda (x) (f ((lambda (x) (f x)) x))))
(lambda (f) (lambda (x) (f (f x))))

(define two (lambda (f) (lambda (x) (f (f x)))))

(define (+ m n)
  (lambda (m) (lambda (n) (lambda (f) (lambda (x) (f (n (f x))))))))

  (define (make-interval a b) (cons a b))
  (define (lower-bound interval) (car interval))
  (define (upper-bound interval) (cdr interval))

(define (sub-interval x y)
  (make-interval (- (lower-bound x) (lower-bound y)) 
                 (- (upper-bound x) (upper-bound y))))

(define (sub-interval x y)
  (let ((p1 (- (lower-bound x) (lower-bound y)))
        (p2 (- (lower-bound x) (upper-bound y)))
        (p3 (- (upper-bound x) (lower-bound y)))
        (p4 (- (upper-bound x) (upper-bound y))))
    (make-interval (min p1 p2 p3 p4)
                   (max p1 p2 p3 p4))))

(define (div-interval x y)
  (if (or (= (upper-bound y) 0) 
          (= (lower-bound y) 0))
      (error "Divide by Zero")
      (mul-interval x 
        (make-interval (/ 1.0 (upper-bound y))
          (/ 1.0 (lower-bound y))))))

(define (make-center-percent c p)
  (make-interval (- c (* c p)) (+ c (* c p))))

(define (make-center-width c w)
  (make-interval (- c w) (+ c w)))
(define (center i)
  (/ (+ (lower-bound i) (upper-bound i)) 2))
(define (width i)
  (/ (- (upper-bound i) (lower-bound i)) 2))
                               
                  
(make-center-percent 6.8 0.1)

(define (percent i) 
  (/ (width i) (center i)))

(percent (make-center-width 6.8 0.68))

(define (mul-interval x y)
  (let ((p1 (* (lower-bound x) (lower-bound y)))
        (p2 (* (lower-bound x) (upper-bound y)))
        (p3 (* (upper-bound x) (lower-bound y)))
        (p4 (* (upper-bound x) (upper-bound y))))
    (make-interval (min p1 p2 p3 p4)
                   (max p1 p2 p3 p4))))

(define i1 (make-interval 6.12 7.48))
(define i2 (make-interval 4.456 4.935))
(define i1 (make-center-percent 6.8 0.1))
(define i2 (make-center-percent 4.7 0.05))
(percent (mul-interval i1 i2))

(define (par1 r1 r2)
  (div-interval (mul-interval r1 r2)
                (add-interval r1 r2)))
(define (par2 r1 r2)
  (let ((one (make-interval 1 1))) 
    (div-interval one
                  (add-interval (div-interval one r1)
                                (div-interval one r2)))))

(par1 i1 i2)

(define i1 (make-center-percent 100 0.0001))
(define i2 (make-center-percent 50 0.001))

(define i1 (make-interval 999 1001))

(define (list-ref l n)
  (if (= n 0)
      (car l)
      (list-ref (cdr l) (- n 1))))

(define (last-pair items)
  (if (null? (cdr items))
      (car items)
      (last-pair (cdr items))))

(define (reverse items)
  (if (null? (cdr items))
      items
      (cons (last-pair items) (reverse (car items)))))

(define (length items)
  (if (null? items)
      0
      (+ 1 (length (cdr items)))))

(define (reverse items)
  (if (null? items)
      0
      (cons (reverse (cdr items)) (car items))))

(car (cdr (cdr (list 1 2 3 4))))

(define (reverse items)
  (define (reverse-iter items n)
    (if (< n 0)
        '()
        (cons (list-ref items n) (reverse-iter items (- n 1)))))
  (reverse-iter items (- (length items) 1)))

(reverse (list 1 2 3 4))

(define (no-more? values) (null? values))
(define (except-first-denomination values) (cdr values))
(define (first-denomination values) (car values))


(define us-coins (list 50 25 10 5 1))
(define uk-coins (list 100 50 20 10 5 2 1 0.5))

(define (cc amount coin-values)
  (cond ((= amount 0) 1)
        ((or (< amount 0) (no-more? coin-values)) 0)
        (else
         (+ (cc amount
                (except-first-denomination coin-values))
            (cc (- amount
                   (first-denomination coin-values))
                coin-values)))))

(define us-coins (list 1 5 10 25 50))

(define (same-parity first . items)
  (if (even? first)
      (cons first (get-parity even? items))
      (cons first (get-parity odd? items))))

(define (get-parity f items)
  (if (null? items)
      '()
      (if (f (car items))
        (cons (car items) (get-parity f (cdr items)))
        (get-parity f (cdr items))))))

(same-parity 1 2 3 4 5 6 7)
(same-parity 2 3 4 5 6 7)

(define (par f items)
  (if (f (car items))
      (car items)
      (cdr items)))


(define (map proc items)
  (if (null? items)
      '()
      (cons (proc (car items)) 
            (map proc (cdr items)))))

(define (square-list items)
  (if (null? items)
      nil
      (cons (square (car items)) (square-list (cdr items)))))

(define (square-list items)
  (map (lambda (x) (square x)) items))

(define (square-list items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things) 
              (cons (square (car things))
                    answer))))
  (iter items nil))

(define (square-list items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things) 
              (cons (square (car things))
                    answer))))
  (iter items nil))

  (square-list (list 1 2 3))
  (iter (list 1 2 3) nil)
  (iter (cdr (list 1 2 3)) (cons (square (car (list 1 2 3))) nil))
  (iter (cdr (list 2 3)) (cons (square (car (list 2 3))) (list 1)))
  (iter (cdr (list 3)) (cons (square (car (list 3))) (cons 4 (list 1))))

(define (square-list items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things)
              (cons answer
                    (square (car things))))))
  (iter items nil))

(square-list (list 1 2 3))
(iter (list 1 2 3) nil)
(iter (cdr (list 1 2 3)) (cons nil (square (car (list 1 2 3)))))
(iter (cdr (list 2 3)) (cons (list () 1) (square (car (list 2 3)))))
(iter (cdr (list 3)) (cons (cons (list () 1) 4) (square (car (list 3)))))


(define (reverse items)
  (define (reverse-iter items answer)
    (if (null? items)
        answer
        (reverse-iter (cdr items) (cons (car items) answer))))
(reverse-iter items '()))


(define (for-each proc items)
  (do-proc proc items)
  (if (null? items)
      true
      (for-each proc (cdr items))))

(define (do-proc proc items)
  (if (null? items)
      true
      (proc (car items))))

(cdr (1 3 (5 7) 9))

(list 1 2 (list 5 7) 9)
(cdr (car (cdr (cdr (list 1 2 (list 5 7) 9) ))))
((7))

(1 (2 (3 (4 (5 (6 7))))))

(car (car (list (list 7))))

(define long-list (list 1 (list 2 (list 3 (list 4 (list 5 (list 6 7)))))))
(cadr (cadr (cadr (cadr (cadr (cadr long-list))))))

((2 (3 (4 (5 (6 7))))))

(define (reverse items)
  (define (reverse-iter items answer)
    (if (null? items)
        answer
        (reverse-iter (cdr items) (cons (car items) answer))))
(reverse-iter items '()))

(define (reverse items)
  (define (reverse-iter items answer)
    (cond ((null? items) answer)
          ((not (pair? items)) ())
          (else (reverse-iter (cdr items) (cons (car items) answer)))))
(reverse-iter items '()))

(define (deep-reverse items)
  (cond ((null? items) '())
        ((not (pair? items)) items)
        (else (append (deep-reverse (cdr items)) 
                      (list (deep-reverse (car items)))))))


(list (deep-reverse (car (1 2))))
(list (deep-reverse (car (1 2))))
(list 1)

(define (reverse items)
  (if (null? items)
      '()
      (cons (reverse (cdr items)) (list (car items)))))

(define (fringe items)
  (cond ((null? items) '())
        ((not (pair? items)) (list items))
        (else (append (fringe (car items)) (fringe (cdr items))))))

(fringe x)

(define (left-branch mobile)
  (car mobile))

(define (right-branch mobile)
  (cadr mobile))

(define (branch-length structure)
  (car structure))

(define (branch-structure structure)
  (cadr structure))

(right-branch (make-mobile (make-branch 1 2) (make-branch 2 3)))

(define (total-weight mobile)
  (cond ((not (pair? mobile)) mobile)
        ((not (pair? (branch-length mobile))) (total-weight (branch-structure mobile)))
        (else (+ (total-weight (left-branch mobile))
                 (total-weight (right-branch mobile))))))

(define m (make-mobile (make-branch 1 4) (make-branch 2 5)))
(define m2 (make-mobile (make-branch 2 m) (make-branch 1 m)))
(total-weight (make-mobile (make-branch 1 2) (make-branch 2 3)))
(right-branch m2)
(total-weight m2)
(total-weight m)

(left-branch (branch-structure m))
(branch-structure (right-branch (branch-structure (right-branch m2))))
(branch-structure (left-branch m2))

(define (torque mobile)
  (cond ((not (pair? mobile)) mobile)
        ((not (pair? (branch-length mobile))) (* (branch-length mobile) 
                                                 (torque (branch-structure mobile))))
        (else (+ (torque (left-branch mobile))
                 (torque (right-branch mobile))))))

(define (balanced mobile)
  (if (not (pair? (branch-length mobile))) 
      (torque mobile)
      (= (balanced (left-branch mobile)) 
          (balanced (right-branch mobile)))))


(torque m2)
(balanced m)

(define m (make-mobile (make-branch 2 4) (make-branch 1 8)))
(define m1 (make-mobile (make-branch 3 2) (make-branch 2 3)))
(define m2 (make-mobile (make-branch 1 m1) (make-branch 1 m)))
(define m3 (make-mobile (make-branch 6 m) (make-branch 7 m1)))


(define (make-mobile left right)
  (cons left right))
(define (make-branch length structure)
  (cons length structure))

(define (left-branch mobile)
  (car mobile))

(define (right-branch mobile)
  (cdr mobile))

(define (branch-length structure)
  (car structure))

(define (branch-structure structure)
  (cdr structure))

(square-tree
 (list 1
       (list 2 (list 3 4) 5)
       (list 6 7)))

(define l (list 1
       (list 2 (list 3 4) 5)
       (list 6 7)))

(define (square-tree items)
  (cond ((null? items) '())
        ((not (pair? items)) (square items))
        (else (cons (square-tree (car items))
                    (square-tree (cdr items))))))

(define (map proc items)
  (if (null? items) 
      '()
      (cons (proc (car items)) 
            (map proc (cdr items)))))

(define (tree-map proc items)
  (map (lambda (sub-tree) 
              (if (pair? sub-tree)
                  (tree-map proc sub-tree)
                  (proc sub-tree))) 
        items))

(define (square-tree items)
  (tree-map square items))

(define (subsets s)
  (if (null? s)
      (list nil)
      (let ((rest (subsets (cdr s))))
        (append rest (map (lambda (x) (if (null? x)  s (list (car s)))) rest)))))

(subsets (list 1 2 3 4 5 6))
(subsets (list 1 2 3))
(subsets (list 1 2))
(rest (subsets (cdr (list 1))))
(rest (subsets '()))
(rest )

(define (subsets s)
  (if (null? s)
      (list nil)
      (let ((rest (subsets (cdr s))))
        (append rest (map (lambda (x) (cons (car s) x)) rest)))))

(define (map p sequence)
  (accumulate (lambda (x y) (cons (p x) y)) nil sequence))

(define (append seq1 seq2)
  (accumulate cons seq2 seq1))

(define (length sequence)
  (accumulate (lambda (x y) (+ 1 y)) 0 sequence))

(define (accumulate op initial seq)
  (if (null? seq)
      initial
      (op (car seq) (accumulate op initial (cdr seq)))))
(accumulate * 1 (list 1 2 3))

(map square (list 1 2 3))
(append (list 1 2 3) (list 4 5 6))
(length (list 1 2 3))

(op (car seq) (accumulate op initial (cdr seq)))
(op 1 (accumulate op initial (cdr seq)))
(op 1 (op 2 (0)))
(+ 1 (+ 1 0))

(define (horner-eval x coefficient-sequence)
  (accumulate (lambda (this-coeff higher-terms) (+ this-coeff (* x higher-terms)))
              0
              coefficient-sequence))

(horner-eval 2 (list 1 3 0 5 0 1))

(define (count-leaves x)
  (cond ((null? x) 0)  
        ((not (pair? x)) 1)
        (else (+ (count-leaves (car x))
                 (count-leaves (cdr x))))))

(define (enumerate-tree tree)
  (cond ((null? tree) nil)
        ((not (pair? tree)) (list tree))
        (else (append (enumerate-tree (car tree))
                      (enumerate-tree (cdr tree))))))

(define (count-leaves t)
  (accumulate (lambda (x y) (+ 1 y)) 0 (enumerate-tree t)))

(define tree (cons (list 1 2) (list 3 4)))

(count-leaves tree)
(count-leaves (list tree tree))

(define (accumulate-n op init seqs)
  (if (null? (car seqs))
      nil
      (cons (accumulate op init (map (lambda (seq) (car seq)) seqs))
            (accumulate-n op init (map (lambda (seq) (cdr seq)) seqs)))))

(define s  (list (list 1 2 3) (list 4 5 6) (list 7 8 9) (list 10 11 12)))
(accumulate-n + 0 s)

(accumulate + 0 (map (lambda (seq) (car seq)) s))
(map (lambda (seq) (cdr seq)) s)

(define (accumulate op initial seq)
  (if (null? seq)
      initial
      (op (car seq) (accumulate op initial (cdr seq)))))

(define (dot-product v w)
  (accumulate + 0 (map * v w)))

(define (matrix-*-vector m v)
  (map2 (lambda (row) (dot-product v row)) m))

(define (transpose mat)
  (accumulate-n cons '() mat))

(define (matrix-*-matrix m n)
  (let ((cols (transpose n)))
    (map2 (lambda (row) (matrix-*-vector cols row)) m)))

(matrix-*-matrix m m)
(matrix-*-vector (transpose m) (list 1 2 3))
(define (map2 proc items)
  (if (null? items) 
      '()
      (cons (proc (car items)) 
            (map2 proc (cdr items)))))


(define m (list (list 1 2 3) (list 4 5 6) (list 7 8 9)))
(define v (list 2 2 2 2))
(matrix-*-vector m v)

(transpose m)

(define (accumulate-n op init seqs)
  (if (null? (car seqs))
      '()
      (cons (accumulate op init (map2 (lambda (seq) (car seq)) seqs))
            (accumulate-n op init (map2 (lambda (seq) (cdr seq)) seqs)))))

