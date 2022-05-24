; List of syntax/functions covered in the book
(define (function_name parameters) ())
(cond (<p1> <e1>)
      (<p2> <e2>)
      (<pn> <en>))
(if <predicate> <consequent> <alternative>)
(and <e1> ... <en>)
(or <e1> ... <en>)
(not <e>)
(lambda (x) (+ x 4))
(let ((<var1> <exp1>)
      (<var2> <exp2>)
      
      (<varn> <expn>))
   <body>)
cons
car
cdr
(newline)
(display "")
(list <a1> <a2> ... <an>)
equivalent to 
(cons <a1> (cons <a2> (cons ... (cons <an> nil) ...)))
length
; Put lists together
append 
reverse
(map proc items)
null?
for-each
(accumulate op initial sequence)
(filter predicate sequence)
; Like accumulate but starting from end
(fold-left op initial sequence)
; The combination of mapping and accumulating with append
(flatmap proc seq)
' for symbols
'() is null
; cdr arbitrary amount of times
cddr 
; cdr then car
cadr
; cdr twice then car
caddr