; NOM : DIALLO
; PRENOM : MAMADOU

(deftemplate situation
  (slot cruche3L (type INTEGER) (allowed-values 0 1 2 3) (default 0))
  (slot cruche4L (type INTEGER) (allowed-values 0 1 2 3 4) (default 0))
  (slot pere (type FACT-ADDRESS SYMBOL) (default nil))
  (slot action (type STRING) (default "situation initiale"))
)

(deffacts fait-initiaux
  (situation)
)

; remplir la cruche de 3 litre
(defrule remplir_la_cruche_de_3L
  ?fact <- (situation (cruche3L 0) (cruche4L ?y) (pere ?p) (action ?))
  =>
  (duplicate ?fact (cruche3L 3) (pere ?fact) (action "remplir la cruche de 3 litres"))
)


; remplir la cruche de 4 litre
(defrule remplir_la_cruche_de_4L
  ?fact <- (situation (cruche3L ?x) (cruche4L 0) (pere ?p) (action ?))
  =>
  (duplicate ?fact (cruche4L 4) (pere ?fact) (action "remplir la cruche de 4 litres"))
)


; vider la cruche de 3L
(defrule vider_la_cruche_de_3L
  ?fact <- (cruche3L x?)
  =>
  (duplicate ?fact (cruche3L 0) (pere ?fact) (action "vider la cruche de 3 litres"))
)

; vider la cruche de 4L
(defrule vider_la_cruche_de_4L
  ?fact <- (cruche4L y?)
  =>
  (duplicate ?fact (cruche4L 0) (pere ?fact) (action "vider la cruche de 4 litres"))
)

; supprimer les doublons
(defrule deja_vu
  (declare(salience 100))
  ?f1 <- (situation (cruche3L ?x) (cruche4L ?y))
  ?f2 <- (situation (cruche3L ?x) (cruche4L ?y))
  (test (> (fact-index ?f2) (fact-index ?f1)))
  =>
  (retract ?f2)
)

; transvaser la cruche de 3 litres dans la cruche de 4 litres
(defrule transvaser_CR3_dans_CR4
  ?fact <- (situation (cruche3L ?x) (cruche4L ?y))
  (test (< ?y 4))
  (not (test (= ?x 0)))
  =>
  (if (>= (+ ?x ?y) 4) then
    (bind ?valX (- ?x (- 4 ?y)))
    (bind ?valY 4)
    (duplicate ?fact (cruche3L ?valX) (cruche4L ?valY) (pere ?fact) (action "transvaser la cruche de 3 litres dans la cruche de 4 litres"))
  else (if (>= (+ ?x ?y) 3) then
          (bind ?valX (- ?x (- 3 ?y)))
          (bind ?valY 3)
          (duplicate ?fact (cruche3L ?valX) (cruche4L ?valY) (pere ?fact) (action "transvaser la cruche de 3 litres dans la cruche de 4 litres"))
        else (if (>= (+ ?x ?y) 2) then
                (bind ?valX (- ?x (- 2 ?y)))
                (bind ?valY 2)
                (duplicate ?fact (cruche3L ?valX) (cruche4L ?valY) (pere ?fact) (action "transvaser la cruche de 3 litres dans la cruche de 4 litres"))
              else
                (bind ?valX (- ?x (- 1 ?y)))
                (bind ?valY 1)
                (duplicate ?fact (cruche3L ?valX) (cruche4L ?valY) (pere ?fact) (action "transvaser la cruche de 3 litres dans la cruche de 4 litres"))
            )
      )
  )
)

; transvaser la cruche de 4 litres dans la cruche de 3 litres
(defrule transvaser_CR4_dans_CR3
  ?fact <- (situation (cruche3L ?x) (cruche4L ?y))
  (test (< ?x 3))
  (not (test (= ?y 0)))
  =>
  (if (>= (+ ?x ?y) 3) then
    (bind ?valY (- ?y (- 3 ?x)))
    (bind ?valX 3)
    (duplicate ?fact (cruche3L ?valX) (cruche4L ?valY) (pere ?fact) (action "transvaser la cruche de 4 litres dans la cruche de 3 litres"))
  else (if (>= (+ ?x ?y) 2) then
          (bind ?valY (- ?y (- 3 ?x)))
          (bind ?valX 2)
          (duplicate ?fact (cruche3L ?valX) (cruche4L ?valY) (pere ?fact) (action "transvaser la cruche de 4 litres dans la cruche de 3 litres"))
        else
          (bind ?valY (- ?y (- 1 ?x)))
          (bind ?valX 1)
          (duplicate ?fact (cruche3L ?valX) (cruche4L ?valY) (pere ?fact) (action "transvaser la cruche de 3 litres dans la cruche de 4 litres"))
      )
  )
)


; afficher solution

(deffunction afficher-solution (?noeud)
  (if (neq ?noeud nil) then
    (bind ?pere (fact-slot-value ?noeud pere))
    (bind ?action (fact-slot-value ?noeud action))
    (bind ?cruche3L (fact-slot-value ?noeud cruche3L))
    (bind ?cruche4L (fact-slot-value ?noeud cruche4L))
    (afficher-solution ?pere)
    (printout t ?action " -> (" ?cruche3L " " ?cruche4L ")" crlf)
  )
)

(defrule eureka
  (declare (salience 100))
  ?fact <- (situation (cruche3L ?x) (cruche4L ?y))
  (test (or (= ?x 2) (= ?y 2)))
  =>
  (afficher-solution ?fact)
  (halt)
)

; ------------------------------------ FIN ------------------------------------
