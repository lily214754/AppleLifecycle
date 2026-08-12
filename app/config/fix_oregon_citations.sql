-- ---------------------------------------------------------------------------
-- Correcting the Oregon State citations.
--
-- One link carried 220 citations with page numbers running to 278, but the guide
-- (Pest Management Guide for Tree Fruits, EM 8203, 2024) is 84 pages, and its
-- printed numbers run 1:1 with the PDF. Every citation was checked topic by topic
-- against the current online edition:
--
--   * topic genuinely in the guide  -> page corrected to where it is discussed
--   * topic not in the guide at all -> the false page claim is cleared, the link
--                                      is left in place for review
--
-- Nothing is deleted. Keyed on the operation's subsection, not on row ids, so it
-- survives the rebuild that happens on every boot.
-- ---------------------------------------------------------------------------

CREATE TEMP TABLE oregon_page(subsection TEXT, page TEXT);

INSERT INTO oregon_page VALUES
('Fruit load management', NULL),
('Bloom period insects', NULL),
('Apple scab', 'p. 2'),
('Fire blight', 'p. 48'),
('Powdery mildew', 'p. 66'),
('Rot fungi', NULL),
('Canopy penetration', NULL),
('Codling moth mating disruption', 'p. 14'),
('Winter moth', NULL),
('European red mite', 'p. 33'),
('European Fruit Lecanium', NULL),
('Winter annuals and perennials', NULL),
('Broadleaf weeds', 'p. 59'),
('Black rot, Crown rot', NULL),
('Rosy apple aphid', NULL),
('Scale insects', 'p. 13'),
('European red mite eggs', 'p. 40'),
('MaxCel, Promalin', NULL),
('Bitter rot (Glomerella)', NULL),
('Alternaria leaf spot', NULL),
('San José scale', NULL),
('Oriental fruit moth', NULL),
('Mealybugs', NULL),
('Australian plague locust', NULL),
('Budworms (Heliothis)', NULL),
('Plague thrips', NULL),
('Phytophthora', NULL),
('American plum borer', NULL),
('Dogwood borer', NULL),
('Roundheaded apple tree borer', NULL),
('Redbanded leafroller', NULL),
('San Jose scale', 'p. 22'),
('White Prunicola Scale (WPS)', NULL),
('Lightbrown apple moth (LBAM)', NULL),
('Western flower thrips (WFT)', NULL),
('Codling moth', 'p. 14'),
('Bitter rot', NULL),
('Black and white rots', NULL),
('Sooty blotch and flyspeck', NULL),
('Obliquebanded leafroller', NULL),
('Japanese beetle', NULL),
('Western flower thrips', NULL),
('Wingless grasshopper', NULL),
('Queensland fruit fly', NULL),
('Rutherglen bug', NULL),
('Sparganothis fruitworm', NULL),
('Woolly apple aphid', 'p. 53'),
('General disease control', NULL),
('Insect pest control', NULL),
('Mite management', NULL),
('Vegetative growth control', NULL),
('Rust', 'p. 55'),
('Frogeye leaf spot', NULL),
('Black rot', NULL),
('Spotted tentiform leafminer', NULL),
('White Prunicola scale (WPS)', NULL),
('Plant bugs', NULL),
('Fungicide rotation', NULL),
('Cedar apple rust', NULL),
('Black rot, White rot, Bitter rot', NULL),
('Dogwood borer and other borers', NULL),
('European apple sawfly', NULL),
('Tarnished plant bug, Mullein plant bug', NULL),
('Apple dimpling bug', NULL),
('Helicoverpa and loopers', NULL),
('Pink stage nutrient application', NULL),
('Insect and mite management', NULL),
('Organic options', NULL),
('Gypsy moth, Lesser appleworm, Obliquebanded leafroller', NULL),
('LBAM, WFM, Budworm, Helicoverpa, Apple dimpling bug', NULL),
('Promalin, Perlan', NULL),
('Cultural management', NULL),
('Green apple aphid', 'p. 33'),
('Leafrollers', 'p. 41'),
('Plum curculio', NULL),
('Tarnished plant bug', 'p. 53'),
('White apple leafhopper', NULL),
('Summer thinning nutrient', NULL),
('Boron for cork spot', NULL),
('Calcium chloride', 'p. 79'),
('GA4+7 for russet prevention', NULL),
('Chemical thinning', 'p. 82'),
('Prohexadione-calcium', 'p. 83'),
('Bitter rot, White rot', NULL),
('Colletotrichum', NULL),
('Fire blight shoot blight', NULL),
('Fungicide resistance', NULL),
('Mites, aphids, leafminer', NULL),
('Agri-Mek, Savey', NULL),
('LifeGard, Actigard', NULL),
('Alternaria', NULL),
('Bitter pit', 'p. 79'),
('Potato leafhopper', NULL),
('Leafminers', NULL),
('Aphids', 'p. 44'),
('Two-spotted mite', NULL),
('Budworm, Helicoverpa, Loopers', NULL),
('Queensland fruit fly (QFly), Mediterranean fruit fly (Medfly)', NULL),
('Calcium nitrate', 'p. 80'),
('Fertilizer split application', NULL),
('Summer pruning and water sprout removal', NULL),
('Leader bending, canopy control', NULL),
('Thinning for crop load', NULL),
('Return bloom enhancement', NULL),
('Sucker control', NULL),
('Apple maggot flies', NULL),
('Japanese beetles', NULL),
('Brown marmorated stink bug (BMSB)', NULL),
('Apple leafhopper', NULL),
('Queensland fruit fly (QFly)', NULL),
('Apple scab (urea treatment)', NULL),
('Sooty blotch', NULL),
('Mediterranean fruit fly (Medfly)', NULL),
('Fruit maturity testing', NULL),
('Pre-harvest drop control', NULL);

UPDATE guidereference g
SET page_number = p.page
FROM operation o, oregon_page p
WHERE g.operation_id = o.operation_id
  AND o.subsection IS NOT DISTINCT FROM p.subsection
  AND g.link LIKE '%oregonstate%';

-- Operations with no subsection at all: no way to verify, so clear the page.
UPDATE guidereference g
SET page_number = NULL
FROM operation o
WHERE g.operation_id = o.operation_id
  AND g.link LIKE '%oregonstate%'
  AND (o.subsection IS NULL OR btrim(o.subsection) = '');

DROP TABLE oregon_page;
