
## Exercise 2.1 
The key to this was taking the absolute value of the gcd. 
```
(define (make-rat n d)
  (let ((g (abs(gcd n d))))
    (if (or (and (> n 0) (< d 0)) (and (< n 0) (< d 0))) 
        (cons (/ (* n -1) g) (/ (* d -1) g))
        (cons (/ n g) (/ d g)))))
```
```
1 ]=> (make-rat 4 -8)

;Value: (-1 . 2)

1 ]=> (make-rat -4 -8)

;Value: (1 . 2)

1 ]=> (make-rat -4 8)

;Value: (-1 . 2)

1 ]=> (make-rat 4 8)

;Value: (1 . 2)
```

## Exercise 2.2
This was a fun one.
```
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
```
Test:
```
(define point-1 (make-point -1 2))
(define point-2 (make-point 3 -6))
(define segment (make-segment point-1 point-2))
1 ]=> (midpoint-segment (segment))

;Value: (1 . -2)
```

## Exercise 2.3
I define a rectangle using just two segments:
```
(define (make-rect s1 s2) (cons s1 s2))
(define (first-rect-seg rect) (car rect))
(define (second-rect-seg rect) (cdr rect))
```
To calculate the perimeter and area, I first had to create `seg-length`, which implements the distance formula. 
```
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
```

Tests: 
```
(define point-1 (make-point 0 0))
(define point-2 (make-point 0 3))
(define seg-1 (make-segment point-1 point-2))

(define point-1 (make-point 0 0))
(define point-2 (make-point 4 0))
(define seg-2 (make-segment point-1 point-2))

(define my-rect (make-rect seg-1 seg-2))
```
```
1 ]=> (perimeter my-rect)

;Value: 14

1 ]=> (area my-rect)

;Value: 12
```

Here is a different underlying representation of a rectangle, which takes in four points: 
```
(define (make-rect p1 p2 p3 p4) 
  (cons (cons p1 p2) (cons p2 p3)) (cons (cons p3 p4) (cons p4 p1)))

(define (first-rect-seg rect) 
  (make-segment (car (car rect)) (cdr (car rect))))

(define (second-rect-seg rect) (cdr rect)
  (make-segment (car (cdr rect)) (cdr (cdr rect))))
```
Now, without chaning our perimeter and area functions, we can test with a new rectangle:
```
(define point-1 (make-point 0 0))
(define point-2 (make-point 0 4))
(define point-3 (make-point 5 4))
(define point-4 (make-point 5 0))
(define my-rect (make-rect point-1 point-2 point-3 point-4))


1 ]=> (perimeter my-rect)

;Value: 18

1 ]=> (area my-rect)

;Value: 20
```

## Exercise 2.4
Using the substition model, we can show this representation yields x for car:
```
(car (cons x y))
((cons x y) (lambda (p q) p))
((lambda (m) (m x y)) (lambda (p q) p))
((lambda (p q) p) x y)
x
```
cdr definition:
```
(define (cdr z)
  (z (lambda (p q) q)))
```
Substition for cdr:
```
(cdr (cons x y))
((cons x y) (lambda (p q) q))
((lambda (m) (m x y)) (lambda (p q) q))
((lambda (p q) q) x y)
y
```

## Exercise 2.5
The insight here was that we can figure out a one item in a pair from an integer by dividing by the base of that item, and count how many times until we have a remainder of 0. So basically a log with a base of 2 or 3. For example, if we constructed $2^{3} \cdot 3^{2} = 72$, where a = 3 and b = 2, and we wanted a, we would divide 72 by 2 to get 36, then again to get 18, then again to get 9, which would give a remainder of 1. Since we divided by 2 three times to reach 9, that is our exponent, a.

I've implemented this process in `count-divisions`. For `car` we use base 2, and for `cdr` we use base 3.

```
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
```
Tests:
```
1 ]=> (car (cons 82 73))

;Value: 82

1 ]=> (cdr (cons 82 73))

;Value: 73
```

## Exercise 2.6
Derivation for `one` in Church numerals using the substitution model:
```
(add-1 zero)
(lambda (f) (lambda (x) (f ((zero f) x))))
(lambda (f) (lambda (x) (f (((lambda (f) (lambda (x) x)) f) x))))
(lambda (f) (lambda (x) (f ((lambda (x) x) x))))
(lambda (f) (lambda (x) (f x)))

(define one (lambda (f) (lambda (x) (f x))))
```

Now that we have `one` we can derive `two` similarly:
```
(add-1 two)
(lambda (f) (lambda (x) (f ((one f) x))))
(lambda (f) (lambda (x) (f (((lambda (f) (lambda (x) (f x))) f) x))))
(lambda (f) (lambda (x) (f ((lambda (x) (f x)) x))))
(lambda (f) (lambda (x) (f (f x))))

(define two (lambda (f) (lambda (x) (f (f x)))))
```
These match up with the definitions given in wikipedia:

$$ 0 = \lambda f. \lambda x.x $$
$$ 1 = \lambda f.\lambda x.f\ x $$
$$ 2 = \lambda f.\lambda x.f\ (f\ x) $$

The definition of add is beyond me..
I implemented what wikipedia gave for an addition with Church numerals:
```
(define (+ m n)
  (lambda (m) (lambda (n) (lambda (f) (lambda (x) (f (n (f x))))))))
```
It seemed to do its thing:
```
1 ]=> (+ one two)

;Value: #[compound-procedure 14]
```

## Exercise 2.7
```
(define (lower-bound interval) (car interval))
(define (upper-bound interval) (cdr interval))
```

## Exercise 2.8
Subtraction is not commutative, so order matters here. 
```
(define (sub-interval x y)
  (make-interval (- (lower-bound x) (lower-bound y)) 
                 (- (upper-bound x) (upper-bound y))))
```

## Exercise 2.9
This is a boring exercise. Actually this whole section is rather boring. Interval arithmetic, really?

I'll show that width of the sum of two intervals is a function only of the widths of the intervals being added.

Let $I_{1}$ and $I_{2}$ be intervals, which have upper and lower bound of $ (L_{1}, U_{1})$ and $(L_{2}, U_{2})$ respectively. 

Then, their sum is:

$I_{1} + I_{2} = [(L_{1} + L_{2}),(U_{1} + U_{2})]$

 The width of the sum is then:

 $W(I_{1} + I_{2}) = \dfrac{(U_{1} + U_{2}) - (L_{1} + L_{2})}{2}$



Now we want to show that we can get the width of the sums by adding the widths of the intervals. 

Let $W_{1} = \dfrac{U_{1} - L{1}}{2}$ , $W_{2} = \dfrac{U_{2} - L{2}}{2}$

Then $W_{1} + W_{2} = \dfrac{U_{1} - L{1}}{2} + \dfrac{U_{2} - L{2}}{2} = \dfrac{(U_{1} - L_{1}) + (U_{2} - L_{2})}{2} $

$= \dfrac{(U_{1} + U_{2}) + (- L_{1} - L_{2})}{2} = \dfrac{(U_{1} + U_{2}) - (L_{1} + L_{2})}{2} $ 

Which is the width of summing the two intervals. 

## Exercise 2.10
```
(define (div-interval x y)
  (if (or (= (upper-bound y) 0) 
          (= (lower-bound y) 0))
      (error "Divide by Zero")
      (mul-interval x 
        (make-interval (/ 1.0 (upper-bound y))
          (/ 1.0 (lower-bound y))))))

1 ]=> (div-interval (make-interval 1 2) (make-interval 0 2))

;Divide by Zero
;To continue, call RESTART with an option number:
; (RESTART 1) => Return to read-eval-print level 1
```

## Exercise 2.11
Ben Bitdiddle: You are too cryptic for me.

## Exercise 2.12
```
(define (make-center-percent c p)
  (make-interval (- c (* c p)) (+ c (* c p))))

1 ]=> (make-center-percent 6.8 0.1)

;Value: (6.12 . 7.4799999999999995)

(define (percent i) 
  (/ (width i) (center i)))

1 ]=> (percent (make-center-width 6.8 0.68)
)

;Value: .09999999999999996
```

## Exercise 2.13
Tried to figure this out algebraically, but couldn't quite get it. Instead, I'll just give proof by with scheme that the formula is simply the addition of the tolerances of each interval:
```
(define i1 (make-center-percent 6.8 0.1))
(define i2 (make-center-percent 4.7 0.05))
1 ]=> (percent (mul-interval i1 i2))

;Value: .1492537313432836
```
The two percentages are $0.1 + 0.05 \approx 0.15$

## Exercise 2.14
It looks like par2 has tighter intervals than par1, i.e. par2 interval can usually be contained within par1.
```
1 ]=> (define i1 (make-interval 999 1001))

;Value: i1

1 ]=> (par1 i1 i1)

;Value: (498.501998001998 . 501.502002002002)

1 ]=> (par2 i1 i1)

;Value: (499.5 . 500.5)
```

## Exercise 2.15
Huh. It looks like I was sort of on the right track. Ok, this section is more interesting than I thought. From my example in 2.14, par2 produced a tighter interval. By evaluating each interval value only once, we introduce less floating point arithmetic. If variables are repeated, they contribute to increasinly less precise floating point approximations as they are used in operations together.

## Exercise 2.16
My best guess is that because of finite floating point precision, algebraically equivalent equations can produce different answers. 

## Exercise 2.17
```
(define (last-pair items)
  (if (null? (cdr items))
      (car items)
      (last-pair (cdr items))))

1 ]=> (last-pair (list 1 2 3 4))

;Value: 4
```

## Exercise 2.18
```
(define (reverse items)
  (define (reverse-iter items n)
    (if (< n 0)
        '()
        (cons (list-ref items n) (reverse-iter items (- n 1)))))
  (reverse-iter items (- (length items) 1)))

1 ]=> (reverse (list 1 2 3 4))

;Value: (4 3 2 1)
```

