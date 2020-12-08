
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
  (let ((x1 (car (start-segment s)))
        (x2 (car (end-segment s)))
        (y1 (cdr (start-segment s)))
        (y2 (cdr (end-segment s))))
        (make-point (average x1 x2) (average y1 y2))))
```
Test:
```
(define (point-1) (make-point -1 2))
(define (point-2) (make-point 3 -6))
(define (segment) (make-segment (point-1) (point-2)))
1 ]=> (midpoint-segment (segment))

;Value: (1 . -2)
```