
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
  (if (null? items)
      '()
      (append (reverse (cdr items)) (list (car items)))))
```
Iterative version:
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

Here's another iterative implementation based on seeing exercise 2.22:
```
(define (reverse items)
  (define (reverse-iter items answer)
    (if (null? items)
        answer
        (reverse-iter (cdr items) (cons (car items) answer))))
(reverse-iter items '()))
```

## Exercise 2.19
```
(define (no-more? values) (null? values))
(define (except-first-denomination values) (cdr values))
(define (first-denomination values) (car values))
```
Order doesn't matter:
```
1 ]=> (define us-coins (list 1 5 10 25 50))

;Value: us-coins

1 ]=> (cc 100 us-coins)

;Value: 292
```
The order doesn't matter because in the recursive rules, we are adding the number of ways to an amount a can me made by increasing the number of types of coins. Since addition is commutative, we can add the number of types of coins and their total combinations in any way we want.

## Exercise 2.20
This was a fun one. Depending on the parity of the first item in the list, I then pass that parity check function (even? or odd?) to get-parity, which does a filter of items using the parity of the first int.
```
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
      
1 ]=> (same-parity 1 2 3 4 5 6 7)

;Value: (1 3 5 7)

1 ]=> (same-parity 2 3 4 5 6 7)

;Value: (2 4 6)

```

## Exercise 2.21
```
(define (square-list items)
  (if (null? items)
      nil
      (cons (square (car items)) (square-list (cdr items)))))

(define (square-list items)
  (map (lambda (x) (square x)) items))
```
## Exercise 2.22
For the first implementatio of `square-list`, the problem lies in that each iteration, Louis is prepending the square of each item in the list to `answer`. And since answer starts at nil, he is building his list of squares backwards. Here is a substition example showing this:

```
(square-list (list 1 2 3))
(iter (list 1 2 3) nil)
(iter (cdr (list 1 2 3)) (cons (square (car (list 1 2 3))) nil))
(iter (cdr (list 2 3)) (cons (square (car (list 2 3))) (list 1)))
(iter (cdr (list 3)) (cons (square (car (list 3))) (cons 4 (list 1))))
```
We can see that `answer` is forming a backwards list of squares, with `(cons 4 (list 1))`.

The second implementation is wrong because Louis created a list with nil nested in the middle:
```
1 ]=> (square-list (list 1 2 3))

;Value: (((() . 1) . 4) . 9)
```
This is because we start by prepending nil to the square of the first item of the list, then consing that with the square of the next item of the list, etc. Here is a substition example showing this:

```
(square-list (list 1 2 3))
(iter (list 1 2 3) nil)
(iter (cdr (list 1 2 3)) (cons nil (square (car (list 1 2 3)))))
(iter (cdr (list 2 3)) (cons (list () 1) (square (car (list 2 3)))))
(iter (cdr (list 3)) (cons (cons (list () 1) 4) (square (car (list 3)))))
```
We can see `answer` has formed into `(cons (cons (list () 1) 4)`, or `((() 1) 4)`.

## Exercise 2.23
It works, but I check `null?` twice. I don't know how to do two evaluations in an if clause. Whatever.
```
(define (for-each proc items)
  (do-proc proc items)
  (if (null? items)
      true
      (for-each proc (cdr items))))

(define (do-proc proc items)
  (if (null? items)
      true
      (proc (car items))))

1 ]=> (for-each (lambda (x) (newline) (display x))
          (list 57 321 88))

57
321
88
;Value: #t
```

## Exercise 2.24
```
1 ]=> (list 1 (list 2 (list 3 4)))

;Value: (1 (2 (3 4)))
```

## Exercise 2.25

```
1 ]=> (list 1 2 (list 5 7) 9)

;Value: (1 2 (5 7) 9)

1 ]=> (cdr (car (cdr (cdr (list 1 2 (list 5 7) 9) ))))

;Value: (7)

1 ]=> (list (list 7))

;Value: ((7))

1 ]=> (car (car (list (list 7))))

;Value: 7

1 ]=> (list 1 (list 2 (list 3 (list 4 (list 5 (list 6 7))))))

;Value: (1 (2 (3 (4 (5 (6 7))))))

(define long-list (list 1 (list 2 (list 3 (list 4 (list 5 (list 6 7)))))))

1 ]=> (cadr (cadr (cadr (cadr (cadr (cadr long-list))))))

;Value: 7
```

## Exercise 2.26
```
1 ]=> (append x y)

;Value: (1 2 3 4 5 6)

1 ]=> (cons x y)

;Value: ((1 2 3) 4 5 6)

1 ]=> (list x y)

;Value: ((1 2 3) (4 5 6))
```

## Exercise 2.27
Phew this one was mind-bending. I knew I had to use `pair?`, but I didn't know what to return. The only thing I could think of returning was `items` in the case where `items` was not a pair, and I got it to work accidently! After thinking it through, the third line treats a pair with only ints the same as it would treat a pair with pairs as it elements. If you take it through with the substition model for a pair with only ints, say (1 2), `deep-reverse` evaluates to (2 1). 
```
(define (deep-reverse items)
  (cond ((null? items) '())
        ((not (pair? items)) items)
        (else (append (deep-reverse (cdr items)) 
                      (list (deep-reverse (car items)))))))

1 ]=> (deep-reverse x)

;Value: ((4 3) (2 1))
```
## Exercise 2.28
Just a slight variation to `deep-reverse`.
```
(define (fringe items)
  (cond ((null? items) '())
        ((not (pair? items)) (list items))
        (else (append (fringe (car items)) (fringe (cdr items))))))

;Value: fringe

1 ]=> 

;Value: (1 2 3 4)

1 ]=> (fringe (list x x))

;Value: (1 2 3 4 1 2 3 4)
```

## Exercise 2.29
a) 
```
(define (left-branch mobile)
  (car mobile))

(define (right-branch mobile)
  (cadr mobile))

(define (branch-length structure)
  (car structure))

(define (branch-structure structure)
  (cadr structure))
```

b)
This took longer than I would have hoped. It took me forever to realize that I have to check for a way to distinguish between mobiles and branches. The easiest way it seems it to check if the `branch-length` is a pair or not. If its not a pair, that means it is a branch, so we need to find the total-weight of that branch. 

```
(define (total-weight mobile)
  (cond ((not (pair? mobile)) mobile)
        ((not (pair? (branch-length mobile))) (total-weight (branch-structure mobile)))
        (else (+ (total-weight (left-branch mobile))
                 (total-weight (right-branch mobile))))))

(define m (make-mobile (make-branch 1 4) (make-branch 1 5)))
(define m2 (make-mobile (make-branch 1 m) (make-branch 1 m)))

1 ]=> m

;Value: ((1 4) (1 5))

1 ]=> m2

;Value: ((1 ((1 4) (1 5))) (1 ((1 4) (1 5))))

1 ]=> (total-weight m)

;Value: 9

1 ]=> (total-weight m2)

;Value: 18
```
c)
```
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

(define m (make-mobile (make-branch 2 4) (make-branch 1 8)))
(define m1 (make-mobile (make-branch 3 2) (make-branch 2 3)))
(define m2 (make-mobile (make-branch 1 m1) (make-branch 1 m)))
(define m3 (make-mobile (make-branch 6 m) (make-branch 7 m1)))

1 ]=> (balanced m)

;Value: #t

1 ]=> (balanced m1)

;Value: #t

1 ]=> (balanced m2)

;Value: #f

1 ]=> (balanced m3)

;Value: #t

```

d) Because we've defined our data in terms of constructors and selectors, we don't have to change much when the underlying `list` pairs become `cons` pairs, we just have to change `cadr` to `cdr` in the selectors.

```
(define (right-branch mobile)
  (cdr mobile))

(define (branch-structure structure)
  (cdr structure))
```
## Exercise 2.30
```
(define (square-tree items)
  (cond ((null? items) '())
        ((not (pair? items)) (square items))
        (else (cons (square-tree (car items))
                    (square-tree (cdr items))))))

(define (square-tree items)
  (map (lambda (sub-tree) 
              (if (pair? sub-tree)
                  (square-tree sub-tree)
                  (square sub-tree))) 
        items))
```

## Exercise 2.31
```
(define (tree-map proc items)
  (map (lambda (sub-tree) 
              (if (pair? sub-tree)
                  (tree-map proc sub-tree)
                  (proc sub-tree))) 
        items))

(define (square-tree items)
  (tree-map square items))
```

## Exercise 2.32  

```
(define (subsets s)
  (if (null? s)
      (list nil)
      (let ((rest (subsets (cdr s))))
        (append rest (map (lambda (x) (cons (car s) x)) rest)))))
```

## Exercise 2.33
```
(define (map p sequence)
  (accumulate (lambda (x y) (cons (p x) y)) nil sequence))

(define (append seq1 seq2)
  (accumulate cons seq2 seq1))

(define (length sequence)
  (accumulate (lambda (x y) (+ 1 y)) 0 sequence))
```

## Exercise 2.34
I just had to stare at Horner's rule for a while to see the pattern. $a_{0}$ is `this-coeff`, and we add $a_{0}$ to x times the higher terms. This translates seamlessly into the lambda function.
```
(define (horner-eval x coefficient-sequence)
  (accumulate (lambda (this-coeff higher-terms) (+ this-coeff (* x higher-terms)))
              0
              coefficient-sequence))
1 ]=> (horner-eval 2 (list 1 3 0 5 0 1))

;Value: 79
```

## Exercise 2.35
Hm, I'm not sure this example needs `map`. It complicates it more than it needs to. Simply using `enumerate-tree` worked well enough. 
```
(define (count-leaves t)
  (accumulate (lambda (x y) (+ 1 y)) 0 (enumerate-tree t)))

(define tree (cons (list 1 2) (list 3 4)))

1 ]=>  (count-leaves tree)

;Value: 4

1 ]=>   (count-leaves (list tree tree))

;Value: 8
```

## Exercise 2.36
Short and fun exercise.
```
(define (accumulate-n op init seqs)
  (if (null? (car seqs))
      nil
      (cons (accumulate op init (map (lambda (seq) (car seq)) seqs))
            (accumulate-n op init (map (lambda (seq) (cdr seq)) seqs)))))
(define s  (list (list 1 2 3) (list 4 5 6) (list 7 8 9) (list 10 11 12)))

1 ]=> s

;Value: ((1 2 3) (4 5 6) (7 8 9) (10 11 12))

1 ]=> (accumulate-n + 0 s)

;Value: (22 26 30)
```

## Exercise 2.37
Because of the name-space clash, I renamed the non-built-in `map` as `map2`
```
(define (matrix-*-vector m v)
  (map2 (lambda (row) (dot-product v row)) m))

(define m (list (list 1 2 3) (list 4 5 6) (list 7 8 9)))
(define v (list 2 2 2))

1 ]=> (matrix-*-vector m v)

;Value: (12 30 48)
```
The idea here is taking the nth element of each row vector, and making that a new row vector. In the below example, the row vector's 1st element is  1, 4, 7, so we create the row vector (1 4 7) as the transpose row. 
```
(define (transpose mat)
  (accumulate-n cons '() mat))

1 ]=> m

;Value: ((1 2 3) (4 5 6) (7 8 9))

1 ]=> (transpose m)

;Value: ((1 4 7) (2 5 8) (3 6 9))
```
This was satisfying. The key insight is that `matrix-*-vector` returns a vector, so we multiply and map each row of the first matrix `m` by the transpose of `n`. 
```
(define (matrix-*-matrix m n)
  (let ((cols (transpose n)))
    (map2 (lambda (row) (matrix-*-vector cols row)) m)))
```
If I hadn't had linear algebra, I doubt I would have the intuition to do these problems.

## Exercise 2.38
```
1 ]=> (fold-right / 1 (list 1 2 3))

;Value: 3/2

1 ]=> (fold-left / 1 (list 1 2 3))

;Value: 1/6

1 ]=> (fold-right list nil (list 1 2 3))

;Value: (1 (2 (3 ())))

1 ]=> (fold-left list nil (list 1 2 3))

;Value: (((() 1) 2) 3)
```
I'd say for arithmetic operations, it should be commutative. Actually, this makes sense for non-arithmetic operations as well. The operation takes in two expressions () (), and if the it doesn't matter what order you place the expressions, then the operation is commutative. 

## Exercise 2.39
`fold-left` was way easier to figure out than `fold-right`. I think I have 5 + ways to reverse a list now. 
```
(define (reverse sequence)
  (fold-right (lambda (x y) (append y (list x))) nil sequence))

(define (reverse sequence)
  (fold-left (lambda (x y) (cons y x)) nil sequence))
```

## Exercise 2.40
```
(define (unique-pairs n)
  (accumulate append
              nil
              (map (lambda (i)
                    (map (lambda (j) (list i j))
                          (enumerate-interval 1 (- i 1))))
                  (enumerate-interval 1 n))))
```

Updating our definition of `prime-sum-pairs`:
```
(define (prime-sum-pairs n)
  (map make-pair-sum
       (filter prime-sum?
               (unique-pairs n))))

1 ]=> (prime-sum-pairs 5)

;Value: ((2 1 3) (3 2 5) (4 1 5) (4 3 7) (5 2 7))
```

## Exercise 2.41
This one was tough. I got the basic structure of `unique-triples`, but I was getting a lot of empty lists. I peeked for a hint and realized I should be using flatmap. That fixed the problem, and the rest wrote itself.
```
(define (unique-triples n)
  (flatmap (lambda (i)
            (flatmap (lambda (j) 
              (map (lambda (k) (list i j k))
                   (enumerate-interval 1 (- j 1))))
              (enumerate-interval 1 (- i 1))))
  (enumerate-interval 1 n)))

(define (integer-sum-triple n s)
  (filter (lambda (seq) (= (accumulate + 0 seq) s))
      (unique-triples n)))

1 ]=> (integer-sum-triple 5 7)

;Value: ((4 2 1))

```

Coming back to 2.42-2.52

## Exercise 2.53

`(list 'a 'b 'c)` (a b c)

`(list (list 'george))` ((george))

`(cdr '((x1 x2) (y1 y2)))` ((y1 y2))

`(cadr '((x1 x2) (y1 y2)))` (y1 y2)

`(pair? (car '(a short list)))` false

`(memq 'red '((red shoes) (blue socks)))` false

`(memq 'red '(red shoes blue socks))` (red shoes blue socks)


## Exercise 2.54
```
(define (myequal? a b)
  (cond ((and (not (pair? a)) (not (pair? b))) (eq? a b))
        ((and (pair? a) (pair? b)) 
          (and (myequal? (car a) (car b)) (myequal? (cdr a) (cdr b))))
        (else false))
)

1 ]=> (myequal? '(this is a list) '(this is a list))

;Value: #t

1 ]=> (myequal? '(this '() a list) '(this is a list))

;Value: #f

1 ]=> (myequal? 'thisisalist 'thisisalist)

;Value: #t
```
## Exercise 2.25
The evaluator returns the value "quote" becuase the interpretor turns ' into "quote".
Since there are two quotes, the first evaluates to the symbol abracadabra, and is the second element of the list, 
while quote becomes the first element of the list, so car returns quote. 
So (car ''abracadabra) becomes (car (quote (quote abracadabra))), which both evalute to quote.