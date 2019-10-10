(deffacts dictionnaire
  (det le m s) (det la f s) (det les m p) (det les f p)
  (adj vert m s post) (adj verte f s post) (adj verts m p post) (adj vertes f p post)
  (adj petit m s pre) (adj petite f s pre) (adj petits m p pre) (adj petites f p pre)
  (nom chat m s) (nom chats m p) (nom souris f s) (nom souris f p)
  (verbe mange) (verbe cherche)
  (pron-pers le) (pron-pers la)
)

(defrule gn-1
  (det ?d ?genre ?nb)
  (nom ?n ?genre ?nb)
  =>
  (assert (gn ?d ?n))
)

(defrule gn-2
  (det ?d ?genre ?nb)
  (nom ?n ?genre ?nb)
  (adj ?a_pre ?genre ?nb pre)
  (adj ?a_post ?genre ?nb post)
  =>
  (assert (gn ?d ?a_pre ?n ?a_post))
)

(defrule gv-1
  (verbe ?v)
  =>
  (assert (gv ?v))
)

(defrule gv-2
  (verbe ?v)
  (gn $?g)
  =>
  (assert (gv ?v ?g))
)

(defrule gv-3
  (verbe ?v)
  (pron-pers ?pp)
  =>
  (assert (gv ?pp ?v))
)


(defrule phrase
  (gn $?x)
  (gv $?y)
  =>
  (assert (phrase phrase ?x ?y))
)

(defrule affichage
  (phrase $?x)
  =>
  (printout t ?x crlf)
)


















; --------------------------------- Fin ---------------------------------
