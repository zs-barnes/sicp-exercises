
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