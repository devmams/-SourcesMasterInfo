(deffacts faits-initiaux
  (personne Jean)
  (personne Luc)
  (personne Bernard)
  (personne Alain)
  (personne Louis)
  (personne Paul)
  (a-ete-trouve-mort Jean mardi)
  (a-fourni-un-alibi Bernard Luc mardi)
  (a-fourni-un-alibi Bernard Paul mardi)
  (a-fourni-un-alibi Luc Louis jeudi)
  (a-fourni-un-alibi Luc Alain mardi)
  (pers-douteuse Luc)
  (desire-se-venger Paul Jean)
  (desire-se-venger Luc Jean)
  (est-heritier Bernard Jean)
  (est-heritier Jean Louis)
  (doit-de-l-argent Louis Jean)
  (doit-de-l-argent Luc Jean)
  (a-vu-commettre-un-crime Jean Alain)
  (possede-arme Luc)
  (possede-arme Louis)
  (possede-arme Alain)
)

(defrule est-suspect
  (declare(salience 50))
  (a-ete-trouve-mort ?victime ?jour)
  (possede-arme ?pers)
  (desire-tuer ?pers ?victime)
  (not (a-fourni-un-alibi ?pers ? ?jour))
  =>
  (assert (suspect ?pers))
)

(defrule supprime-alibi
  (declare(salience 100))
  ?fact <- (a-fourni-un-alibi ?pers ? ?)
  (pers-douteuse ?pers)
  =>
  (retract ?fact)
)

(defrule desire-tuer
  (or (desire-se-venger ?pers1 ?pers2)
      (a-interet-pers-morte ?pers1 ?pers2))
  =>
  (assert (desire-tuer ?pers1 ?pers2))
)

(defrule a-interet-pers-morte
  (or (or (est-heritier ?pers1 ?pers2)
          (doit-de-l-argent ?pers1 ?pers2)
      )
      (a-vu-commettre-un-crime ?pers2 ?pers1)
  )
  =>
  (assert (a-interet-pers-morte ?pers1 ?pers2))
)

(defrule est-inocent
  (personne ?pers)
  (not (a-ete-trouve-mort ?pers ?))
  ; ?fact <- (suspect ?pers)
  (not (suspect ?pers))
  ; (eq ?fact nil)
  =>
  (assert (inocent ?pers))
)

(defrule recherche-suspect
  (suspect ?pers)
  =>
  (printout t ?pers " est un suspect" crlf)
)
(defrule recherche-inoncent
  (inocent ?pers)
  =>
  (printout t ?pers " est un inocent" crlf)
)








; --------------------------------- Fin ---------------------------------
