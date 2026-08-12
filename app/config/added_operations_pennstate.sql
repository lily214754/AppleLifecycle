-- ---------------------------------------------------------------------------
-- Pass 3 of the corpus review: Penn State Tree Fruit Production Guide 2020-21.
--
-- Read against the local copy. Part I "Cultural Information" (pp. 1-98) is the
-- horticultural core; Part VI covers harvest and storage (pp. 331-340) and
-- Part XI covers precision irrigation, weather and frost protection (pp. 425-434).
--
-- Printed page = PDF page - 8 in this document (verified against four part openers).
--
-- Same two kinds of change as the IPDM pass: operations the portal did not have,
-- and the guide's page added beside an existing citation where it covers the same
-- ground.
-- ---------------------------------------------------------------------------

CREATE TEMP TABLE ps_new(stage_code TEXT, section TEXT, subsection TEXT, description TEXT, page TEXT);

INSERT INTO ps_new VALUES
-- Orchard establishment and layout (Part I, pp. 3-6)
('ODG00','Modify Landscape','Orchard layout','Lay the block out to suit the site: rows on the contour where slope demands it, and a triangular arrangement where it buys tree density without crowding.','p. 5'),
('ODG00','Modify Landscape','Tree spacing','Set tree spacing from the rootstock, the training system and the soil, rather than a single figure applied across the block.','p. 37'),
('ODG00','Disease management','Rootstock selection','Choose the rootstock against vigour, precocity, anchorage and the disease pressure of the site; the comparison table sets the characteristics side by side.','p. 41'),

-- Orchard floor (Part I, pp. 9-10)
('ODG02','Orchard floor management','Row middle management','Manage the row middles as a distinct zone from the tree row: they carry the traffic, hold the soil, and feed the beneficial insects.','p. 9'),
('ODG02','Orchard floor management','Sod management','Maintain the orchard sod deliberately -- species, mowing height and frequency -- rather than letting it revert.','p. 10'),

-- Plant nutrition (Part I, pp. 13-18)
('ODG02','Nutrient management','Deficiency symptoms','Learn to read deficiency and toxicity symptoms in the field, and use them to direct sampling rather than to replace it.','p. 14'),

-- Growth regulators (Part I, pp. 66-80)
('OAR55','Thinning','Blossom thinning','Thin at blossom where the crop load is already clearly set to overrun; blossom thinning acts earlier than any postbloom spray.','p. 70'),
('OAR43','Disease management','Fire blight suppression','Use prohexadione-calcium to suppress shoot blight, timing it to shoot growth rather than to bloom.','p. 70'),
('ODG02','Plant growth regulator','Record keeping','Record every growth regulator application -- product, rate, date, conditions -- since response depends on all of them.','p. 80'),

-- Pollination (Part I, pp. 44-58)
('OAR50','Pollination','Hive stocking rate','Set hive numbers per hectare against the block, the cultivar and the weather expected during bloom.','p. 46'),
('OAR50','Pollination','Pollination agreement','Put the pollination agreement in writing with the beekeeper: hive strength, delivery and removal dates, and placement.','p. 51'),
('OAR55','Pollination','Spray timing around bees','Check the toxicity rating and the safe timing of any product applied near bloom before it goes in the tank.','p. 48'),
('ODG02','Pollination','Wild bee habitat','Provide forage and nesting habitat for wild bees; their flight periods overlap bloom and they work in weather honeybees will not.','p. 57'),

-- Bitter pit (Part I, pp. 59-64)
('OAR72','Nutrient management','Bitter pit risk','Work through the soil, nutritional, vigour and crop-load causes of low-calcium fruit, and correct the ones that apply to the block.','p. 61'),
('OAR73','Nutrient management','Preharvest bitter pit test','Run a preharvest bitter pit assessment on susceptible cultivars such as Honeycrisp, and let the result decide the storage plan.','p. 64'),

-- Harvest and postharvest (Part VI, pp. 332-340)
('OAR82','Harvest management','Worker heat safety','Plan picking around excessive heat: it is a worker safety issue before it is a fruit quality one.','p. 335'),
('OAR82','Post-harvest handling','1-MCP','Consider 1-MCP where fruit must hold its firmness through a long storage or a slow market.','p. 337'),
('OAR82','Post-harvest handling','Postharvest disease control','Control postharvest diseases through sanitation and handling first, and treatment second.','p. 339'),
('OAR82','Harvest management','Watercore','Check for watercore as part of maturity assessment; it marks fruit that will not store.','p. 340'),

-- Precision irrigation, weather and frost (Part XI, pp. 426-434)
('ODG01','Irrigation','Drip system design','Size the drip system to the block and calculate the application rate before scheduling anything from it.','p. 426'),
('ODG02','Irrigation','Automated irrigation','Automate irrigation from soil-moisture sensors where the block justifies it, keeping a manual check on the result.','p. 430'),
('ODG02','IPDM','Weather station','Collect orchard weather from an on-site station or a network such as NEWA; the disease and thinning models are only as good as the data behind them.','p. 431'),
('OAR43','Environmental stress management','Frost heating','Use orchard heating for freeze protection where the block layout and fuel cost make it viable.','p. 432'),
('OAR44','Environmental stress management','Pulsed sprinkling','Pulse the sprinklers where water supply will not sustain a continuous rate through the freeze.','p. 433'),
('OAR43','Environmental stress management','Critical temperatures','Read the critical temperature for the bud stage the block is actually at before deciding to run frost protection.','p. 434');

-- Operations the portal already had that this guide also covers -----------------

CREATE TEMP TABLE ps_also(stage_code TEXT, subsection TEXT, page TEXT);

INSERT INTO ps_also VALUES
('ODG00','Site selection','p. 3'),
('ODG00','Replant testing','p. 4'),
('ODG00','Nursery stock','p. 6'),
('ODG00','Tree inspection','p. 6'),
('ODG00','Contouring','p. 5'),
('ODG00','Planting depth','p. 44'),
('ODG01','Leaf analysis','p. 13'),
('ODG02','Leaf analysis','p. 13'),
('ODG01','Weed control','p. 10'),
('ODG02','Herbicide application','p. 10'),
('ODG01','Young trees','p. 30'),
('ODG02','Fruiting trees','p. 28'),
('OAR73','Summer pruning','p. 30'),
('OAR11','Foliar application','p. 17'),
('ODG02','Nitrogen','p. 18'),
('OAR71','Calcium','p. 59'),
('OAR72','Calcium','p. 59'),
('ODG01','Lateral branching','p. 66'),
('ODG02','Growth control','p. 66'),
('OAR60','Return bloom','p. 70'),
('OAR59','NAA','p. 71'),
('OAR71','Carbaryl','p. 71'),
('OAR71','Temperature','p. 74'),
('OAR72','Hand and mechanical thinning','p. 73'),
('OAR73','Preharvest drop','p. 76'),
('OAR82','Harvest indices','p. 332'),
('OAR82','Handling','p. 334'),
('OAR82','Storage temperature','p. 336'),
('OAR82','Controlled atmosphere','p. 337'),
('OAR82','Scald control','p. 338'),
('ODG01','Soil moisture monitoring','p. 428'),
('OAR43','Overhead irrigation','p. 432'),
('OAR44','Under-tree sprinkling','p. 433'),
('OAR50','Wind machines','p. 433');

-- Apply -----------------------------------------------------------------------

DELETE FROM guidereference WHERE operation_id IN (
    SELECT o.operation_id FROM operation o JOIN ps_new n ON n.description = o.description);
DELETE FROM operation o USING ps_new n WHERE n.description = o.description;

INSERT INTO operation (stage_id, reference_id, description, section, subsection, status)
SELECT s.stage_id,
       (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
       n.description, n.section, n.subsection, 'confirmed'
FROM ps_new n JOIN stage s ON s.stage_code = n.stage_code;

INSERT INTO guidereference (operation_id, third_party_database, link, page_number)
SELECT o.operation_id, 'Penn State Tree Fruit Production Guide',
       'https://extension.psu.edu/tree-fruit-production-guide', n.page
FROM ps_new n
JOIN stage s ON s.stage_code = n.stage_code
JOIN operation o ON o.stage_id = s.stage_id AND o.description = n.description;

INSERT INTO guidereference (operation_id, third_party_database, link, page_number)
SELECT o.operation_id, 'Penn State Tree Fruit Production Guide',
       'https://extension.psu.edu/tree-fruit-production-guide', a.page
FROM ps_also a
JOIN stage s ON s.stage_code = a.stage_code
JOIN operation o ON o.stage_id = s.stage_id AND o.subsection = a.subsection
WHERE NOT EXISTS (
    SELECT 1 FROM guidereference g
    WHERE g.operation_id = o.operation_id
      AND g.third_party_database = 'Penn State Tree Fruit Production Guide');

DROP TABLE ps_new;
DROP TABLE ps_also;

-- Keep the citation list clean after every pass.
DELETE FROM guidereference g
WHERE g.guidereference_id NOT IN (
    SELECT MIN(guidereference_id) FROM guidereference
    GROUP BY operation_id, third_party_database, link, COALESCE(page_number, ''));
