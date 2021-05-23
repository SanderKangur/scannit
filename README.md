# Scannit

Mobiilirakendus allergeenide tuvastamiseks toidupakendilt tekstituvastuse abil. Rakendus loodi Tartu Ülikooli informaatika õppekava bakalaureusetöö raames.

## Lahendus

<ul>
      <li>Automaatne tekstituvastus etiketilt</li>
      <li>Võimalik lisada allergeene
          <ul>
                <li>Otsingufunktsiooni abil</li>
                <li>Ise trükkimine ja lisamine</li>
                <li>Levinumate hulgast otsimine</li>
                <li>Kategooriate kasutamine</li>
          </ul>
      </li>
      <li>Töötab eesti keeles</li>
      <li>Pole vaja võrguühendust</li>
</ul>

## Kasutatud tehnoloogiad

- Pildihõive - [Camera](https://pub.dev/packages/camera)
- Tekstituvastus - [Firebase ML Vision](https://pub.dev/packages/firebase_ml_vision) (discontinued)
- Sõnade võrdlus - [String similarity](https://pub.dev/packages/string_similarity)[(Dice koefitsient)](https://en.wikipedia.org/wiki/S%C3%B8rensen%E2%80%93Dice_coefficient)
- Andmebaas - [Shared preferences](https://pub.dev/packages/shared_preferences)

<img width="700" height="300" alt="arhitektuur" src="https://user-images.githubusercontent.com/44495572/119277171-bf591e80-bc26-11eb-9e21-40c5f0d798dd.jpg">


## Skaneerimine

Skaneerimine kasutab ML Vision tekstituvastus mudelit. Tuvastatud teksti võrreldakse [Dice koefitsiendi](https://en.wikipedia.org/wiki/S%C3%B8rensen%E2%80%93Dice_coefficient) abil kasutaja valitud allergeenidega reaalajas.


<img width="700" height="300" alt="skaneerimine" src="https://user-images.githubusercontent.com/44495572/119277172-bff1b500-bc26-11eb-8efc-adb70b5c67ab.jpg">







