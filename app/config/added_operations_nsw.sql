-- ---------------------------------------------------------------------------
-- Pass 4 of the corpus review: NSW DPIRD Orchard Plant Protection Guide for
-- Deciduous Fruits in NSW 2025-26.
--
-- Read against the local copy. The pest and disease sections largely restate
-- ground the portal already covers, so most of this pass is the guide's page
-- added beside existing citations. What the guide adds outright is its
-- management articles: degree-day spray timing (p. 92), protecting beneficials
-- (p. 94), non-bearing trees (p. 125), postharvest disease origin (p. 127),
-- PGR groupings including dormancy breaking (p. 134), weed management (p. 136),
-- resistance management (p. 144), and the non-pesticide practices on p. 5.
--
-- Printed page = PDF page - 2 (verified against two contents entries).
-- ---------------------------------------------------------------------------

CREATE TEMP TABLE nsw_new(stage_code TEXT, section TEXT, subsection TEXT, description TEXT, page TEXT);

INSERT INTO nsw_new VALUES
-- Degree-day spray timing (p. 92)
('OAR01','IPDM','Pheromone trapping','Deploy pheromone traps at about one per hectare, covering the warmest part of the block and last season''s hotspots, at least a week before bud break for light brown apple moth and before bloom for codling and oriental fruit moth.','p. 92'),
('OAR43','IPDM','Biofix','Check the traps daily until the first sustained moth flight, and set that date as the biofix the degree-day model counts from.','p. 92'),
('OAR44','IPDM','Degree days','Accumulate degree days from biofix using daily maximum and minimum temperatures against the pest''s lower developmental threshold, and time the first spray from the model rather than the calendar.','p. 92'),

-- Beneficials and resistance (pp. 94, 144)
('ODG02','IPDM','Beneficial insects','Use the least disruptive chemistry that will do the job, and only when it is needed, so lady beetles, lacewings, parasitic wasps and predatory mites keep working in the block.','p. 94'),
('ODG02','IPDM','Resistance management','Rotate chemical action groups so the same active is never applied repeatedly, and use full label rates with thorough coverage; part rates and poor coverage are what breed resistance.','p. 144'),
('ODG02','IPDM','Spray responsibilities','Meet the legal obligations that come with applying pesticides: records, withholding periods, protective equipment and drift management.','p. 147'),

-- Non-pesticide practice (p. 5)
('ODG02','IPDM','Orchard hygiene','Dispose of unwanted fruit properly and destroy feral and neglected trees nearby; both are reservoirs that reinfect the block.','p. 5'),
('ODG02','Orchard floor management','Weed timing','Time weed control so pests cannot use weeds as an alternative site to survive winter.','p. 5'),
('OAR11','Irrigation','Overhead irrigation and disease','Avoid overhead irrigation where it wets foliage and favours infection, unless it is being run for frost or heat management and the reasons are compelling.','p. 5'),

-- Non-bearing trees (p. 125)
('ODG01','IPDM','Non-bearing spray program','Young non-bearing trees do not need the bearing-tree spray schedule; monitor instead for the pests and diseases that threaten tree health.','p. 125'),
('ODG01','IPDM','Young tree stress','Keep young trees out of stress with adequate nutrition and irrigation and by removing weed competition; increased compost, a sound fertiliser regime and regular monitoring are what get them to full potential.','p. 125'),
('ODG01','Disease management','Scab in young trees','Run a protective schedule against scab on young trees, and remove and mulch infected leaves over winter so the infection does not carry into the next season.','p. 125'),

-- Postharvest (p. 127)
('OAR82','Post-harvest handling','Postharvest rot origin','Treat postharvest rots as an orchard problem: many begin at flowering and fruit growth and only appear in store, so orchard protection, fruit nutrition and shed hygiene all bear on the outcome.','p. 127'),

-- PGR groupings (p. 134)
('OAR00','Plant growth regulator','Dormancy breaking','Where winter chilling has been marginal, use a dormancy-breaking product to compress bloom and even up pollination and fruit set.','p. 134'),

-- Weed management (p. 136)
('ODG00','Orchard floor management','Establishment weed control','Control weeds hard while the orchard is establishing; rapid canopy development and early cropping depend on it, and in a capital-intensive block so does profitability.','p. 136'),
('ODG02','Orchard floor management','Priority weeds','Identify the high-priority weeds for the district and target them before they seed; marshmallow is a major one in pome fruit, and its woody taproot resists mechanical control.','p. 136');

-- Operations the portal already had that this guide also covers -----------------

CREATE TEMP TABLE nsw_also(subsection TEXT, page TEXT);

INSERT INTO nsw_also VALUES
-- management articles
('Weed control','p. 136'),
('Herbicide application','p. 136'),
('Canopy openness','p. 5'),
('Pruning wounds','p. 123'),
('Nursery stock','p. 125'),
('Postharvest disease control','p. 127'),
('Growth control','p. 134'),
('Return bloom','p. 134'),
('Preharvest drop','p. 134'),
('Ripening and colour','p. 134'),
('Blossom thinning','p. 132'),
('NAA','p. 132'),
('Carbaryl','p. 132'),
('Hand and mechanical thinning','p. 132'),
('Sprayer calibration','p. 147'),
-- pests and diseases, matched to this guide's own pages
('Bryobia mite','p. 35'),
('Codling moth','p. 45'),
('Codling moth mating disruption','p. 45'),
('European red mite','p. 50'),
('European red mite eggs','p. 50'),
('Mealybugs','p. 61'),
('Oriental fruit moth','p. 63'),
('Plague thrips','p. 68'),
('San José scale','p. 79'),
('San Jose scale','p. 79'),
('Two-spotted mite','p. 81'),
('Western flower thrips','p. 87'),
('Western flower thrips (WFT)','p. 87'),
('Woolly apple aphid','p. 90'),
('Woolly aphid (postharvest)','p. 90'),
('Australian plague locust','p. 32'),
('Apple scab','p. 100'),
('Apple scab (urea treatment)','p. 100'),
('Bitter rot','p. 105'),
('Crown gall','p. 110'),
('Phytophthora','p. 115'),
('Powdery mildew','p. 117'),
('Silver leaf','p. 123');

-- Apply -----------------------------------------------------------------------

DELETE FROM guidereference WHERE operation_id IN (
    SELECT o.operation_id FROM operation o JOIN nsw_new n ON n.description = o.description);
DELETE FROM operation o USING nsw_new n WHERE n.description = o.description;

INSERT INTO operation (stage_id, reference_id, description, section, subsection, status)
SELECT s.stage_id,
       (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
       n.description, n.section, n.subsection, 'confirmed'
FROM nsw_new n JOIN stage s ON s.stage_code = n.stage_code;

INSERT INTO guidereference (operation_id, third_party_database, link, page_number)
SELECT o.operation_id, 'NSW Orchard Plant Protection Guide',
       'https://www.dpird.nsw.gov.au/agriculture/horticulture/pests-diseases-hort/information-for-multiple-crops/orchard-plant-protection-guide',
       n.page
FROM nsw_new n
JOIN stage s ON s.stage_code = n.stage_code
JOIN operation o ON o.stage_id = s.stage_id AND o.description = n.description;

INSERT INTO guidereference (operation_id, third_party_database, link, page_number)
SELECT o.operation_id, 'NSW Orchard Plant Protection Guide',
       'https://www.dpird.nsw.gov.au/agriculture/horticulture/pests-diseases-hort/information-for-multiple-crops/orchard-plant-protection-guide',
       a.page
FROM nsw_also a
JOIN operation o ON o.subsection = a.subsection
WHERE NOT EXISTS (
    SELECT 1 FROM guidereference g
    WHERE g.operation_id = o.operation_id
      AND g.third_party_database = 'NSW Orchard Plant Protection Guide');

DROP TABLE nsw_new;
DROP TABLE nsw_also;

DELETE FROM guidereference g
WHERE g.guidereference_id NOT IN (
    SELECT MIN(guidereference_id) FROM guidereference
    GROUP BY operation_id, third_party_database, link, COALESCE(page_number, ''));
