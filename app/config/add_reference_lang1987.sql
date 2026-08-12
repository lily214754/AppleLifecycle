-- Lang et al. (1987) is the paper that introduced the endo/para/eco-dormancy
-- terminology and defines paradormancy. The bibliography already holds Lang's
-- companion note in the same volume ("Dormancy: A New Universal Terminology",
-- HortScience 22(5): 817-820, key langDormancyNewUniversal1987) but not this one,
-- which carries the definition the Para-dormancy row now cites.
--
-- Idempotent: does nothing once the key exists.

INSERT INTO reference_data (bibtex_key, title, author, year, publisher, url)
SELECT 'langEndoParaEcodormancy1987',
       'Endo-, Para-, and Ecodormancy: Physiological Terminology and Classification for Dormancy Research',
       'Lang, Gregory A and Early, Jack D and Martin, George C and Darnell, Rebecca L',
       1987,
       'American Society for Horticultural Science',
       'https://doi.org/10.21273/HORTSCI.22.3.371'
WHERE NOT EXISTS (
    SELECT 1 FROM reference_data WHERE bibtex_key = 'langEndoParaEcodormancy1987');
