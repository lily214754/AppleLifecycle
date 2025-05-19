


-- -- DROP TABLE IF EXISTS stage;
-- -- DROP TABLE IF EXISTS timing;
-- -- DROP TABLE IF EXISTS observation;
-- -- DROP TABLE IF EXISTS key_measurement;


-- -- -- 2. Stage table
-- -- CREATE TABLE stage (
-- --     stage_id SERIAL PRIMARY KEY,
-- --     stage_code VARCHAR(50) UNIQUE NOT NULL,
-- --     stage_name TEXT,
-- --     description TEXT
-- -- );

-- -- -- 3. Timing table (two types: either description or timing reference with distance)
-- -- CREATE TABLE timing (
-- --     timing_id SERIAL PRIMARY KEY,
-- --     stage_id INT REFERENCES stage(stage_id),
-- --     reference_id INT REFERENCES reference_data(id),
-- --     timing_type VARCHAR(20) CHECK (timing_type IN ('description', 'reference')) NOT NULL,
-- --     description TEXT,
-- --     reference_timing TEXT,
-- --     reference_timing_distance TEXT
-- -- );

-- -- -- 4. Observation table
-- -- CREATE TABLE observation (
-- --     observation_id SERIAL PRIMARY KEY,
-- --     stage_id INT REFERENCES stage(stage_id),
-- --     reference_id INT REFERENCES reference_data(id),
-- --     description TEXT,
-- --     item TEXT,
-- --     value TEXT
-- -- );

-- -- -- 5. Key measurement table
-- -- CREATE TABLE key_measurement (
-- --     measurement_id SERIAL PRIMARY KEY,
-- --     stage_id INT REFERENCES stage(stage_id),
-- --     reference_id INT REFERENCES reference_data(id),
-- --     measurement_name TEXT NOT NULL,
-- --     unit TEXT,
-- --     value_range TEXT,
-- --     calculation_method TEXT
-- -- );



-- -- DROP TABLE IF EXISTS stage;
-- -- DROP TABLE IF EXISTS timing;
-- -- DROP TABLE IF EXISTS observation;
-- -- DROP TABLE IF EXISTS key_measurement;


-- -- -- 2. Stage table
-- -- CREATE TABLE stage (
-- --     stage_id SERIAL PRIMARY KEY,
-- --     stage_code VARCHAR(50) UNIQUE NOT NULL,
-- --     stage_name TEXT,
-- --     description TEXT
-- -- );

-- -- -- 3. Timing table (two types: either description or timing reference with distance)
-- -- CREATE TABLE timing (
-- --     timing_id SERIAL PRIMARY KEY,
-- --     stage_id INT REFERENCES stage(stage_id),
-- --     reference_id INT REFERENCES reference_data(id),
-- --     timing_type VARCHAR(20) CHECK (timing_type IN ('description', 'reference')) NOT NULL,
-- --     description TEXT,
-- --     reference_timing TEXT,
-- --     reference_timing_distance TEXT
-- -- );

-- -- -- 4. Observation table
-- -- CREATE TABLE observation (
-- --     observation_id SERIAL PRIMARY KEY,
-- --     stage_id INT REFERENCES stage(stage_id),
-- --     reference_id INT REFERENCES reference_data(id),
-- --     description TEXT,
-- --     item TEXT,
-- --     value TEXT
-- -- );

-- -- -- 5. Key measurement table
-- -- CREATE TABLE key_measurement (
-- --     measurement_id SERIAL PRIMARY KEY,
-- --     stage_id INT REFERENCES stage(stage_id),
-- --     reference_id INT REFERENCES reference_data(id),
-- --     measurement_name TEXT NOT NULL,
-- --     unit TEXT,
-- --     value_range TEXT,
-- --     calculation_method TEXT
-- -- );
-- -- -- Insert stage data


-- INSERT INTO stage (stage_code, stage_name, description) VALUES
-- ('O-L1-PT', 'Planting Tree', 'Initial phase of planting orchard trees, including rootstock preparation and grafting.'),
-- ('O-L1-YT', 'Young Tree', 'Early growth phase where trees establish roots and vegetative structures.'),
-- ('O-L1-MT', 'Mature Tree', 'Productive phase with active fruiting and full canopy development.'),
-- ('O-L1-EP', 'End of Productive Life', 'Decline phase marked by reduced vigor and fruit yield.'),
-- ('O-AR-DO-(00)-(00)', 'Dormancy', 'Temporary suspension of visible growth with changes in carbohydrate, starch, and soluble sugar content.'),
-- ('O-AR-DO-(00)-PD-X', 'Para-dormancy', 'Dormancy controlled by internal conditions with carbohydrate buildup.'),
-- ('O-AR-DO-(00)-ED-X', 'Endo-dormancy', 'Winter dormancy stage that requires chilling accumulation to break.'),
-- ('O-AR-DO-(00)-EC-X', 'Eco-dormancy', 'Dormancy stage limited by external environmental conditions.'),

-- ('O-AR-BD-(01-09)-(01-09)', 'Bud Development', 'Progressive development of buds from swelling to bud break.'),
-- ('O-AR-BD-(01-09)-LS-(01-03)', 'Leaf Bud Swelling', 'Stage where bud scales elongate and lighten, preparing for break.'),
-- ('O-AR-BD-(01-09)-BB-09', 'Bud Break', 'Appearance of green leaf tips indicating bud break.'),

-- ('O-AR-LD-(10-19)-(10-19)', 'Leaf Development', 'Rapid leaf unfolding and expansion phase.'),
-- ('O-AR-SD-(31-39)-(31-39)', 'Shoot Development', 'Shoot elongation following a sigmoid growth pattern.'),

-- ('O-AR-IE-(51-59)-(51-59)', 'Inflorescence Emergence', 'Floral bud development culminating in visible flowers.'),
-- ('O-AR-IE-(51-59)-FS-55', 'Floral Bud Swelling', 'Stage where floral buds swell prominently.'),
-- ('O-AR-IE-(51-59)-BB-57', 'Bud Burst', 'Emergence of green leaf tips and visible flowers.'),
-- ('O-AR-IE-(51-59)-PB-59', 'Pink Bud Stage', 'Petal elongation and sepals opening just before flowering.'),
-- ('O-AR-IE-(51-59)-HB-X', 'Hollow Ball Formation', 'Flowers form a hollow ball shape at stage culmination.'),

-- ('O-AR-FL-(60-69)-(60-69)', 'Flowering', 'Progressive flower bloom with overlapping phases.'),
-- ('O-AR-FL-(60-69)-FF-60', 'First Flower', 'Opening of first flowers in the orchard.'),
-- ('O-AR-FL-(60-69)-PO-65', 'Pollination', 'Transfer of pollen grains between flowers.'),
-- ('O-AR-FL-(60-69)-FE-67', 'Fertilisation', 'Union of gametes resulting in zygote formation.'),
-- ('O-AR-FL-(60-69)-FS-69', 'Fruit Set', 'Formation of fruit following successful fertilisation.'),
-- ('O-AR-FL-(60-69)-FB-65', 'Full Bloom / Anthesis', 'Peak flowering period with maximum open blooms.'),
-- ('O-AR-FL-(60-69)-EP-69', 'End of Flowering', 'Petal fall indicating flowering completion.'),

-- ('O-AR-FBF-X', 'Flower Bud Formation for Next Season', 'Development of floral meristems for the following season.'),
-- ('O-AR-FBF-FI-X', 'Flower Induction', 'Initial physiological commitment to floral formation.'),
-- ('O-AR-FBF-IN-X', 'Flower Initiation', 'Early morphological changes indicating floral development.'),
-- ('O-AR-FBF-BD-X', 'Bud Differentiation', 'Complex differentiation within the floral bud structure.'),

-- ('O-AR-FD-(71-79)', 'Fruit Development', 'Fruit growth phase with size increase and physiological changes.'),
-- ('O-AR-FD-FS-(71-76)', 'Fruit Size Increase', 'Rapid fruit expansion and growth.'),
-- ('O-AR-FD-CD-X', 'Cell Division', 'Cell multiplication contributing to fruit growth.'),
-- ('O-AR-FD-CE-X', 'Cell Enlargement', 'Cell expansion and volume increase.'),
-- ('O-AR-FD-F1-77', 'First Fruit Fall', 'Initial drop of unviable or excess fruitlets.'),
-- ('O-AR-FD-F2-79', 'Second Fruit Fall', 'Subsequent natural thinning of fruits.'),
-- ('O-AR-FD-SC-91', 'Shoot Growth Completed', 'Cessation of shoot elongation.'),

-- ('O-AR-FM-(81-89)', 'Maturity of Fruit and Seed', 'Final ripening stage for fruit and seeds.'),
-- ('O-AR-FM-RS-81', 'Beginning of Ripening', 'Initial stages of fruit coloration and ripening.'),
-- ('O-AR-FM-CO-85', 'Advanced Coloring', 'Deepening of fruit color indicating ripeness.'),
-- ('O-AR-FM-HV-87', 'Fruit Harvest', 'Harvest-ready stage of fruits.'),

-- ('O-AR-SN-(92-97)', 'Senescence', 'Progressive leaf senescence and drop.'),
-- ('O-AR-SN-LD-91', 'Leaves Begin to Discolor', 'Initial color change in leaves.'),
-- ('O-AR-SN-LF-93', 'Beginning of Leaf Fall', 'Start of significant leaf drop.'),
-- ('O-AR-SN-50-95', '50% Leaves Discolored', 'Midway point of leaf discoloration.'),
-- ('O-AR-SN-AF-97', 'All Leaves Fallen', 'Completion of leaf fall and onset of dormancy.');

-- -- Insert timing data for orchard stages
-- INSERT INTO timing (stage_id, reference_id, timing_type, description)
-- VALUES
--     ((SELECT stage_id FROM stage WHERE stage_code = 'O-L1-PT'),
--      (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'),
--      'description',
--      'Two planting options: dormant rootstock planting with field grafting, or bench grafting indoors.');

-- INSERT INTO timing (stage_id, reference_id, timing_type, description)
-- VALUES
--     ((SELECT stage_id FROM stage WHERE stage_code = 'O-L1-YT'),
--      (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'),
--      'description',
--      'Approximately 5 to 7 years from planting.');


-- -- Insert observation data
-- INSERT INTO observation (stage_id, reference_id, description, item, value) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-L1-PT'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'   ), 'Standard grafting point height.', 'Grafting point height', 'Standard: 15 cm; M.9: 25-35 cm'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-L1-PT'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'   ), 'Preferred row orientation.', 'Row orientation', 'North-South'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-L1-PT'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'   ), 'Planting distance recommendation.', 'Planting distance', 'M.9: 100 cm between rows, 35 cm within rows'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-L1-YT'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'hampsonCanopyGrowthYield2002'   ), 'Increase in leaf canopy area.', 'Leaf canopy area', 'Increase observed'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-L1-YT'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'lordanLongtermEffectsTree2018'   ), 'Increase in light interception.', 'Light interception', 'Increase observed'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-L1-YT'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'   ), 'Start of flowering period varies.', 'Flowering', 'Depends on rootstock type'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-L1-MT'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'lordanLongtermEffectsTree2018'   ), 'Light interception rates by training system.', 'Light interception', '70% for V-shaped; 60% for conic-shaped'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-L1-MT'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'middletonProductivityPerformanceApple2002'   ), 'Range of leaf area index.', 'Leaf area index', '1.5 to 2.8'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-L1-MT'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'lordanLongtermEffectsTree2018'   ), 'Tree height by training system.', 'Tree height', '2.5-2.75m (V-shaped); 3.0-5.5m (conic-shaped)');

-- -- Insert key measurement data
-- INSERT INTO key_measurement (stage_id, reference_id, measurement_name) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-L1-PT'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'   ), 'Tree density'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-L1-PT'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'   ), 'Environmental conditions'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-L1-PT'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'   ), 'Soil moisture'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-L1-YT'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'   ), 'Trunk diameter'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-L1-YT'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'   ), 'Bud count'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-L1-MT'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'   ), 'Fruit yield'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-L1-MT'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'   ), 'Crop load');





-- INSERT INTO timing (stage_id, reference_id, timing_type, description, reference_timing, reference_timing_distance) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-DO-(00)-(00)'), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'), 'description', 'Trees enter dormancy in late summer or early autumn in most regions and resume growth in the following spring when temperature rises.', NULL, NULL),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-DO-(00)-(00)'), (SELECT id FROM reference_data WHERE bibtex_key = 'hauaggeAgeGrowingTemperatures1991'), 'description', 'Dormancy influenced by temperature and age factors.', NULL, NULL),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-DO-(00)-(00)'), (SELECT id FROM reference_data WHERE bibtex_key = 'mimidaFourTFL1CENlike2009'), 'description', 'Regulation of dormancy via TFL1/CEN-like genes.', NULL, NULL),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-DO-(00)-(00)'), (SELECT id FROM reference_data WHERE bibtex_key = 'moserMADSboxGeneMdDAM12020'), 'description', 'Dormancy transitions marked by MADS-box gene expression.', NULL, NULL);

-- INSERT INTO observation (stage_id, reference_id, description, item, value) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-DO-(00)-(00)'), (SELECT id FROM reference_data WHERE bibtex_key = 'langDormancyNewUniversal1987'), 'Temporary suspension of visible growth of plant structures containing a meristem.', 'Dormancy state', 'Suspension of growth'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-DO-(00)-(00)'), (SELECT id FROM reference_data WHERE bibtex_key = 'fadonConceptualFrameworkWinter2020'), 'Buds may enter dormancy while trees still carry foliage.', 'Bud dormancy with foliage', 'Possible occurrence'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-DO-(00)-(00)'), (SELECT id FROM reference_data WHERE bibtex_key = 'gonzaleznoguerAppleMalusDomestica2023'), 'Carbohydrate concentration peaks at endo-dormancy and decreases before bud break.', 'Carbohydrate concentration', 'Peak and subsequent decrease'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-DO-(00)-(00)'), (SELECT id FROM reference_data WHERE bibtex_key = 'gonzaleznoguerAppleMalusDomestica2023'), 'Starch content remains low and declines, with a peak at endodormancy release.', 'Starch content', 'Low, declining with peak at endo-dormancy release'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-DO-(00)-(00)'), (SELECT id FROM reference_data WHERE bibtex_key = 'sapkotaChangesReactiveOxygen2021'), 'Soluble sugar levels increase during dormancy.', 'Soluble sugars', 'Increase observed'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-DO-(00)-(00)'), NULL, 'Sorbitol concentrations increase with colder temperatures in apples.', 'Sorbitol concentrations', 'Increase with colder temperatures');

-- INSERT INTO key_measurement (stage_id, reference_id, measurement_name) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-DO-(00)-(00)'), NULL, 'Image'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-DO-(00)-(00)'), NULL, 'Bud fresh weight'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-DO-(00)-(00)'), NULL, 'Microscopy / bud dissection'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-DO-(00)-(00)'), NULL, 'Carbohydrate concentration'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-DO-(00)-(00)'), NULL, 'Tree characteristics (trunk diameter, tree height)'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-DO-(00)-(00)'), NULL, 'Temperature');


-- INSERT INTO timing (stage_id, reference_id, timing_type, description, reference_timing, reference_timing_distance) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-BD-(01-09)-(01-09)'), (SELECT id FROM reference_data WHERE bibtex_key = 'kurokuraRegulationSeasonalFlowering2013'), 'description', 'Occurs in spring, beginning just before inflorescence emergence. This phase continues for 24 days and concludes shortly after mid-flowering.', NULL, NULL),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-BD-(01-09)-(01-09)'), (SELECT id FROM reference_data WHERE bibtex_key = 'martinezPhenologicalGrowthStages2019'), 'description', 'Bud development phase spans BBCH stages 01, 03, 07, and 09.', NULL, NULL);

-- INSERT INTO observation (stage_id, reference_id, description, item, value) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-BD-(01-09)-(01-09)'), (SELECT id FROM reference_data WHERE bibtex_key = 'meierGrowthStagesMonoand1997'), 'Bud development begins with visibly swollen buds with elongated bud scales and light-colored patches (BBCH 01). Bud scales lighten and become hairy (BBCH 03). Bud break is marked by the appearance of green leaf tips (BBCH 07) and continues until these tips extend about 5 mm above the bud scales (BBCH 09).', 'Bud development progression', 'BBCH stages 01, 03, 07, 09'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-BD-(01-09)-(01-09)'), (SELECT id FROM reference_data WHERE bibtex_key = 'labuschagneSelectionIncreasedBudbreak2003'), 'Average bud break per shoot length.', 'Bud break number', '10 to 35 buds per 100 cm shoot length'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-BD-(01-09)-(01-09)'), NULL, 'Starch content decreases in both fine and coarse roots starting from bud break.', 'Starch content', 'Decrease after bud break'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-BD-(01-09)-(01-09)'), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'), 'Organic carbon reserves decrease from bud break to about 30 days after full bloom (DAFB); the greatest deficit occurs around 20 DAFB when fruit diameter is approximately 12 mm.', 'Carbon reserve trend', 'Decrease observed');

-- INSERT INTO key_measurement (stage_id, reference_id, measurement_name) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-BD-(01-09)-(01-09)'), NULL, 'Image'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-BD-(01-09)-(01-09)'), NULL, 'Bud count per TCSA or per tree'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-BD-(01-09)-(01-09)'), NULL, 'Bud strength (size, fresh mass, and dry mass)'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-BD-(01-09)-(01-09)'), NULL, 'Microscopy / bud dissection');

-- INSERT INTO timing (stage_id, reference_id, timing_type, description, reference_timing, reference_timing_distance) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-BD-(01-09)-(01-09)'), (SELECT id FROM reference_data WHERE bibtex_key = 'kurokuraRegulationSeasonalFlowering2013'), 'description', 'Occurs in spring, beginning just before inflorescence emergence. This phase continues for 24 days and concludes shortly after mid-flowering.', NULL, NULL),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-BD-(01-09)-(01-09)'), (SELECT id FROM reference_data WHERE bibtex_key = 'martinezPhenologicalGrowthStages2019'), 'description', 'Bud development phase spans BBCH stages 01, 03, 07, and 09.', NULL, NULL),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-LD-(10-19)-(10-19)'), (SELECT id FROM reference_data WHERE bibtex_key = 'loescherCarbohydrateReservesTranslocation1990'), 'description', 'Begins before bud break and continues for approximately 45 days to two months until all leaves are completely unfolded and expanded.', NULL, NULL),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-LD-(10-19)-(10-19)'), (SELECT id FROM reference_data WHERE bibtex_key = 'wunscheRelationshipLeafArea2000'), 'description', 'Leaf development and canopy growth are influenced by environmental factors, apple genetics, training systems, and canopy height.', NULL, NULL),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-LD-(10-19)-(10-19)'), (SELECT id FROM reference_data WHERE bibtex_key = 'martinezPhenologicalGrowthStages2019'), 'description', 'Includes BBCH stages 10, 11, 15, and 19.', NULL, NULL);

-- INSERT INTO observation (stage_id, reference_id, description, item, value) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-LD-(10-19)-(10-19)'), (SELECT id FROM reference_data WHERE bibtex_key = 'barrittCultivarCanopyPosition1990'), 'Leaf tip growth and unfolding significantly increase leaf area, influenced by cultivar and canopy position.', 'Leaf area increase', 'Significant growth observed'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-LD-(10-19)-(10-19)'), (SELECT id FROM reference_data WHERE bibtex_key = 'wunscheBasesProductivityApple1996'), 'Canopy growth begins with slight increase until bloom, followed by rapid expansion peaking around two months after bud break.', 'Canopy growth pattern', 'Rapid expansion observed'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-LD-(10-19)-(10-19)'), (SELECT id FROM reference_data WHERE bibtex_key = 'laksoLeafAreaDevelopment1984'), 'Factors influencing leaf area development include weather, genetics, training systems, and canopy height.', 'Influence factors', 'Various environmental and genetic influences');

-- INSERT INTO key_measurement (stage_id, reference_id, measurement_name) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-LD-(10-19)-(10-19)'), NULL, 'Image'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-LD-(10-19)-(10-19)'), NULL, 'Leaf area'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-LD-(10-19)-(10-19)'), NULL, 'Leaf area index (LAI)'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-LD-(10-19)-(10-19)'), NULL, 'Leaf dry weight'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-LD-(10-19)-(10-19)'), NULL, 'Leaf number'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-LD-(10-19)-(10-19)'), NULL, 'Light interception'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-LD-(10-19)-(10-19)'), NULL, 'Leaf nutrient content'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-LD-(10-19)-(10-19)'), NULL, 'Shoot length');


-- INSERT INTO timing (stage_id, reference_id, timing_type, description, reference_timing, reference_timing_distance) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-SD-(31-39)-(31-39)'), (SELECT id FROM reference_data WHERE bibtex_key = 'baiComparisonMachinelearningCasa2021'), 'description', 'Generally in mid-summer but can range widely from 40 to 90 days after full bloom, influenced by environmental conditions, tree genetics, vigor, and fruit behavior.', NULL, NULL),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-SD-(31-39)-(31-39)'), (SELECT id FROM reference_data WHERE bibtex_key = 'forsheyRelationshipVegetativeGrowth1989'), 'description', 'Shoot growth begins with visibility of developing shoot axes, followed by a sigmoid increase in shoot length.', NULL, NULL);

-- INSERT INTO observation (stage_id, reference_id, description, item, value) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-SD-(31-39)-(31-39)'), (SELECT id FROM reference_data WHERE bibtex_key = 'meierGrowthStagesMonoand1997'), 'Shoot growth follows a sigmoid pattern.', 'Shoot length', 'Sigmoid increase observed'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-SD-(31-39)-(31-39)'), (SELECT id FROM reference_data WHERE bibtex_key = 'riveroFloweringPhenologyInterrelations2017'), 'Shoot length increases progressively.', 'Shoot length progression', 'Increasing length');

-- INSERT INTO key_measurement (stage_id, reference_id, measurement_name) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-SD-(31-39)-(31-39)'), NULL, 'Image'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-SD-(31-39)-(31-39)'), NULL, 'Leaf area'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-SD-(31-39)-(31-39)'), NULL, 'Light interception'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-SD-(31-39)-(31-39)'), NULL, 'Leaf nutrient content'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-SD-(31-39)-(31-39)'), NULL, 'Shoot length'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-SD-(31-39)-(31-39)'), NULL, 'Trunk diameter');

-- INSERT INTO timing (stage_id, reference_id, timing_type, description, reference_timing, reference_timing_distance) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-IE-(51-59)-(51-59)'), (SELECT id FROM reference_data WHERE bibtex_key = 'martinezPhenologicalGrowthStages2019'), 'description', 'Begins prior to vegetative bud development, lasting for 28 days and concluding before vegetative development ends.', NULL, NULL),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-IE-(51-59)-(51-59)'), (SELECT id FROM reference_data WHERE bibtex_key = 'chituTimingPhenologicalStages2020'), 'description', 'From 1969 to 2018, the timing of floral bud swelling and bud burst has advanced by 13.8 and 14.8 days, respectively.', NULL, NULL);

-- INSERT INTO observation (stage_id, reference_id, description, item, value) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-IE-(51-59)-(51-59)'), (SELECT id FROM reference_data WHERE bibtex_key = 'meierGrowthStagesMonoand1997'), 'Floral bud development stages include swollen buds with elongated scales (BBCH 51), scales that lighten and grow hairy (BBCH 52), bud burst with visible flowers (BBCH 53), pink stage with elongating petals and opening sepals (BBCH 57), and hollow ball formation at culmination (BBCH 59).', 'Floral bud development progression', 'Sequential stages from BBCH 51 to BBCH 59');

-- INSERT INTO key_measurement (stage_id, reference_id, measurement_name) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-IE-(51-59)-(51-59)'), NULL, 'Image'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-IE-(51-59)-(51-59)'), NULL, 'Buds per unit of trunk cross-sectional area or per tree'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-IE-(51-59)-(51-59)'), NULL, 'Record timing for different phases'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-IE-(51-59)-(51-59)'), NULL, 'IPDM assessment of pest and diseases'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-IE-(51-59)-(51-59)'), (SELECT id FROM reference_data WHERE bibtex_key = 'kamoutsisAppleMalusDomestica2023'), 'Temperature'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-IE-(51-59)-(51-59)'), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'), 'Light Intensity');


-- INSERT INTO timing (stage_id, reference_id, timing_type, description, reference_timing, reference_timing_distance) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FL-(60-69)-(60-69)'), (SELECT id FROM reference_data WHERE bibtex_key = 'martinezPhenologicalGrowthStages2019'), 'description', 'Occurs in spring after flower emergence with a staggered bloom lasting several weeks, typically mid-April.', NULL, NULL),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FL-(60-69)-(60-69)'), (SELECT id FROM reference_data WHERE bibtex_key = 'kurokuraRegulationSeasonalFlowering2013'), 'description', 'Flowering dates vary by more than 30 days among cultivars, with staggered blooming.', NULL, NULL);

-- INSERT INTO observation (stage_id, reference_id, description, item, value) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FL-(60-69)-(60-69)'), (SELECT id FROM reference_data WHERE bibtex_key = 'malladiMolecularPhysiologyFruit2020'), 'Flower growth temporarily ceases before blooming and resumes after successful pollination and fertilization.', 'Flower growth cycle', 'Interruption before blooming and resumption post-fertilization'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FL-(60-69)-(60-69)'), (SELECT id FROM reference_data WHERE bibtex_key = 'musacchiAppleFruitQuality2018'), 'Number of cells in flowers.', 'Cell count in flowers', 'Approximately 3–6 million cells'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FL-(60-69)-(60-69)'), (SELECT id FROM reference_data WHERE bibtex_key = 'doganGrowthFruitBearing2024a'), 'Number of flowers in a cluster.', 'Flowers per cluster', '5.5 to 5.9'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FL-(60-69)-(60-69)'), (SELECT id FROM reference_data WHERE bibtex_key = 'meierGrowthStagesMonoand1997'), 'Bloom percentage at different stages.', 'Bloom percentage', 'BBCH 61: ~10%; BBCH 65: >50% petal fall');

-- INSERT INTO key_measurement (stage_id, reference_id, measurement_name) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FL-(60-69)-(60-69)'), NULL, 'Flower count (buds per unit of trunk cross-sectional area or per tree)'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FL-(60-69)-(60-69)'), NULL, 'Flower cluster'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FL-(60-69)-(60-69)'), NULL, 'Flower formation rate'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FL-(60-69)-(60-69)'), NULL, 'Bloom percentage (%)'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FL-(60-69)-(60-69)'), NULL, 'Timing for different phases'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FL-(60-69)-(60-69)'), NULL, 'Light interception'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FL-(60-69)-(60-69)'), NULL, 'Temperature');

-- INSERT INTO timing (stage_id, reference_id, timing_type, description, reference_timing, reference_timing_distance) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-SC-91'), (SELECT id FROM reference_data WHERE bibtex_key = 'baiComparisonMachinelearningCasa2021'), 'description', 'Generally occurs in mid-summer, with shoot growth completion varying by shoot type; fruit-bearing shoots stop 3-5 weeks after bud burst, skeletal shoots may continue for months.', NULL, NULL),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-SC-91'), (SELECT id FROM reference_data WHERE bibtex_key = 'benkoMorphologicalDifferentiationFlower1967'), 'description', 'Shoot completion marked by terminal bud formation while foliage remains green.', NULL, NULL);

-- INSERT INTO observation (stage_id, reference_id, description, item, value) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-SC-91'), (SELECT id FROM reference_data WHERE bibtex_key = 'meierGrowthStagesMonoand1997'), 'Shoot growth completion indicated by terminal bud formation.', 'Shoot termination marker', 'Terminal bud formed with green foliage');

-- INSERT INTO key_measurement (stage_id, reference_id, measurement_name) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-SC-91'), NULL, 'Shoot length');

-- INSERT INTO timing (stage_id, reference_id, timing_type, description, reference_timing, reference_timing_distance) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FBF-X'), (SELECT id FROM reference_data WHERE bibtex_key = 'koflerHighCropLoad2019'), 'description', 'Flower bud formation for the subsequent season occurs simultaneously with fruit growth during the current season.', NULL, NULL),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FBF-X'), (SELECT id FROM reference_data WHERE bibtex_key = 'jonkersBiennialBearingApple1979'), 'description', 'Flower bud formation influenced by fruit behavior, branch type, apple genetics, shoot growth, pruning, and growth regulators.', NULL, NULL);

-- INSERT INTO observation (stage_id, reference_id, description, item, value) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FBF-X'), (SELECT id FROM reference_data WHERE bibtex_key = 'meierGrowthStagesMonoand1997'), 'Vegetative meristems transition into floral meristems.', 'Meristem transition', 'Sequential commitment to floral formation'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FBF-X'), (SELECT id FROM reference_data WHERE bibtex_key = 'verheijMorphologicalPhysiologicalAspects1996'), 'Low gibberellic acid levels observed during floral commitment.', 'Gibberellic acid level', 'Low');

-- INSERT INTO key_measurement (stage_id, reference_id, measurement_name) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FBF-X'), NULL, 'Microscopy / bud dissection'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FBF-X'), NULL, 'Histological measurements'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FBF-X'), NULL, 'Hormone level'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FBF-X'), NULL, 'Metabolic analysis of bud samples'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FBF-X'), (SELECT id FROM reference_data WHERE bibtex_key = 'riveroFloweringPhenologyInterrelations2017'), 'Temperature, precipitation, irradiance');

-- INSERT INTO timing (stage_id, reference_id, timing_type, description, reference_timing, reference_timing_distance) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FD-(71-79)'), (SELECT id FROM reference_data WHERE bibtex_key = 'martinezPhenologicalGrowthStages2019'), 'description', 'Fruit development occurs from summer to autumn and lasts over 160 days.', NULL, NULL);

-- INSERT INTO observation (stage_id, reference_id, description, item, value) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FD-(71-79)'), (SELECT id FROM reference_data WHERE bibtex_key = 'meierGrowthStagesMonoand1997'), 'Fruit growth follows an expolinear pattern.', 'Fruit size', 'Continuous increase'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FD-(71-79)'), (SELECT id FROM reference_data WHERE bibtex_key = 'arseneaultReviewApplePreharvest2016'), 'Timing of fruit drops.', 'First fruit drop', '3-4 weeks after full bloom'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FD-(71-79)'), (SELECT id FROM reference_data WHERE bibtex_key = 'arseneaultReviewApplePreharvest2016'), 'Timing of fruit drops.', 'Second fruit drop', '4-6 weeks after full bloom');

-- INSERT INTO key_measurement (stage_id, reference_id, measurement_name) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FD-(71-79)'), NULL, 'Image'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FD-(71-79)'), NULL, 'Fruit firmness'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FD-(71-79)'), NULL, 'Fruit size'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FD-(71-79)'), NULL, 'Fruit weight'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FD-(71-79)'), NULL, 'Starch content');


-- INSERT INTO timing (stage_id, reference_id, timing_type, description, reference_timing, reference_timing_distance) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FM-(81-89)'), (SELECT id FROM reference_data WHERE bibtex_key = 'martinezPhenologicalGrowthStages2019'), 'description', 'Maturity of fruit and seed lasts around 40 days from initial color change to full development.', NULL, NULL);

-- INSERT INTO observation (stage_id, reference_id, description, item, value) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FM-(81-89)'), (SELECT id FROM reference_data WHERE bibtex_key = 'meierGrowthStagesMonoand1997'), 'Fruit color progression from initial appearance to fully developed color.', 'Fruit color', 'Transitions to full development');

-- INSERT INTO key_measurement (stage_id, reference_id, measurement_name) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FM-(81-89)'), NULL, 'Image'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FM-(81-89)'), NULL, 'Firmness'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FM-(81-89)'), NULL, 'Color'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FM-(81-89)'), NULL, 'Starch content');


-- INSERT INTO timing (stage_id, reference_id, timing_type, description, reference_timing, reference_timing_distance) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-SN-(92-97)'), (SELECT id FROM reference_data WHERE bibtex_key = 'martinezPhenologicalGrowthStages2019'), 'description', 'Leaf senescence occurs in autumn and lasts around 118 days including the winter rest period.', NULL, NULL);

-- INSERT INTO observation (stage_id, reference_id, description, item, value) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-SN-(92-97)'), (SELECT id FROM reference_data WHERE bibtex_key = 'esperancaInductionSenescenceFoliar2019'), 'Chlorophyll degradation and leaf drop mark this stage.', 'Leaf condition', 'Chlorophyll reduction and falling leaves');

-- INSERT INTO key_measurement (stage_id, reference_id, measurement_name) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-SN-(92-97)'), NULL, 'Image'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-SN-(92-97)'), NULL, 'Photosynthesis rate'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-SN-(92-97)'), NULL, 'Chlorophyll content'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-SN-(92-97)'), NULL, 'Leaf nutrient content');


-- INSERT INTO timing (stage_id, reference_id, timing_type, description, reference_timing, reference_timing_distance) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-DO-(00)-PD-X'), (SELECT id FROM reference_data WHERE bibtex_key = 'moserMADSboxGeneMdDAM12020'), 'description', 'Para-dormancy begins in late summer and is controlled by internal tree conditions.', NULL, NULL);

-- INSERT INTO observation (stage_id, reference_id, description, item, value) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-DO-(00)-PD-X'), (SELECT id FROM reference_data WHERE bibtex_key = 'fadonConceptualFrameworkWinter2020'), 'Carbohydrate storage behavior during para-dormancy.', 'Carbohydrate concentration', 'Increase observed');

-- INSERT INTO key_measurement (stage_id, reference_id, measurement_name) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-DO-(00)-PD-X'), NULL, 'Carbohydrate concentration'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-DO-(00)-PD-X'), NULL, 'Temperature'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-DO-(00)-PD-X'), NULL, 'Apical dominance observation');

-- INSERT INTO timing (stage_id, reference_id, timing_type, description, reference_timing, reference_timing_distance) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-DO-(00)-ED-X'), (SELECT id FROM reference_data WHERE bibtex_key = 'parkesChillingRequirementsApple2020'), 'description', 'Endo-dormancy occurs during autumn and winter, requiring chilling accumulation for bud break.', NULL, NULL);

-- INSERT INTO observation (stage_id, reference_id, description, item, value) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-DO-(00)-ED-X'), (SELECT id FROM reference_data WHERE bibtex_key = 'fadonConceptualFrameworkWinter2020'), 'Changes in sugar and starch levels during endo-dormancy.', 'Sugar and starch balance', 'Sugar increases, starch decreases');

-- INSERT INTO key_measurement (stage_id, reference_id, measurement_name) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-DO-(00)-ED-X'), NULL, 'Carbohydrate concentration'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-DO-(00)-ED-X'), NULL, 'Sugar levels'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-DO-(00)-ED-X'), NULL, 'Starch levels'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-DO-(00)-ED-X'), NULL, 'Temperature monitoring');




-- INSERT INTO timing (stage_id, reference_id, timing_type, description, reference_timing, reference_timing_distance) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-DO-(00)-ED-X'), (SELECT id FROM reference_data WHERE bibtex_key = 'parkesChillingRequirementsApple2020'), 'description', 'Endo-dormancy occurs during autumn and winter, requiring chilling accumulation for bud break.', NULL, NULL),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-DO-(00)-EC-X'), (SELECT id FROM reference_data WHERE bibtex_key = 'moserMADSboxGeneMdDAM12020'), 'description', 'Eco-dormancy concludes by the end of winter or early spring as heat requirements are met.', NULL, NULL);

-- INSERT INTO observation (stage_id, reference_id, description, item, value) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-DO-(00)-ED-X'), (SELECT id FROM reference_data WHERE bibtex_key = 'fadonConceptualFrameworkWinter2020'), 'Changes in sugar and starch levels during endo-dormancy.', 'Sugar and starch balance', 'Sugar increases, starch decreases'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-DO-(00)-EC-X'), (SELECT id FROM reference_data WHERE bibtex_key = 'fadonConceptualFrameworkWinter2020'), 'End of dormancy marked by carbohydrate adjustment according to environmental conditions.', 'Carbohydrate levels', 'Adjusted for environmental conditions');

-- INSERT INTO key_measurement (stage_id, reference_id, measurement_name) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-DO-(00)-ED-X'), NULL, 'Carbohydrate concentration'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-DO-(00)-ED-X'), NULL, 'Sugar levels'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-DO-(00)-ED-X'), NULL, 'Starch levels'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-DO-(00)-ED-X'), NULL, 'Temperature monitoring'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-DO-(00)-EC-X'), NULL, 'Carbohydrate concentration'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-DO-(00)-EC-X'), NULL, 'Sugar levels'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-DO-(00)-EC-X'), NULL, 'Starch levels'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-DO-(00)-EC-X'), NULL, 'Temperature monitoring');

-- INSERT INTO timing (stage_id, reference_id, timing_type, description, reference_timing, reference_timing_distance) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FI-X'), (SELECT id FROM reference_data WHERE bibtex_key = 'hankeNoFlowerNo2007'), 'description', 'Flower induction occurs around mid-June in the Northern Hemisphere.', NULL, NULL),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FBF-IN-X'), (SELECT id FROM reference_data WHERE bibtex_key = 'wilkieRegulationFloralInitiation2008a'), 'description', 'Flower initiation begins in summer, leading to morphological changes.', NULL, NULL);

-- INSERT INTO observation (stage_id, reference_id, description, item, value) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FI-X'), (SELECT id FROM reference_data WHERE bibtex_key = 'milyaevProfilingPhytohormonesApple2022'), 'No visible morphological changes during flower induction.', 'Flower induction visibility', 'None'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FBF-IN-X'), (SELECT id FROM reference_data WHERE bibtex_key = 'hirstRootstockEffectsFlowering1995'), 'Shoot apex broadening and doming in sequential development.', 'Apex morphological change', 'Sequential broadening and doming');

-- INSERT INTO key_measurement (stage_id, reference_id, measurement_name) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FI-X'), NULL, 'Hormonal analysis'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FI-X'), NULL, 'Gene expression profiling'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FBF-IN-X'), NULL, 'Microscopy / bud dissection'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FBF-IN-X'), NULL, 'Histological measurements'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FBF-IN-X'), NULL, 'Temperature monitoring');


-- INSERT INTO timing (stage_id, reference_id, timing_type, description, reference_timing, reference_timing_distance) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FI-X'), (SELECT id FROM reference_data WHERE bibtex_key = 'hankeNoFlowerNo2007'), 'description', 'Flower induction occurs around mid-June in the Northern Hemisphere.', NULL, NULL),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FBF-IN-X'), (SELECT id FROM reference_data WHERE bibtex_key = 'wilkieRegulationFloralInitiation2008a'), 'description', 'Flower initiation begins in summer, leading to morphological changes.', NULL, NULL),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FBF-BD-X'), (SELECT id FROM reference_data WHERE bibtex_key = 'mcartneySeasonalVariationOnset2001'), 'description', 'Bud differentiation starts in summer and completes before dormancy, varying between 15 to 22 weeks after full bloom.', NULL, NULL),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FD-CD-X'), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'), 'description', 'Cell division begins after flowering and continues for about 4 to 6 weeks.', NULL, NULL);

-- INSERT INTO observation (stage_id, reference_id, description, item, value) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FI-X'), (SELECT id FROM reference_data WHERE bibtex_key = 'milyaevProfilingPhytohormonesApple2022'), 'No visible morphological changes during flower induction.', 'Flower induction visibility', 'None'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FBF-IN-X'), (SELECT id FROM reference_data WHERE bibtex_key = 'hirstRootstockEffectsFlowering1995'), 'Shoot apex broadening and doming in sequential development.', 'Apex morphological change', 'Sequential broadening and doming'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FBF-BD-X'), (SELECT id FROM reference_data WHERE bibtex_key = 'fosterMorphologicalQuantitativeCharacterization2003'), 'Sequential development of floral organs within buds.', 'Floral organ formation sequence', 'Sequential order: sepals, petals, stamens, carpels'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FD-CD-X'), (SELECT id FROM reference_data WHERE bibtex_key = 'malladiMolecularPhysiologyFruit2020'), 'Cell number increases during early fruit development.', 'Cell number change', 'Increase observed');

-- INSERT INTO key_measurement (stage_id, reference_id, measurement_name) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FI-X'), NULL, 'Hormonal analysis'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FI-X'), NULL, 'Gene expression profiling'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FBF-IN-X'), NULL, 'Microscopy / bud dissection'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FBF-IN-X'), NULL, 'Histological measurements'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FBF-IN-X'), NULL, 'Temperature monitoring'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FBF-BD-X'), NULL, 'Microscopy / bud dissection'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FBF-BD-X'), NULL, 'Histological measurements'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FBF-BD-X'), NULL, 'Temperature monitoring'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FD-CD-X'), NULL, 'Cell number index (CNI)'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FD-CD-X'), NULL, 'Cell and cell space size index (CSSI)'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FD-CD-X'), NULL, 'Temperature monitoring'),
-- ((SELECT stage_id FROM stage WHERE stage_code = 'O-AR-FD-CD-X'), NULL, 'Light measurement');
