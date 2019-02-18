{-# OPTIONS --without-K --allow-unsolved-metas #-}

module subuniverses where

import Lecture15
open Lecture15 public

is-subuniverse :
  {l1 l2 : Level} (P : UU l1 → UU l2) → UU ((lsuc l1) ⊔ l2)
is-subuniverse P = is-subtype P

is-local :
  {l1 l2 l3 l4 : Level}
  {I : UU l1} {A : I → UU l2} {B : I → UU l3} (f : (i : I) → A i → B i)
  (X : UU l4) → UU (l1 ⊔ (l2 ⊔ (l3 ⊔ l4)))
is-local {I = I} {B = B} f X =
  (i : I) → is-equiv (λ (h : B i → X) → h ∘ (f i))

is-subuniverse-is-local :
  {l1 l2 l3 l4 : Level}
  {I : UU l1} {A : I → UU l2} {B : I → UU l3} (f : (i : I) → A i → B i) →
  is-subuniverse (is-local {l4 = l4} f)
is-subuniverse-is-local f X = is-prop-Π (λ i → is-subtype-is-equiv _)

subuniverse :
  (l1 l2 : Level) → UU ((lsuc l1) ⊔ (lsuc l2))
subuniverse l1 l2 = Σ (UU l1 → UU l2) is-subuniverse

{- By univalence, subuniverses are closed under equivalences. -}
in-subuniverse-equiv :
  {l1 l2 : Level} (P : UU l1 → UU l2) {X Y : UU l1} → X ≃ Y → P X → P Y
in-subuniverse-equiv P e = tr P (eq-equiv _ _ e)

in-subuniverse-equiv' :
  {l1 l2 : Level} (P : UU l1 → UU l2) {X Y : UU l1} → X ≃ Y → P Y → P X
in-subuniverse-equiv' P e = tr P (inv (eq-equiv _ _ e))

total-subuniverse :
  {l1 l2 : Level} (P : subuniverse l1 l2) → UU ((lsuc l1) ⊔ l2)
total-subuniverse {l1} P = Σ (UU l1) (pr1 P)

Eq-total-subuniverse :
  {l1 l2 : Level} (P : subuniverse l1 l2) →
  (s t : total-subuniverse P) → UU l1
Eq-total-subuniverse (dpair P H) (dpair X p) t = X ≃ (pr1 t)

Eq-total-subuniverse-eq :
  {l1 l2 : Level} (P : subuniverse l1 l2) →
  (s t : total-subuniverse P) → Id s t → Eq-total-subuniverse P s t
Eq-total-subuniverse-eq (dpair P H) (dpair X p) .(dpair X p) refl = equiv-id X

is-contr-total-Eq-total-subuniverse :
  {l1 l2 : Level} (P : subuniverse l1 l2)
  (s : total-subuniverse P) →
  is-contr (Σ (total-subuniverse P) (λ t → Eq-total-subuniverse P s t))
is-contr-total-Eq-total-subuniverse (dpair P H) (dpair X p) =
  is-contr-total-Eq-substructure (is-contr-total-equiv X) H X (equiv-id X) p

is-equiv-Eq-total-subuniverse-eq :
  {l1 l2 : Level} (P : subuniverse l1 l2)
  (s t : total-subuniverse P) → is-equiv (Eq-total-subuniverse-eq P s t)
is-equiv-Eq-total-subuniverse-eq (dpair P H) (dpair X p) =
  id-fundamental-gen
    ( dpair X p)
    ( equiv-id X)
    ( is-contr-total-Eq-total-subuniverse (dpair P H) (dpair X p))
    ( Eq-total-subuniverse-eq (dpair P H) (dpair X p))

universal-property-localization :
  {l1 l2 : Level} (P : subuniverse l1 l2)
  (X : UU l1) (Y : total-subuniverse P) (l : X → pr1 Y) →
  UU ((lsuc l1) ⊔ l2)
universal-property-localization {l1} (dpair P H) X (dpair Y p) l =
  (Z : UU l1) (q : P Z) → is-equiv (λ (h : Y → Z) → h ∘ l)

is-prop-universal-property-localization :
  {l1 l2 : Level} (P : subuniverse l1 l2) (X : UU l1)
  (Y : total-subuniverse P) (l : X → pr1 Y) →
  is-prop (universal-property-localization P X Y l)
is-prop-universal-property-localization (dpair P H) X (dpair Y p) l =
  is-prop-Π (λ Z → is-prop-Π (λ q → is-subtype-is-equiv _))

has-localization :
  {l1 l2 : Level} (P : subuniverse l1 l2) (X : UU l1) →
  UU ((lsuc l1) ⊔ l2)
has-localization {l1} P X =
  Σ ( total-subuniverse P)
    ( λ Y → Σ (X → pr1 Y) (universal-property-localization P X Y))

Eq-localizations :
  {l1 l2 : Level} (P : subuniverse l1 l2) (X : UU l1) →
  ( s t : has-localization P X) → UU l1
Eq-localizations (dpair P H) X
  (dpair (dpair Y p) (dpair l up)) t =
  let Y' = pr1 (pr1 t)
      p' = pr1 (pr1 t)
      l' = pr1 (pr2 t)
      up' = pr2 (pr2 t)
  in
  Σ ( Y ≃ Y')
    ( λ e → ((eqv-map e) ∘ l) ~ l' )

reflexive-Eq-localizations :
  {l1 l2 : Level} (P : subuniverse l1 l2) (X : UU l1) →
  (s : has-localization P X) → Eq-localizations P X s s
reflexive-Eq-localizations (dpair P H) X (dpair (dpair Y p) (dpair l up)) =
  dpair (equiv-id Y) (htpy-refl l)

Eq-localizations-eq :
  {l1 l2 : Level} (P : subuniverse l1 l2) (X : UU l1) →
  ( s t : has-localization P X) → Id s t → Eq-localizations P X s t
Eq-localizations-eq P X s s refl = reflexive-Eq-localizations P X s

is-contr-total-Eq-localizations :
  {l1 l2 : Level} (P : subuniverse l1 l2) (X : UU l1)
  (s : has-localization P X) →
  is-contr (Σ (has-localization P X) (Eq-localizations P X s))
is-contr-total-Eq-localizations
  (dpair P H) X (dpair (dpair Y p) (dpair l up)) =
  is-contr-total-Eq-structure
    ( λ Y' l' e → ((eqv-map e) ∘ l) ~ (pr1 l'))
    ( is-contr-total-Eq-total-subuniverse (dpair P H) (dpair Y p))
    ( dpair (dpair Y p) (equiv-id Y))
    ( is-contr-total-Eq-substructure
      ( is-contr-total-htpy l)
      ( is-prop-universal-property-localization (dpair P H) X (dpair Y p))
      ( l)
      ( htpy-refl _)
      ( up))

is-equiv-Eq-localizations-eq :
  {l1 l2 : Level} (P : subuniverse l1 l2) (X : UU l1) →
  ( s t : has-localization P X) → is-equiv (Eq-localizations-eq P X s t)
is-equiv-Eq-localizations-eq P X s =
  id-fundamental-gen s
  ( reflexive-Eq-localizations P X s)
  ( is-contr-total-Eq-localizations P X s)
  ( Eq-localizations-eq P X s)

eq-Eq-localizations :
  {l1 l2 : Level} (P : subuniverse l1 l2) (X : UU l1)
  ( s t : has-localization P X) → (Eq-localizations P X s t) → Id s t
eq-Eq-localizations P X s t =
  inv-is-equiv (is-equiv-Eq-localizations-eq P X s t)

uniqueness-localizations :
  {l1 l2 : Level} (P : subuniverse l1 l2) (X : UU l1) →
  ( s t : has-localization P X) → Eq-localizations P X s t
uniqueness-localizations (dpair P H) X
  (dpair (dpair Y p) (dpair l up)) (dpair (dpair Y' p') (dpair l' up')) =
  dpair
    ( dpair
      ( inv-is-equiv (up Y' p') l')
      ( is-equiv-has-inverse
        ( dpair
          ( inv-is-equiv (up' Y p) l)
          ( dpair
            ( htpy-eq
              ( ap
                ( pr1 {B = λ h → Id (h ∘ l') l'})
                ( center
                  ( is-prop-is-contr
                    ( is-contr-map-is-equiv (up' Y' p') l')
                    ( dpair
                      ( ( inv-is-equiv (up Y' p') l') ∘
                        ( inv-is-equiv (up' Y p) l))
                      ( ( ap
                          ( λ t → (inv-is-equiv (up Y' p') l') ∘ t)
                          ( issec-inv-is-equiv (up' Y p) l)) ∙
                        ( issec-inv-is-equiv (up Y' p') l')))
                    ( dpair id refl)))))
            ( htpy-eq
              ( ap
                ( pr1 {B = λ h → Id (h ∘ l) l})
                ( center
                  ( is-prop-is-contr
                    ( is-contr-map-is-equiv (up Y p) l)
                    ( dpair
                      ( ( inv-is-equiv (up' Y p) l) ∘
                        ( inv-is-equiv (up Y' p') l'))
                      ( ( ap
                          ( λ t → (inv-is-equiv (up' Y p) l) ∘ t)
                          ( issec-inv-is-equiv (up Y' p') l')) ∙
                         issec-inv-is-equiv (up' Y p) l))
                    ( dpair id refl)))))))))
    ( htpy-eq (issec-inv-is-equiv (up Y' p') l'))

is-prop-localizations :
  {l1 l2 : Level} (P : subuniverse l1 l2) (X : UU l1) →
  is-prop (has-localization P X)
is-prop-localizations P X =
  is-prop-is-prop'
    ( λ Y Y' → eq-Eq-localizations P X Y Y'
      ( uniqueness-localizations P X Y Y'))

universal-property-localization-equiv-is-local :
  {l1 l2 : Level} (P : subuniverse l1 l2) (X : UU l1) →
  (Y : UU l1) (p : (pr1 P) Y) (l : X → Y) →
  is-equiv l → universal-property-localization P X (dpair Y p) l
universal-property-localization-equiv-is-local
  (dpair P H) X Y p l is-equiv-l Z q =
  is-equiv-precomp-is-equiv l is-equiv-l Z

universal-property-localization-id-is-local :
  {l1 l2 : Level} (P : subuniverse l1 l2) (X : UU l1) (q : (pr1 P) X) →
  universal-property-localization P X (dpair X q) id
universal-property-localization-id-is-local P X q =
  universal-property-localization-equiv-is-local P X X q id (is-equiv-id X)

is-equiv-localization-is-local :
  {l1 l2 : Level} (P : subuniverse l1 l2) (X : UU l1) →
  ( Y : has-localization P X) → (pr1 P) X → is-equiv (pr1 (pr2 Y))
is-equiv-localization-is-local
  (dpair P H) X (dpair (dpair Y p) (dpair l up)) q =
  is-equiv-right-factor
    ( id)
    ( inv-is-equiv (up X q) id)
    ( l)
    ( htpy-eq (inv (issec-inv-is-equiv (up X q) id)))
    ( pr2
      ( pr1
        ( uniqueness-localizations (dpair P H) X
          ( dpair (dpair Y p) (dpair l up))
          ( dpair
            ( dpair X q)
            ( dpair id
              ( universal-property-localization-id-is-local
                (dpair P H) X q))))))
    ( is-equiv-id X)

is-local-is-equiv-localization :
  {l1 l2 : Level} (P : subuniverse l1 l2) (X : UU l1) →
  ( Y : has-localization P X) → is-equiv (pr1 (pr2 Y)) → (pr1 P) X
is-local-is-equiv-localization
  (dpair P H) X (dpair (dpair Y p) (dpair l up)) is-equiv-l =
  in-subuniverse-equiv' P (dpair l is-equiv-l) p

strong-retraction-property-localization :
  {l1 l2 : Level} (P : subuniverse l1 l2) (X : UU l1) →
  (Y : total-subuniverse P) (l : X → pr1 Y) → UU l1
strong-retraction-property-localization (dpair P H) X (dpair Y p) l =
  is-equiv (λ (h : Y → X) → h ∘ l)

retraction-property-localization :
  {l1 l2 : Level} (P : subuniverse l1 l2) (X : UU l1) →
  (Y : total-subuniverse P) (l : X → pr1 Y) → UU l1
retraction-property-localization (dpair P H) X (dpair Y p) l =
  retr l

strong-retraction-property-localization-is-equiv-localization :
  {l1 l2 : Level} (P : subuniverse l1 l2) (X : UU l1) →
  (Y : total-subuniverse P) (l : X → pr1 Y) →
  is-equiv l → strong-retraction-property-localization P X Y l
strong-retraction-property-localization-is-equiv-localization
  (dpair P H) X (dpair Y p) l is-equiv-l =
  is-equiv-precomp-is-equiv l is-equiv-l X

retraction-property-localization-strong-retraction-property-localization :
  {l1 l2 : Level} (P : subuniverse l1 l2) (X : UU l1) →
  (Y : total-subuniverse P) (l : X → pr1 Y) →
  strong-retraction-property-localization P X Y l →
  retraction-property-localization P X Y l
retraction-property-localization-strong-retraction-property-localization
  (dpair P H) X (dpair Y p) l s =
  tot (λ h → htpy-eq) (center (is-contr-map-is-equiv s id))

is-equiv-localization-retraction-property-localization :
  {l1 l2 : Level} (P : subuniverse l1 l2) (X : UU l1) →
  (Y : has-localization P X) →
  retraction-property-localization P X (pr1 Y) (pr1 (pr2 Y)) →
  is-equiv (pr1 (pr2 Y))
is-equiv-localization-retraction-property-localization
  (dpair P H) X (dpair (dpair Y p) (dpair l up)) (dpair g isretr-g) =
  is-equiv-has-inverse
    ( dpair g
      ( dpair
        ( htpy-eq
          ( ap
            ( pr1 {B = λ (h : Y → Y) → Id (h ∘ l) l})
            ( center
              ( is-prop-is-contr
                ( is-contr-map-is-equiv (up Y p) l)
                ( dpair (l ∘ g) (ap (λ t → l ∘ t) (eq-htpy isretr-g)))
                ( dpair id refl)))))
        ( isretr-g)))

is-local-retraction-property-localization :
  {l1 l2 : Level} (P : subuniverse l1 l2) (X : UU l1) →
  (Y : has-localization P X) →
  retraction-property-localization P X (pr1 Y) (pr1 (pr2 Y)) →
  (pr1 P) X
is-local-retraction-property-localization P X Y r =
  is-local-is-equiv-localization P X Y
    ( is-equiv-localization-retraction-property-localization P X Y r)

is-local-has-localization-is-contr :
  {l1 l2 : Level} (P : subuniverse l1 l2) (X : UU l1) →
  is-contr X → has-localization P X → (pr1 P) X
is-local-has-localization-is-contr
  (dpair P H) X is-contr-X (dpair (dpair Y p) (dpair l up)) =
  is-local-retraction-property-localization (dpair P H) X
    ( dpair (dpair Y p) (dpair l up))
    ( dpair
      ( λ _ → center is-contr-X)
      ( contraction is-contr-X))

has-localization-is-local-is-contr :
  {l1 l2 : Level} (P : subuniverse l1 l2) (X : UU l1) →
  is-contr X → (pr1 P) X → has-localization P X
has-localization-is-local-is-contr (dpair P H) X is-contr-X p =
  dpair
    ( dpair X p)
    ( dpair id (universal-property-localization-id-is-local (dpair P H) X p))

is-contr-raise-unit :
  (l : Level) → is-contr (raise l unit)
is-contr-raise-unit l =
  is-contr-is-equiv' unit
    ( map-raise l unit)
    ( is-equiv-map-raise l unit)
    ( is-contr-unit)

is-local-unit-localization-unit :
  {l1 l2 : Level} (P : subuniverse l1 l2) →
  (Y : has-localization P (raise l1 unit)) →
  (pr1 P) (raise l1 unit)
is-local-unit-localization-unit P Y =
  is-local-has-localization-is-contr P (raise _ unit) (is-contr-raise-unit _) Y

toto-dependent-elimination-localization :
  {l1 l2 : Level} (P : subuniverse l1 l2) (X : UU l1) →
  (has-loc-X : has-localization P X) →
  let Y = pr1 (pr1 has-loc-X)
      l = pr1 (pr2 has-loc-X)
  in
  (Z : Y → UU l1) →
  Σ (Y → Y) (λ h → (y : Y) → Z (h y)) →
  Σ (X → Y) (λ h → (x : X) → Z (h x))
toto-dependent-elimination-localization (dpair P H) X
  (dpair (dpair Y p) (dpair l up)) Z =
  toto
    ( λ (h : X → Y) → (x : X) → Z (h x))
    ( λ h → h ∘ l)
    ( λ h h' x → h' (l x))

square-dependent-elimination-localization :
  {l1 l2 : Level} (P : subuniverse l1 l2) (X : UU l1) →
  (has-loc-X : has-localization P X) →
  let Y = pr1 (pr1 has-loc-X)
      l = pr1 (pr2 has-loc-X)
  in
  (Z : Y → UU l1) (q : (pr1 P) (Σ _ Z)) →
  ( ( λ (h : Y → Σ Y Z) → h ∘ l) ∘
    ( inv-choice-∞)) ~
  ( ( inv-choice-∞) ∘
    ( toto-dependent-elimination-localization P X has-loc-X Z))
square-dependent-elimination-localization
  (dpair P H) X (dpair (dpair Y p) (dpair l up)) Z q =
  coherence-square-inv-choice-∞ l

is-equiv-toto-dependent-elimination-localization :
  {l1 l2 : Level} (P : subuniverse l1 l2) (X : UU l1) →
  (has-loc-X : has-localization P X)
  (Z : pr1 (pr1 has-loc-X) → UU l1) (q : (pr1 P) (Σ _ Z)) →
  is-equiv (toto-dependent-elimination-localization P X has-loc-X Z)
is-equiv-toto-dependent-elimination-localization
  (dpair P H) X (dpair (dpair Y p) (dpair l up)) Z q =
  is-equiv-top-is-equiv-bottom-square
    ( inv-choice-∞)
    ( inv-choice-∞)
    ( toto-dependent-elimination-localization
      (dpair P H) X (dpair (dpair Y p) (dpair l up)) Z)
    ( λ h → h ∘ l)
    ( square-dependent-elimination-localization
      (dpair P H) X (dpair (dpair Y p) (dpair l up)) Z q)
    ( is-equiv-inv-choice-∞)
    ( is-equiv-inv-choice-∞)
    ( up (Σ Y Z) q)

dependent-elimination-localization :
  {l1 l2 : Level} (P : subuniverse l1 l2) →
  (X : UU l1) (Y : has-localization P X) →
  (Z : (pr1 (pr1 Y)) → UU l1) (q : (pr1 P) (Σ _ Z)) →
  is-equiv (λ (h : (y : (pr1 (pr1 Y))) → (Z y)) → λ x → h (pr1 (pr2 Y) x))
dependent-elimination-localization (dpair P H) X (dpair (dpair Y p) (dpair l up)) Z q =
  is-fiberwise-equiv-is-equiv-toto-is-equiv-base-map
    ( λ (h : X → Y) → (x : X) → Z (h x))
    ( λ (h : Y → Y) → h ∘ l)
    ( λ (h : Y → Y) (h' : (y : Y) → Z (h y)) (x : X) → h' (l x))
    ( up Y p)
    ( is-equiv-toto-dependent-elimination-localization
      (dpair P H) X (dpair (dpair Y p) (dpair l up)) Z q)
    ( id)

is-reflective-subuniverse :
  {l1 l2 : Level} (P : subuniverse l1 l2) → UU ((lsuc l1) ⊔ l2)
is-reflective-subuniverse {l1} P = (X : UU l1) → has-localization P X

reflective-subuniverse :
  (l1 l2 : Level) → UU ((lsuc l1) ⊔ (lsuc l2))
reflective-subuniverse l1 l2 = Σ (subuniverse l1 l2) is-reflective-subuniverse

total-reflective-subuniverse :
  {l1 l2 : Level} (L : reflective-subuniverse l1 l2) → UU ((lsuc l1) ⊔ l2)
total-reflective-subuniverse L = total-subuniverse (pr1 L)

type-localization :
  {l1 l2 : Level} (L : reflective-subuniverse l1 l2)
  (X : UU l1) → total-reflective-subuniverse L
localization (dpair L rs) X = pr1 (rs X)

{-
dependent-elimination-reflective-subuniverse :
  {l1 l2 : Level} (P : reflective-subuniverse l1 l2) (X : UU l1)
-}
