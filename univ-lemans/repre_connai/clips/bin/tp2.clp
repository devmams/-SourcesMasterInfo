; Nom : DIALLO
; Prenom : MAMADOU

; -------------------------- question 1 --------------------------

(deffacts faits-initiauxxx

  (animal 1 Bozo m)
  (animal 2 Bobby m)
  (animal 3 Betty f)
  (animal 4 Baloo m)
  (animal 5 Koko f)

  (carac 1 poilu)
  (carac 2 poilu)
  (carac 3 poilu)
  (carac 4 poilu)

  (specificite 1 a_poche_ventrale)
  (specificite 2 a_poche_ventrale)


  (regime 3 carnivore)
  (regime 4 carnivore)
  (regime 5 feuilles_deucalyptus)
  (regime 5 des_pousse_de_bambou)

  (action 1 fait_des_grands_bonds)
  (action 2 grimpe_aux_arbres)
  (action 3 vole)
  (action 4 pond_des_oeufs)

  ; -------- chaines de caractère --------
  (texte ch_est_un m " est un ")
  (texte ch_est_un f " est une ")

)

; -------------------------- question 2 --------------------------

(defrule q_donne_du_lait
  (animal ?id ? ?)
  (carac ?id poilu)
  =>
  (assert (specificite ?id donne_du_lait))
)

(defrule q_phalanger
  (animal ?id ? ?)
  (specificite ?id a_poche_ventrale)
  (specificite ?id phalanges_longues)
  =>
  (assert (identification ?id phalanger))
)

(defrule q_koala
  (animal ?id ? ?)
  (identification ?id marsupial)
  (action ?id grimpe_aux_arbres)
  =>
  (assert (identification ?id koala))
)

(defrule q_marsupial
  (animal ?id ? ?)
  (specificite ?id donne_du_lait)
  (specificite ?id a_poche_ventrale)
  =>
  (assert (identification ?id marsupial))
)

(defrule q_kangourou
  (animal ?id ? ?)
  (identification ?id marsupial)
  (action ?id fait_des_grands_bonds)
  =>
  (assert (identification ?id kangourou))
)

(defrule q_mammifere
  (animal ?id ? ?)
  (specificite ?id donne_du_lait)
  =>
  (assert (groupe ?id mammifere))
)

(defrule q_koala-2
  (animal ?id ? ?)
  (regime ?id feuilles_deucalyptus)
  =>
  (assert (identification ?id koala))
)


(defrule q_chauve-souris
  (animal ?id ? ?)
  (action ?id vole)
  (regime ?id carnivore)
  (specificite ?id donne_du_lait)
  =>
  (assert (identification ?id chauve-souris))
)


(defrule q_carni-faucon
  (animal ?id ? ?)
  (categorie oiseau)
  (regime ?id carnivore)
  =>
  (assert (identification ?id faucon))
)

(defrule q_opossum
  (animal ?id ? ?)
  (identification ?id marsupial)
  (regime ?id carnivore)
  (specificite ?id la_queue_prehensile)
  =>
  (assert (identification ?id opossum))
)

(defrule q_hemisphere-sud-marsupial
  (animal ?id ? ?)
  (identification ?id marsupial)
  =>
  (assert (localisation ?id hemisphere_sud))
)

(defrule q_oiseau
  (animal ?id ? ?)
  (action ?id vole)
  (action ?id pond_des_oeufs)
  =>
  (assert (categorie ?id oiseau))
)

(defrule q_ornithorynque
  (animal ?id ? ?)
  (groupe ?id mammifere)
  (action ?id pond_des_oeufs)
  =>
  (assert (identification ?id ornithorynque))
)

(defrule q_souris
  (animal ?id ? ?)
  (groupe ?id mammifere)
  (specificite ?id longue_queue)
  =>
  (assert (identification ?id souris))
)

; -------------------------- question 3 --------------------------

(defrule identifie
  (animal ?id ?nom ?g)
  (identification ?id ?e)
  (texte ch_est_un ?g ?ch)
  =>
  (printout t ?nom ?ch ?e crlf))

; -------------------------- question 4 --------------------------

(deffunction test-id (?noeud)
  (if (eq ?noeud nil) then
  (bind ?nom (fact-slot-value ?noeud nom))
  (printout t ?nom crlf)))

(defrule non-identifie
  (declare (salience 100))
  (animal ?id ?nom ?)
  ?fact <- (identification ?id ?)
  =>
  (test-id ?fact))