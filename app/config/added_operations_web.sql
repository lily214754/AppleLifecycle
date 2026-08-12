-- ---------------------------------------------------------------------------
-- Pass 12: the extension web sources in corpus/01_raw/html.
--
-- 1,450 saved pages. Most are news, market or industry material; the operational
-- core is APAL's grower articles, the WSU Tree Fruit orchard-management section
-- and its research articles. Content was read from the saved pages themselves.
--
-- These are web pages, not books, so citations carry the article title in place of
-- a page number and link to the section rather than a numbered page.
-- ---------------------------------------------------------------------------

CREATE TEMP TABLE w_new(stage_code TEXT, section TEXT, subsection TEXT, description TEXT, db TEXT, url TEXT, page TEXT);

INSERT INTO w_new VALUES
-- APAL, Australian grower articles
('OAR71','Fertilization','Calcium timing window','Concentrate calcium sprays in the first six weeks after fruit set. That is when the surface-to-volume ratio is high, transpiration carries water and calcium into the fruitlets, and uptake actually happens; afterwards it levels off and dilutes as the fruit expands.','APAL Grower Resources','https://apal.org.au/','Calcium to combat post-harvest disorders'),
('OAR71','Thinning','Carbohydrate manipulation','Chemical thinners work by stressing the tree during rapid shoot and fruit growth, so managing the soluble carbohydrate supply through that window changes how sensitive the fruitlets are to the spray.','APAL Grower Resources','https://apal.org.au/','Apple crop load management: carbohydrate manipulation'),
('ODG01','Orchard floor management','Compost and mulch','Apply compost or straw mulch to young trees for surface cover and moisture retention; it breaks down to release nutrients slowly, and the reapplication interval lengthens as the orchard matures.','APAL Grower Resources','https://apal.org.au/','Composts and mulches for young orchards'),
('ODG02','Nutrient management','Paired leaf tests','Where a block has a persistent problem, take paired leaf tests from two separate areas of it and read the N:P and N:K ratios, not just the individual levels, to locate the imbalance.','APAL Grower Resources','https://apal.org.au/','Nutrient management for pome fruit'),
('ODG02','Nutrient management','Soil carbon and mineralisable nitrogen','Track soil organic carbon and mineralisable nitrogen alongside the annual nutrient test; they show the energy available for microbial activity, which the nutrient figures alone do not.','APAL Grower Resources','https://apal.org.au/','How healthy is your soil?'),
('OAR82','Harvest management','Maturity measurement','Pick on scientifically valid maturity measurements: good post-harvest management can do nothing with fruit that was harvested too early or too late.','APAL Grower Resources','https://apal.org.au/','Harvest timing key to consistent quality'),
('OAR55','Pollination','Hive priming','Consider priming hives with sucrose and flower aroma to lift foraging, noting that the response differs between apples and pears because pear foraging is driven by pollen rather than nectar.','APAL Grower Resources','https://apal.org.au/','Improving bee performance'),

-- WSU Tree Fruit orchard management
('ODG02','Irrigation','Weekly water use','Set the weekly irrigation from measured evapotranspiration for the district rather than a fixed schedule; tree water use climbs steadily from about 0.04 in/day in early April to several times that by midsummer.','WSU Tree Fruit Orchard Management','https://treefruit.wsu.edu/orchard-management/irrigation-management/','Determining your irrigation schedule'),
('ODG02','Irrigation','System evaluation','Evaluate the irrigation system itself, not just the schedule: uneven pressure across slopes, worn or wrong emitters and poor distribution uniformity all cap what any schedule can achieve.','WSU Tree Fruit Orchard Management','https://treefruit.wsu.edu/orchard-management/irrigation-management/','Evaluating irrigation systems'),
('ODG02','Soil chemical management','Soil health assessment','Assess soil health across its biological, physical and chemical properties together -- active microbial communities mineralise nitrogen, build structure and compete with pathogens, which no chemical test alone will show.','WSU Tree Fruit Orchard Management','https://treefruit.wsu.edu/orchard-management/soils-nutrition/','Soil health in orchards'),
('OAR71','Thinning','Sizing disc calibration','Give the thinning crew a sizing disc and re-calibrate them on it each morning: demonstrate the target diameters before they start, since accuracy drifts through the day.','WSU Tree Fruit','https://treefruit.wsu.edu/','Green fruit thinning with the Equilifruit disc'),
('OAR73','Pruning & Training','Mechanical hedging','Decide whether hedging is part of the system before the block is designed, since it suits a canopy of short stiff limbs carrying a few fruiting sites. Hedge at the right leaf stage to set terminal buds, push buds behind the cuts and open the canopy.','WSU Tree Fruit','https://treefruit.wsu.edu/','Mechanical hedging in apples'),
('ODG02','Orchard floor management','Weed size at spraying','Spray weeds while they are small. Size at application governs control for most herbicides, and waiting costs more than the extra pass would have.','WSU Tree Fruit','https://treefruit.wsu.edu/','Size matters: apply herbicides to small weeds'),
('OAR59','Nutrient management','Post-bloom nutrition','Set the post-bloom nutrition priorities deliberately; this is the window where the season''s fruit quality is largely determined.','WSU Tree Fruit','https://treefruit.wsu.edu/','Post-bloom nutrition priorities'),
('OAR82','Post-harvest handling','Harvest preparation for storage','Prepare for long-term storage before picking starts: rot pressure at harvest, and the handling that follows, decide how the fruit holds in store.','WSU Tree Fruit','https://treefruit.wsu.edu/','Reduce postharvest rots: harvest preparation and long-term storage'),
('ODG02','Environmental stress management','Heat stress monitoring','Monitor orchard heat stress in real time during summer and manage it for fruit colour and sunburn, rather than reacting after damage shows.','WSU Tree Fruit','https://treefruit.wsu.edu/','Real-time in-orchard apple heat stress monitoring');

DELETE FROM guidereference WHERE operation_id IN (
    SELECT o.operation_id FROM operation o JOIN w_new n ON n.description = o.description);
DELETE FROM operation o USING w_new n WHERE n.description = o.description;

INSERT INTO operation (stage_id, reference_id, description, section, subsection, status)
SELECT s.stage_id,
       (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
       n.description, n.section, n.subsection, 'confirmed'
FROM w_new n JOIN stage s ON s.stage_code = n.stage_code;

INSERT INTO guidereference (operation_id, third_party_database, link, page_number)
SELECT o.operation_id, n.db, n.url, n.page
FROM w_new n
JOIN stage s ON s.stage_code = n.stage_code
JOIN operation o ON o.stage_id = s.stage_id AND o.description = n.description;

DROP TABLE w_new;

DELETE FROM guidereference g
WHERE g.guidereference_id NOT IN (
    SELECT MIN(guidereference_id) FROM guidereference
    GROUP BY operation_id, third_party_database, link, COALESCE(page_number, ''));
