
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