DROP TABLE IF EXISTS stage;
DROP TABLE IF EXISTS timing;
DROP TABLE IF EXISTS observation;
DROP TABLE IF EXISTS key_measurement;


-- 2. Stage table
CREATE TABLE stage (
    stage_id SERIAL PRIMARY KEY,
    stage_code VARCHAR(50) UNIQUE NOT NULL,
    stage_name TEXT,
    description TEXT
);

-- 3. Timing table (two types: either description or timing reference with distance)
CREATE TABLE timing (
    timing_id SERIAL PRIMARY KEY,
    stage_id INT REFERENCES stage(stage_id),
    reference_id INT REFERENCES reference_data(id),
    timing_type VARCHAR(20) CHECK (timing_type IN ('description', 'reference')) NOT NULL,
    description TEXT,
    reference_timing TEXT,
    reference_timing_distance TEXT
);

-- 4. Observation table
CREATE TABLE observation (
    observation_id SERIAL PRIMARY KEY,
    stage_id INT REFERENCES stage(stage_id),
    reference_id INT REFERENCES reference_data(id),
    description TEXT,
    item TEXT,
    value TEXT
);

-- 5. Key measurement table
CREATE TABLE key_measurement (
    measurement_id SERIAL PRIMARY KEY,
    stage_id INT REFERENCES stage(stage_id),
    reference_id INT REFERENCES reference_data(id),
    measurement_name TEXT NOT NULL,
    unit TEXT,
    value_range TEXT,
    calculation_method TEXT
);

-- Insert stage data
INSERT INTO stage (stage_code, stage_name) VALUES
('N-L1-SG', 'Seed Germination'),
('N-L1-JV', 'Juvenile Period'),
('N-L1-TR', 'Transition Period'),
('N-L1-RP', 'Reproductive Phase'),
('N-L1-AG', 'Aging');

-- Insert provided timing data
INSERT INTO timing (stage_id, reference_id, timing_type, description, reference_timing, reference_timing_distance) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'N-L1-SG'), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'), 'description', 'Spring', NULL, NULL),
((SELECT stage_id FROM stage WHERE stage_code = 'N-L1-JV'), (SELECT id FROM reference_data WHERE bibtex_key = 'visserJuvenilePhaseGrowth1964'), 'description', '4-12 years from sowing to first bloom', NULL, NULL),
((SELECT stage_id FROM stage WHERE stage_code = 'N-L1-TR'), (SELECT id FROM reference_data WHERE bibtex_key = 'zhangPotentialPolyphenolMarkers2007'), 'reference', NULL, 'Full bloom', '10 days'),
((SELECT stage_id FROM stage WHERE stage_code = 'N-L1-RP'), (SELECT id FROM reference_data WHERE bibtex_key = 'kotodaFloweringJuvenilityApple2021'), 'reference', NULL, 'After node number >122', NULL),
((SELECT stage_id FROM stage WHERE stage_code = 'N-L1-AG'), (SELECT id FROM reference_data WHERE bibtex_key = 'greenwoodMaturationDevelopmentalProcess1993'), 'description', 'Post peak fruit production period', NULL, NULL);

-- Insert provided observation data
INSERT INTO observation (stage_id, reference_id, description, item, value) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'N-L1-JV'), (SELECT id FROM reference_data WHERE bibtex_key = 'zimmermanHormonalAspectsPhase1985'), 'Inability to flower', 'Flowering', 'Not present'),
((SELECT stage_id FROM stage WHERE stage_code = 'N-L1-JV'), (SELECT id FROM reference_data WHERE bibtex_key = 'zimmermanHormonalAspectsPhase1985'), 'Adventitious roots observed', 'Adventitious roots', 'Present'),
((SELECT stage_id FROM stage WHERE stage_code = 'N-L1-JV'), (SELECT id FROM reference_data WHERE bibtex_key = 'zhangPotentialPolyphenolMarkers2007'), 'Node number observation', 'Node number', 'Up to 77'),
((SELECT stage_id FROM stage WHERE stage_code = 'N-L1-TR'), (SELECT id FROM reference_data WHERE bibtex_key = 'zhangPotentialPolyphenolMarkers2007'), 'Node number observation', 'Node number', '77 to 122'),
((SELECT stage_id FROM stage WHERE stage_code = 'N-L1-RP'), (SELECT id FROM reference_data WHERE bibtex_key = 'zhangPotentialPolyphenolMarkers2007'), 'Node number observation', 'Node number', 'Above 122'),
((SELECT stage_id FROM stage WHERE stage_code = 'N-L1-RP'), (SELECT id FROM reference_data WHERE bibtex_key = 'kotodaFloweringJuvenilityApple2021'), 'Myricitrin absence', 'Myricitrin', 'Disappeared'),
((SELECT stage_id FROM stage WHERE stage_code = 'N-L1-AG'), (SELECT id FROM reference_data WHERE bibtex_key = 'wareingProblemsJuvenilityFlowering1959'), 'Growth rate slow', 'Growth rate', 'Slow'),
((SELECT stage_id FROM stage WHERE stage_code = 'N-L1-AG'), (SELECT id FROM reference_data WHERE bibtex_key = 'wareingProblemsJuvenilityFlowering1959'), 'Terminal growing point increase', 'Terminal growing point', 'Increased');

-- Insert provided key measurement data
INSERT INTO key_measurement (stage_id, reference_id, measurement_name) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'N-L1-SG'), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'), 'Environmental condition'),
((SELECT stage_id FROM stage WHERE stage_code = 'N-L1-SG'), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'), 'Soil pH'),
((SELECT stage_id FROM stage WHERE stage_code = 'N-L1-SG'), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'), 'Soil moisture'),
((SELECT stage_id FROM stage WHERE stage_code = 'N-L1-SG'), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'), 'Temperature'),
((SELECT stage_id FROM stage WHERE stage_code = 'N-L1-JV'), (SELECT id FROM reference_data WHERE bibtex_key = 'zhangPotentialPolyphenolMarkers2007'), 'Node number'),
((SELECT stage_id FROM stage WHERE stage_code = 'N-L1-JV'), (SELECT id FROM reference_data WHERE bibtex_key = 'trederResponseYoungApple2004'), 'Trunk diameter'),
((SELECT stage_id FROM stage WHERE stage_code = 'N-L1-TR'), (SELECT id FROM reference_data WHERE bibtex_key = 'zhangPotentialPolyphenolMarkers2007'), 'Node number'),
((SELECT stage_id FROM stage WHERE stage_code = 'N-L1-TR'), (SELECT id FROM reference_data WHERE bibtex_key = 'zhangPotentialPolyphenolMarkers2007'), 'Biochemical markers'),
((SELECT stage_id FROM stage WHERE stage_code = 'N-L1-RP'), (SELECT id FROM reference_data WHERE bibtex_key = 'zhangPotentialPolyphenolMarkers2007'), 'Node number'),
((SELECT stage_id FROM stage WHERE stage_code = 'N-L1-RP'), (SELECT id FROM reference_data WHERE bibtex_key = 'kotodaFloweringJuvenilityApple2021'), 'Biochemical markers'),
((SELECT stage_id FROM stage WHERE stage_code = 'N-L1-AG'), (SELECT id FROM reference_data WHERE bibtex_key = 'wareingProblemsJuvenilityFlowering1959'), 'Growth rate'),
((SELECT stage_id FROM stage WHERE stage_code = 'N-L1-AG'), (SELECT id FROM reference_data WHERE bibtex_key = 'wareingProblemsJuvenilityFlowering1959'), 'Terminal growing point');


Insert stage data for Orchard lifecycle stages
INSERT INTO stage (stage_code, stage_name, description) VALUES
('O-L1-PT', 'Planting Tree', 'Grafted tree composed of scion and rootstock, with mature scion capable of flowering. For high-density orchards, dwarfing rootstocks are preferred.'),
('O-L1-YT', 'Young Tree', 'Tree exhibits vigorous growth, and branches fill the allotted space.'),
('O-L1-MT', 'Mature Tree', 'Trees maintain their canopy within the allotted space, exhibit regular flowering, and consistently achieve high and stable yield under effective management.'),
('O-L1-EP', 'End of Productive Life', 'Tree vigor declines, requiring rejuvenation or replacement.');

-- Insert timing data
INSERT INTO timing (stage_id, reference_id, timing_type, description) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'O-L1-PT'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'), 'description', 'Two planting options: dormant rootstock planting with field grafting, or bench grafting indoors.', NULL, NULL),
((SELECT stage_id FROM stage WHERE stage_code = 'O-L1-YT'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'   ), 'description', 'Approximately 5 to 7 years from planting.', NULL, NULL),
((SELECT stage_id FROM stage WHERE stage_code = 'O-L1-MT'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'   ), 'description', 'Begins around the 6th year after planting.', NULL, NULL);

-- Insert observation data
INSERT INTO observation (stage_id, reference_id, description, item, value) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'O-L1-PT'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'   ), 'Standard grafting point height.', 'Grafting point height', 'Standard: 15 cm; M.9: 25-35 cm'),
((SELECT stage_id FROM stage WHERE stage_code = 'O-L1-PT'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'   ), 'Preferred row orientation.', 'Row orientation', 'North-South'),
((SELECT stage_id FROM stage WHERE stage_code = 'O-L1-PT'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'   ), 'Planting distance recommendation.', 'Planting distance', 'M.9: 100 cm between rows, 35 cm within rows'),
((SELECT stage_id FROM stage WHERE stage_code = 'O-L1-YT'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'hampsonCanopyGrowthYield2002'   ), 'Increase in leaf canopy area.', 'Leaf canopy area', 'Increase observed'),
((SELECT stage_id FROM stage WHERE stage_code = 'O-L1-YT'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'lordanLongtermEffectsTree2018'   ), 'Increase in light interception.', 'Light interception', 'Increase observed'),
((SELECT stage_id FROM stage WHERE stage_code = 'O-L1-YT'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'   ), 'Start of flowering period varies.', 'Flowering', 'Depends on rootstock type'),
((SELECT stage_id FROM stage WHERE stage_code = 'O-L1-MT'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'lordanLongtermEffectsTree2018'   ), 'Light interception rates by training system.', 'Light interception', '70% for V-shaped; 60% for conic-shaped'),
((SELECT stage_id FROM stage WHERE stage_code = 'O-L1-MT'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'middletonProductivityPerformanceApple2002'   ), 'Range of leaf area index.', 'Leaf area index', '1.5 to 2.8'),
((SELECT stage_id FROM stage WHERE stage_code = 'O-L1-MT'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'lordanLongtermEffectsTree2018'   ), 'Tree height by training system.', 'Tree height', '2.5-2.75m (V-shaped); 3.0-5.5m (conic-shaped)');

-- Insert key measurement data
INSERT INTO key_measurement (stage_id, reference_id, measurement_name) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'O-L1-PT'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'   ), 'Tree density'),
((SELECT stage_id FROM stage WHERE stage_code = 'O-L1-PT'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'   ), 'Environmental conditions'),
((SELECT stage_id FROM stage WHERE stage_code = 'O-L1-PT'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'   ), 'Soil moisture'),
((SELECT stage_id FROM stage WHERE stage_code = 'O-L1-YT'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'   ), 'Trunk diameter'),
((SELECT stage_id FROM stage WHERE stage_code = 'O-L1-YT'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'   ), 'Bud count'),
((SELECT stage_id FROM stage WHERE stage_code = 'O-L1-MT'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'   ), 'Fruit yield'),
((SELECT stage_id FROM stage WHERE stage_code = 'O-L1-MT'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'   ), 'Crop load');



INSERT INTO stage (stage_code, stage_name, description) VALUES
('O-AR-DO-(00)-(00)', 'Dormancy', 'Temporary suspension of visible growth with changes in carbohydrate, starch, and soluble sugar content.'),
('O-AR-DO-(00)-PD-X', 'Para-dormancy', 'Dormancy controlled by internal conditions with carbohydrate buildup.'),
('O-AR-DO-(00)-ED-X', 'Endo-dormancy', 'Winter dormancy stage that requires chilling accumulation to break.'),
('O-AR-DO-(00)-EC-X', 'Eco-dormancy', 'Dormancy stage limited by external environmental conditions.'),

('O-AR-BD-(01-09)-(01-09)', 'Bud Development', 'Progressive development of buds from swelling to bud break.'),
('O-AR-BD-(01-09)-LS-(01-03)', 'Leaf Bud Swelling', 'Stage where bud scales elongate and lighten, preparing for break.'),
('O-AR-BD-(01-09)-BB-09', 'Bud Break', 'Appearance of green leaf tips indicating bud break.'),

('O-AR-LD-(10-19)-(10-19)', 'Leaf Development', 'Rapid leaf unfolding and expansion phase.'),
('O-AR-SD-(31-39)-(31-39)', 'Shoot Development', 'Shoot elongation following a sigmoid growth pattern.'),

('O-AR-IE-(51-59)-(51-59)', 'Inflorescence Emergence', 'Floral bud development culminating in visible flowers.'),
('O-AR-IE-(51-59)-FS-55', 'Floral Bud Swelling', 'Stage where floral buds swell prominently.'),
('O-AR-IE-(51-59)-BB-57', 'Bud Burst', 'Emergence of green leaf tips and visible flowers.'),
('O-AR-IE-(51-59)-PB-59', 'Pink Bud Stage', 'Petal elongation and sepals opening just before flowering.'),
('O-AR-IE-(51-59)-HB-X', 'Hollow Ball Formation', 'Flowers form a hollow ball shape at stage culmination.'),

('O-AR-FL-(60-69)-(60-69)', 'Flowering', 'Progressive flower bloom with overlapping phases.'),
('O-AR-FL-(60-69)-FF-60', 'First Flower', 'Opening of first flowers in the orchard.'),
('O-AR-FL-(60-69)-PO-65', 'Pollination', 'Transfer of pollen grains between flowers.'),
('O-AR-FL-(60-69)-FE-67', 'Fertilisation', 'Union of gametes resulting in zygote formation.'),
('O-AR-FL-(60-69)-FS-69', 'Fruit Set', 'Formation of fruit following successful fertilisation.'),
('O-AR-FL-(60-69)-FB-65', 'Full Bloom / Anthesis', 'Peak flowering period with maximum open blooms.'),
('O-AR-FL-(60-69)-EP-69', 'End of Flowering', 'Petal fall indicating flowering completion.'),

('O-AR-FBF-X', 'Flower Bud Formation for Next Season', 'Development of floral meristems for the following season.'),
('O-AR-FBF-FI-X', 'Flower Induction', 'Initial physiological commitment to floral formation.'),
('O-AR-FBF-IN-X', 'Flower Initiation', 'Early morphological changes indicating floral development.'),
('O-AR-FBF-BD-X', 'Bud Differentiation', 'Complex differentiation within the floral bud structure.'),

('O-AR-FD-(71-79)', 'Fruit Development', 'Fruit growth phase with size increase and physiological changes.'),
('O-AR-FD-FS-(71-76)', 'Fruit Size Increase', 'Rapid fruit expansion and growth.'),
('O-AR-FD-CD-X', 'Cell Division', 'Cell multiplication contributing to fruit growth.'),
('O-AR-FD-CE-X', 'Cell Enlargement', 'Cell expansion and volume increase.'),
('O-AR-FD-F1-77', 'First Fruit Fall', 'Initial drop of unviable or excess fruitlets.'),
('O-AR-FD-F2-79', 'Second Fruit Fall', 'Subsequent natural thinning of fruits.'),
('O-AR-FD-SC-91', 'Shoot Growth Completed', 'Cessation of shoot elongation.'),

('O-AR-FM-(81-89)', 'Maturity of Fruit and Seed', 'Final ripening stage for fruit and seeds.'),
('O-AR-FM-RS-81', 'Beginning of Ripening', 'Initial stages of fruit coloration and ripening.'),
('O-AR-FM-CO-85', 'Advanced Coloring', 'Deepening of fruit color indicating ripeness.'),
('O-AR-FM-HV-87', 'Fruit Harvest', 'Harvest-ready stage of fruits.'),

('O-AR-SN-(92-97)', 'Senescence', 'Progressive leaf senescence and drop.'),
('O-AR-SN-LD-91', 'Leaves Begin to Discolor', 'Initial color change in leaves.'),
('O-AR-SN-LF-93', 'Beginning of Leaf Fall', 'Start of significant leaf drop.'),
('O-AR-SN-50-95', '50% Leaves Discolored', 'Midway point of leaf discoloration.'),
('O-AR-SN-AF-97', 'All Leaves Fallen', 'Completion of leaf fall and onset of dormancy.');


