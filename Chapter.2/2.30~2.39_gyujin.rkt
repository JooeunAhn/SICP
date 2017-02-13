#lang racket

(define (fib n)
   (fib-iter 1 0 0 1 n))

(define (fib-iter a b p q count)
   (cond ((= count 0) b)
         ((even? count)
          (fib-iter a
                    b
                    (+ (* p p) (* q q))     ; compute p'
                    (+ (* 2 p q) (* q q))   ; compute q'
                    (/ count 2)))
         (else (fib-iter (+ (* b q) (* a q) (* a p))
                         (+ (* b p) (* a q))
                         p
                         q
                         (- count 1)))))

; ##### 2.2.2 Hierarchical Structures ##########################################################

(define nil '())

#|
(define (map proc items)
  (if (null? items)
      nil
      (cons (proc (car items))
            (map proc(cdr items)))))
|#

;(map abs (list -10 2.5 -11.6 17))

(define (scale-list items factor)
  (map (lambda (x) (* x factor))
       items))

;(scale-list (list 10 20 30 40) 5)

(define (count-leaves x)
  (cond ((null? x) 0)
        ((not (pair? x)) 1)
        (else (+ (count-leaves (car x))
                 (count-leaves (cdr x))))))

(define (scale-tree tree factor)
  (cond ((null? tree) nil)
        ((not (pair? tree) (* tree factor)))
        (else (cons (scale-tree (car tree) factor)
                    (scale-tree (cdr tree) factor)))))

(define (scale-tree-m tree factor)
  (map (lambda (sub-tree)
         (if (pair? sub-tree)
             (scale-tree-m sub-tree factor)
             (* sub-tree factor)))
       tree))

; ************** 2.30
(println "# 2.30")

(define (square x)
  (* x x ))

(define (square-tree tree)
  (map (lambda (sub-tree)
         (if (pair? sub-tree)
             (square-tree sub-tree)
             (square sub-tree)))
       tree))

(square-tree (list 1 (list 2 (list 3 4 ) 5) (list 6 7)))


; ************** 2.31
(println "# 2.31")

(define (tree-map proc tree)
  (cond ((null? tree) nil)
        ((not (pair? tree)) (proc tree))
        (else (cons (tree-map proc (car tree))
                    (tree-map proc (cdr tree))))))

(define (square-tree-m tree) (tree-map square tree))

(square-tree-m (list 1 (list 2 (list 3 4 ) 5) (list 6 7)))


; ************** 2.32
(println "# 2.32")

#|
(define rest (list (2) (3) (2, 3)))
(append rest (map x rest))
(append rest a)
((2) (3) (2, 3) a)
so a should be ((1) (1, 2) (1, 3) (1, 2, 3))
so x should be (cons (car s) (each member))
|#

(define (x a) (cons 1 a))
(map x (list (list 2) (list 3) (list 2 3) '()))

(define (subsets s)
  (if (null? s)
      (list nil)
      (let ((rest (subsets (cdr s))))
        (append rest (map (lambda (x) (cons (car s) x)) rest)))))

(subsets (list 1 2 3))

; ##### 2.2.3 Sequences as Conventional Interfaces ##########################################################

(define (sum-odd-squares tree)
  (cond ((null? tree) 0)
        ((not (pair? tree))
         (if (odd? tree) (square tree) 0))
        (else (+ (sum-odd-squares (car tree))
                 (sum-odd-squares (cdr tree))))))

#|
(define (even-fibs n)
  (define (next k)
    (if (> k n)
        nil
        (let ((f (fib k)))
          (if (even? f)
              (cons f (next (+ k 1)))
              (next (+ k 1))))))
  (next 0))
|#

(define (filter predicate sequence)
  (cond ((null? sequence) nil)
        ((predicate (car sequence))
         (cons (car sequence)
               (filter predicate (cdr sequence))))
         (else (filter predicate (cdr sequence)))))

;(filter odd? (list 1 2 3 4 5 6 7 8))

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

;(accumulate + 0 (list 1 2 3 4 5))
;(accumulate * 1 (list 1 2 3 4 5))
;(accumulate cons nil (list 1 2 3 4 5))

(define (enumerate-interval low high)
  (if (> low high)
      nil
      (cons low (enumerate-interval (+ low 1) high))))

;(enumerate-interval 2 7)

(define (enumerate-tree tree)
  (cond ((null? tree) nil)
        ((not (pair? tree)) (list tree))
        (else (append (enumerate-tree (car tree))
                      (enumerate-tree (cdr tree))))))

;(enumerate-tree (list 1 (list 2 (list 3 4)) 5))

(define (sum-odd-squares-2 tree)
  (accumulate +
              0
              (map square
                   (filter odd?
                           (enumerate-tree tree)))))

(define (even-fibs-2 n)
  (accumulate cons
              nil
              (filter even?
                      (map fib
                           (enumerate-interval 0 n)))))

(define (list-fib-squares n)
  (accumulate cons
              nil
              (map square
                   (map fib
                        (enumerate-interval 0 n)))))

(list-fib-squares 10)

#| 
(define (salary-of-highest-paid-programmer records)
  (accumulate max
              0
              (map salary
                   (filter programmer? records))))
|#

; ************** 2.33
(println "# 2.33")

(define (map2 p sequence)
  (accumulate (lambda (x y) (cons (p x) y)) nil sequence))

(map2 square (list 1 2 3 4 5))

(define (append2 seq1 seq2)
  (accumulate cons seq2 seq1))

(append2 (list 1 2) (list 3 4))

(define (length2 sequence)
  (accumulate (lambda (x y) (+ 1 y)) 0 sequence))

(length2 (list 1 2 3 4 5 6 7 8 9))


; ************** 2.34
(println "# 2.34")

(define (horner-eval x coefficient-sequence)
  (accumulate (lambda (this-coeff higher-terms)
                (+ this-coeff (* x higher-terms)))
              0
              coefficient-sequence))

(horner-eval 2 (list 1 3 0 5 0 1))


; ************** 2.35
(println "# 2.35")


; ************** 2.36
(println "# 2.36")

(define (accumulate-n op init seqs)
  (if (null? (car seqs))
      nil
      (cons (accumulate op init (map car seqs))
            (accumulate-n op init (map cdr seqs)))))

(accumulate-n + 0 (list (list 1 2) (list 3 4) (list 5 6)))


; ************** 2.37
(println "# 2.37")
#|
(define (dot-product v w)
  (accumulate + 0 (map * v w)))
(dot-product (list 1 2 3)

(define (matrix-*-vector m v)
  (map ? m))

(define (transpose mat)
  (accumulate-n ? ? mat))

(define (matrix-*-matrix m n)
  (let ((cols (transpose n)))
    (map ?? m)))
|#


; ************** 2.38
(println "# 2.38")

(define (fold-left op initial sequence)
  (define (iter result rest)
    (if (null? rest)
        result
        (iter (op result (car rest))
              (cdr rest))))
  (iter initial sequence))

(accumulate / 1 (list 1 2 3))
(fold-left / 1 (list 1 2 3))
(accumulate list nil (list 1 2 3))
(fold-left list nil (list 1 2 3))

; op has to be commutative (includes &&, ||)


; ************** 2.39
(println "# 2.39")

(define (reverse2 sequence)
  (accumulate (lambda (x y) (append y (list x))) nil sequence))
(reverse2 (list 1 2 3 4 5))

(define (reverse3 sequence)
  (fold-left (lambda (x y) (cons y x)) nil sequence))
(reverse3 (list 1 2 3 4 5))


; ************** 2.40
#|
(println "# 2.40")

(accumulate append
            nil
            (map (lambda (i)
                   (map (lambda (j) (list i j))
                        (enumerate-interval 1 (- i 1))))
                 (enumerate-interval 1 n)))

(define (flatmap proc seq)
  (accumulate append nil (map proc seq)))

(define (prime-sum? pair)
  (prime? (+ (car pair) (cadr pair))))

(define (make-pair-sum pair)
  (list (car pair) (cadr pair) (+ (car pair) (cadr pair))))

(define (prime-sum-pairs n)
  (map make-pair-sum
       (filter prime-sum?
               (flatmap
                (lambda (i)
                       (map (lambda (j) (list i j))
                            (enumerate-interval 1 (- i 1))))
                (enumerate-interval 1 n)))))
|#