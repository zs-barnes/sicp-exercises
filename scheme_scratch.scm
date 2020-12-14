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