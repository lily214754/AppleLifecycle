-- ---------------------------------------------------------------------------
-- Pass 15: APVMA Public Release Summary for Brevis Fruit Thinner (metamitron),
-- APVMA product 84928. A .docx sitting in the pdf/ folder, so it was missed on
-- the earlier sweeps of that directory.
--
-- It is a regulatory dossier rather than a management guide, but it carries the
-- Australian registered use pattern for metamitron, which the portal did not have:
-- the thinning window, the rates and the mode of action. The precision thinning
-- deck mentioned metamitron only as a product then years away from US registration.
--
-- Reviewed at the same time and NOT used:
--   Priority Plant Pest Toolkit -- a citizen-science biosecurity toolkit aimed at
--     Victorian backyards, parks and gardens, not commercial orchard management.
-- ---------------------------------------------------------------------------

CREATE TEMP TABLE mm(stage_code TEXT, section TEXT, subsection TEXT, description TEXT, page TEXT);

INSERT INTO mm VALUES
('OAR71','Thinning','Metamitron','Apply metamitron post-fruit set, when central fruitlets are 8 to 16 mm, either as a single application at 1.1 to 2.2 kg/ha or as two applications of 1.1 kg/ha, in 1000 to 2000 L/ha of water and no more than 2.2 kg/ha for the season.','Product claims and use pattern'),
('OAR71','Thinning','How metamitron thins','Metamitron thins by temporarily inhibiting photosynthesis -- it blocks electron transport in photosystem II -- so the weakest fruit in each cluster, those growing slowest and carrying no seed, drop first.','Mode of action');

DELETE FROM guidereference WHERE operation_id IN (
    SELECT o.operation_id FROM operation o JOIN mm n ON n.description = o.description);
DELETE FROM operation o USING mm n WHERE n.description = o.description;

INSERT INTO operation (stage_id, reference_id, description, section, subsection, status)
SELECT s.stage_id,
       (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
       n.description, n.section, n.subsection, 'confirmed'
FROM mm n JOIN stage s ON s.stage_code = n.stage_code;

INSERT INTO guidereference (operation_id, third_party_database, link, page_number)
SELECT o.operation_id, 'APVMA Public Release Summary: Brevis Fruit Thinner (metamitron)',
       'https://www.apvma.gov.au/', n.page
FROM mm n
JOIN stage s ON s.stage_code = n.stage_code
JOIN operation o ON o.stage_id = s.stage_id AND o.description = n.description;

DROP TABLE mm;

DELETE FROM guidereference g
WHERE g.guidereference_id NOT IN (
    SELECT MIN(guidereference_id) FROM guidereference
    GROUP BY operation_id, third_party_database, link, COALESCE(page_number, ''));
