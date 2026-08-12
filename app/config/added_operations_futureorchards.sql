-- ---------------------------------------------------------------------------
-- Pass 13: AgFirst notes for the Future Orchards winter 2019 orchard walk.
--
-- Four pages, written for Australian growers, covering the three climate risks
-- the programme judged most consequential: soil drainage, winter chill and
-- netting. Short, but the most Australia-specific management material in the
-- corpus, and none of it was in the portal.
--
-- Reviewed at the same time and NOT used:
--   Horticultural Reviews Vol. 47 -- a research review; its single apple chapter
--     is molecular physiology of fruit growth, not management.
--   Pallardy, Physiology of Woody Plants -- physiology reference.
--   Ontario AppleIPM scouting calendars -- the calendars are images; the only
--     extractable text is the caveat that activity periods shift year to year.
-- ---------------------------------------------------------------------------

CREATE TEMP TABLE fo_new(stage_code TEXT, section TEXT, subsection TEXT, description TEXT, page TEXT);

INSERT INTO fo_new VALUES
-- Soil drainage (pp. 1-2)
('ODG00','Modify Landscape','Drainage risk scoring','Quantify the drainage risk of each area of the block and score it, then match the level of mitigation to the score rather than treating the whole orchard the same.','p. 2'),
('ODG02','Environmental stress management','Poor drainage consequences','Treat poor drainage as a whole-season problem: it produces shallow root systems that cannot cope with summer heat, shortens and weakens bloom, changes how fruitlets respond to chemical thinning, and blocks nutrient uptake at the times it matters most.','p. 2'),
('ODG02','Modify Landscape','Drainage system maintenance','Check what the existing drainage system was actually designed to do and maintain it; degraded soil structure and sloping ground both cause drainage problems that the original design never covered.','p. 2'),

-- Winter chill (p. 3)
('OAR00','Environmental stress management','Chill accumulation','Measure the chill actually accumulating at the site against a named model, and read it alongside the heat units accumulated afterwards, since both govern bud break.','p. 3'),
('OAR00','Environmental stress management','Low chill symptoms','Read weak, patchy and drawn-out bud break as the signature of insufficient winter chill, and trace the consequences forward through the season rather than treating it as a spring problem.','p. 3'),
('OAR00','Plant growth regulator','Bud break products','Where chill has been short, choose a bud break product deliberately and get the target timing and application technique right; that is what decides the result more than the choice of product.','p. 3'),

-- Netting (p. 4)
('ODG02','Environmental stress management','Netting benefits','Weigh netting as a climate tool, not just a hail barrier: lower light intensity cuts fruit surface temperature and sunburn, slows soil moisture depletion, keeps leaves photosynthesising closer to optimum by reducing midday stomatal closure, and cuts wind rub.','p. 4'),
('ODG02','Environmental stress management','Netting trade-offs','Plan around what netting costs as well: reduced light can delay colouring -- roll out reflective mulch two to three weeks before harvest to offset it.','p. 4'),
('OAR50','Pollination','Bees under netting','Netting reduces bee activity. Introduce hives at about 20% full bloom and leave a 1 to 1.5 m gap between the top of the canopy and the net so bees have flight paths.','p. 4');

DELETE FROM guidereference WHERE operation_id IN (
    SELECT o.operation_id FROM operation o JOIN fo_new n ON n.description = o.description);
DELETE FROM operation o USING fo_new n WHERE n.description = o.description;

INSERT INTO operation (stage_id, reference_id, description, section, subsection, status)
SELECT s.stage_id,
       (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
       n.description, n.section, n.subsection, 'confirmed'
FROM fo_new n JOIN stage s ON s.stage_code = n.stage_code;

INSERT INTO guidereference (operation_id, third_party_database, link, page_number)
SELECT o.operation_id, 'APAL Future Orchards (AgFirst orchard walk notes)',
       'https://apal.org.au/programs/future-orchards/', n.page
FROM fo_new n
JOIN stage s ON s.stage_code = n.stage_code
JOIN operation o ON o.stage_id = s.stage_id AND o.description = n.description;

DROP TABLE fo_new;

DELETE FROM guidereference g
WHERE g.guidereference_id NOT IN (
    SELECT MIN(guidereference_id) FROM guidereference
    GROUP BY operation_id, third_party_database, link, COALESCE(page_number, ''));
