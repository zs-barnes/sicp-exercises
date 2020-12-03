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