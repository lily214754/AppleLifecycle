-- ---------------------------------------------------------------------------
-- Pass 14: material found in the APAL spreadsheets folder.
--
--   Improving Pomefruit Quality -- AgFirst notes for the June 2018 Future Orchards
--   field walk (Ross Wilson). Filed among the calculators, so it was missed on the
--   first sweep of that directory.
--
-- Its central argument is one the portal did not carry: fruit quality is not a
-- harvest decision, it is a season-long consequence of vigour, microclimate and
-- spray timing. The Community Orchard Group survey it reports found the main
-- complaint was not any single defect but inconsistency -- immature early picks and
-- over-mature late ones reaching the consumer from the same season.
--
-- The nine Future Orchards calculators in the same folder are linked to the
-- operations they serve, as tools rather than as guidance.
-- ---------------------------------------------------------------------------

CREATE TEMP TABLE q_new(stage_code TEXT, section TEXT, subsection TEXT, description TEXT, page TEXT);

INSERT INTO q_new VALUES
('ODG02','Pruning & Training','Vigour for quality','Treat excess vigour as a quality problem, not just a management one: it brings shading, poor colour, low brix, low pressure and a higher risk of internal disorders. Aim for enough vigour to hold a good leaf-to-fruit ratio and no more.','Vigour for quality'),
('ODG02','Pruning & Training','Reducing vigour','Where vigour needs pulling back, the levers are root pruning, late pruning, girdling, summer pruning, mechanical trimming in spring or summer, prohexadione-calcium, ethephon and controlled water deficit.','Ways to reduce vigour'),
('ODG00','Environmental stress management','Microclimate matching','Match the variety to the microclimate before planting. Hot districts cost early-variety quality and the climate is warming; in many parts of Australia netting and secure reticulated water are prerequisites rather than options.','Climate for quality'),
('ODG02','IPDM','Disease forecasting','Run climate and disease forecasting and work from the pest life cycles and infection risks, so sprays land inside the window rather than on a calendar.','Pest and disease control for quality'),
('ODG02','IPDM','Spray capacity for quality','Keep enough spray capacity to cover the block accurately inside tight windows, with effective coverage and the right droplet size; quality depends on it as much as on the chemistry chosen.','Pest and disease control for quality'),
('OAR82','Harvest management','Maturity consistency','Guard both ends of the harvest window. Immature early picks and over-mature late picks reach the consumer from the same season, and inconsistency -- not any single defect -- is the complaint growers hear most.','COG quality survey');

DELETE FROM guidereference WHERE operation_id IN (
    SELECT o.operation_id FROM operation o JOIN q_new n ON n.description = o.description);
DELETE FROM operation o USING q_new n WHERE n.description = o.description;

INSERT INTO operation (stage_id, reference_id, description, section, subsection, status)
SELECT s.stage_id,
       (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
       n.description, n.section, n.subsection, 'confirmed'
FROM q_new n JOIN stage s ON s.stage_code = n.stage_code;

INSERT INTO guidereference (operation_id, third_party_database, link, page_number)
SELECT o.operation_id, 'APAL Future Orchards: Improving Pomefruit Quality (AgFirst)',
       'https://apal.org.au/programs/future-orchards/', n.page
FROM q_new n
JOIN stage s ON s.stage_code = n.stage_code
JOIN operation o ON o.stage_id = s.stage_id AND o.description = n.description;

DROP TABLE q_new;

-- The Future Orchards calculators, attached to the operations they serve --------

CREATE TEMP TABLE calc(subsection TEXT, tool TEXT);

INSERT INTO calc VALUES
('Crop load target',       'Future Orchards crop load calculator'),
('Post-pruning bud count', 'Future Orchards crop load calculator'),
('Tree row volume',        'Future Orchards TRV/TCA calculator'),
('Sprayer calibration',    'Future Orchards spray rate calculator'),
('Spray volume calculation','Future Orchards spray rate calculator'),
('Weekly water use',       'Future Orchards irrigation ET calculator and regional irrigation budgets'),
('Soil moisture monitoring','Future Orchards irrigation ET calculator and regional irrigation budgets'),
('Drip system design',     'Future Orchards irrigation ET calculator and regional irrigation budgets');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number)
SELECT o.operation_id, 'APAL Future Orchards tools',
       'https://apal.org.au/programs/future-orchards/', c.tool
FROM calc c
JOIN operation o ON o.subsection = c.subsection
WHERE NOT EXISTS (
    SELECT 1 FROM guidereference g
    WHERE g.operation_id = o.operation_id AND g.third_party_database = 'APAL Future Orchards tools');

DROP TABLE calc;

DELETE FROM guidereference g
WHERE g.guidereference_id NOT IN (
    SELECT MIN(guidereference_id) FROM guidereference
    GROUP BY operation_id, third_party_database, link, COALESCE(page_number, ''));
