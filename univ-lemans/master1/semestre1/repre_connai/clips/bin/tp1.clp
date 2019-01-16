; Nom : DIALLO
; Prenom : MAMADOU


(deffacts faits-initiaux

  ; ---------- Grand-Parents ----------
  (personne 1 Albert Homme)
  (personne 2 Eugenie Femme)
  ; ------------- Parents -------------
  (personne 3 Martine Femme)
  (personne 4 Christine Femme)
  (personne 5 Daniel Homme)
  ; ------------- Enfants -------------
  (personne 6 Herve Homme)
  (personne 7 Laurent Homme)
  (personne 8 Nicolas Homme)
  (personne 9 Stephanie Femme)
  (personne 10 Thierry Homme)
  (personne 11 Sylvain Homme)
  (personne 12 Philippe Homme)
  (personne 13 Eric Homme)

  ; ------------ relations ------------
  (parent pere 3 1)
  (parent pere 4 1)
  (parent pere 5 1)

  (parent mere 3 2)
  (parent mere 4 2)
  (parent mere 5 2)

  (parent mere 6 3)
  (parent mere 7 3)
  (parent mere 8 3)

  (parent mere 9 4)
  (parent mere 10 4)
  (parent mere 11 4)

  (parent pere 12 5)
  (parent pere 13 5)

  ; -------- chaines de caractère --------
  (texte pere " est le père de ")
  (texte mere " est la mère de ")
  (texte frere " est le frère de ")
  (texte soeur " est la soeur de ")
  (texte grand-pere " est le grand-pere de ")
  (texte grand-mere " est la grand-mere de ")
  )

(defrule frere
  (parent ? ?enft1 ?parnt)
  (parent ? ?enft2 ?parnt)
  (personne ?enft1 ? Homme)
  (test (neq ?enft1 ?enft2))
  => (assert (parent frere ?enft2 ?enft1)))

(defrule soeur
  (parent ? ?enft1 ?parnt)
  (parent ? ?enft2 ?parnt)
  (personne ?enft1 ? Femme)
  (test (neq ?enft1 ?enft2))
  => (assert (parent soeur ?enft2 ?enft1 )))

(defrule grand-pere
  (parent ? ?enft ?pr)
  (parent ? ?pr ?grdpr)
  (personne ?grdpr ? Homme)
  (test (neq ?pr ?grdpr))
  => (assert (parent grand-pere ?enft ?grdpr )))

(defrule grand-mere
  (parent ? ?enft ?pr)
  (parent ? ?pr ?grdmr)
  (personne ?grdmr ? Femme)
  (test (neq ?pr ?grdmr))
  => (assert (parent grand-mere ?enft ?grdmr )))

(defrule affichage
  (parent ?lien ?ind1 ?ind2)
  (personne ?ind1 ?n1 ?)
  (personne ?ind2 ?n2 ?)
  (texte ?lien ?ch)
  =>
  (printout t ?n2 ?ch ?n1 crlf))



; ----------------- FIN -----------------