DROP TABLE IF EXISTS timing;
DROP TABLE IF EXISTS observation;
DROP TABLE IF EXISTS key_measurement;
DROP TABLE IF EXISTS guidereference;
DROP TABLE IF EXISTS operation;
DROP TABLE IF EXISTS general_operation;
DROP TABLE IF EXISTS stage;



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

CREATE TABLE general_operation (
    general_operation_id SERIAL PRIMARY KEY,
    stage_id INT REFERENCES stage(stage_id),
    reference_id INT REFERENCES reference_data(id),
    description TEXT
);

CREATE TABLE guidereference (
    guidereference_id SERIAL PRIMARY KEY,
    operation_id INT REFERENCES operation(operation_id) ON DELETE CASCADE,
    third_party_database TEXT NOT NULL,
    link TEXT NOT NULL,
    page_number TEXT
);;

CREATE TABLE operation (
    operation_id SERIAL PRIMARY KEY,
    stage_id INT REFERENCES stage(stage_id),
    reference_id INT REFERENCES reference_data(id),
    description TEXT,
    section TEXT CHECK (section IN (
        'Thinning',
        'Pruning & Training',
        'Nutrient management',
        'Plant growth regulator',
        'Irrigation',
        'Orchard floor management',
        'Environmental stress management',
        'IPDM',
        'Modify Landscape',
        'Soil chemical management',
        'Tillage',
        'Disease management',
        'Apply Material to Adjust Soil Condition',
        'Perform Tillage',
        'Fertilization'
    )),
    subsection TEXT
);



INSERT INTO stage (stage_code, stage_name) VALUES
('NDG00', 'Seed Germination'),
('NDG01', 'Juvenile Period'),
('NDG02', 'Transition Period'),
('NDG03', 'Reproductive Phase'),
('NDG04', 'Aging');


INSERT INTO timing (stage_id, reference_id, timing_type, description)
VALUES
    ((SELECT stage_id FROM stage WHERE stage_code = 'ODG02'),
     (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'),
     'description',
     'Begins around the 6th year after planting.');


-- Insert provided timing data
INSERT INTO timing (stage_id, reference_id, timing_type, description, reference_timing, reference_timing_distance) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'NDG00'), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'), 'description', 'Spring', NULL, NULL),
((SELECT stage_id FROM stage WHERE stage_code = 'NDG01'), (SELECT id FROM reference_data WHERE bibtex_key = 'visserJuvenilePhaseGrowth1964'), 'description', '4-12 years from sowing to first bloom', NULL, NULL),
((SELECT stage_id FROM stage WHERE stage_code = 'NDG02'), (SELECT id FROM reference_data WHERE bibtex_key = 'zhangPotentialPolyphenolMarkers2007'), 'reference', NULL, 'Full bloom', '10 days'),
((SELECT stage_id FROM stage WHERE stage_code = 'NDG03'), (SELECT id FROM reference_data WHERE bibtex_key = 'kotodaFloweringJuvenilityApple2021'), 'reference', NULL, 'After node number >122', NULL),
((SELECT stage_id FROM stage WHERE stage_code = 'NDG04'), (SELECT id FROM reference_data WHERE bibtex_key = 'greenwoodMaturationDevelopmentalProcess1993'), 'description', 'Post peak fruit production period', NULL, NULL);

-- Insert provided observation data
INSERT INTO observation (stage_id, reference_id, description, item, value) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'NDG01'), (SELECT id FROM reference_data WHERE bibtex_key = 'zimmermanHormonalAspectsPhase1985'), 'Inability to flower', 'Flowering', 'Not present'),
((SELECT stage_id FROM stage WHERE stage_code = 'NDG01'), (SELECT id FROM reference_data WHERE bibtex_key = 'zimmermanHormonalAspectsPhase1985'), 'Adventitious roots observed', 'Adventitious roots', 'Present'),
((SELECT stage_id FROM stage WHERE stage_code = 'NDG01'), (SELECT id FROM reference_data WHERE bibtex_key = 'zhangPotentialPolyphenolMarkers2007'), 'Node number observation', 'Node number', 'Up to 77'),
((SELECT stage_id FROM stage WHERE stage_code = 'NDG02'), (SELECT id FROM reference_data WHERE bibtex_key = 'zhangPotentialPolyphenolMarkers2007'), 'Node number observation', 'Node number', '77 to 122'),
((SELECT stage_id FROM stage WHERE stage_code = 'NDG03'), (SELECT id FROM reference_data WHERE bibtex_key = 'zhangPotentialPolyphenolMarkers2007'), 'Node number observation', 'Node number', 'Above 122'),
((SELECT stage_id FROM stage WHERE stage_code = 'NDG03'), (SELECT id FROM reference_data WHERE bibtex_key = 'kotodaFloweringJuvenilityApple2021'), 'Myricitrin absence', 'Myricitrin', 'Disappeared'),
((SELECT stage_id FROM stage WHERE stage_code = 'NDG04'), (SELECT id FROM reference_data WHERE bibtex_key = 'wareingProblemsJuvenilityFlowering1959'), 'Growth rate slow', 'Growth rate', 'Slow'),
((SELECT stage_id FROM stage WHERE stage_code = 'NDG04'), (SELECT id FROM reference_data WHERE bibtex_key = 'wareingProblemsJuvenilityFlowering1959'), 'Terminal growing point increase', 'Terminal growing point', 'Increased');

-- Insert provided key measurement data
INSERT INTO key_measurement (stage_id, reference_id, measurement_name) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'NDG00'), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'), 'Environmental condition'),
((SELECT stage_id FROM stage WHERE stage_code = 'NDG00'), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'), 'Soil pH'),
((SELECT stage_id FROM stage WHERE stage_code = 'NDG00'), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'), 'Soil moisture'),
((SELECT stage_id FROM stage WHERE stage_code = 'NDG00'), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'), 'Temperature'),
((SELECT stage_id FROM stage WHERE stage_code = 'NDG01'), (SELECT id FROM reference_data WHERE bibtex_key = 'zhangPotentialPolyphenolMarkers2007'), 'Node number'),
((SELECT stage_id FROM stage WHERE stage_code = 'NDG01'), (SELECT id FROM reference_data WHERE bibtex_key = 'trederResponseYoungApple2004'), 'Trunk diameter'),
((SELECT stage_id FROM stage WHERE stage_code = 'NDG02'), (SELECT id FROM reference_data WHERE bibtex_key = 'zhangPotentialPolyphenolMarkers2007'), 'Node number'),
((SELECT stage_id FROM stage WHERE stage_code = 'NDG02'), (SELECT id FROM reference_data WHERE bibtex_key = 'zhangPotentialPolyphenolMarkers2007'), 'Biochemical markers'),
((SELECT stage_id FROM stage WHERE stage_code = 'NDG03'), (SELECT id FROM reference_data WHERE bibtex_key = 'zhangPotentialPolyphenolMarkers2007'), 'Node number'),
((SELECT stage_id FROM stage WHERE stage_code = 'NDG03'), (SELECT id FROM reference_data WHERE bibtex_key = 'kotodaFloweringJuvenilityApple2021'), 'Biochemical markers'),
((SELECT stage_id FROM stage WHERE stage_code = 'NDG04'), (SELECT id FROM reference_data WHERE bibtex_key = 'wareingProblemsJuvenilityFlowering1959'), 'Growth rate'),
((SELECT stage_id FROM stage WHERE stage_code = 'NDG04'), (SELECT id FROM reference_data WHERE bibtex_key = 'wareingProblemsJuvenilityFlowering1959'), 'Terminal growing point');






INSERT INTO stage (stage_code, stage_name, description) VALUES
('ODG00', 'Planting Tree', 'Initial phase of planting orchard trees, including rootstock preparation and grafting.'),
('ODG01', 'Young Tree', 'Early growth phase where trees establish roots and vegetative structures.'),
('ODG02', 'Mature Tree', 'Productive phase with active fruiting and full canopy development.'),
('ODG03', 'End of Productive Life', 'Decline phase marked by reduced vigor and fruit yield.'),
('OAR00', 'Dormancy', 'Temporary suspension of visible growth with changes in carbohydrate, starch, and soluble sugar content.'),
('OAR00-00', 'Para-dormancy', 'Dormancy controlled by internal conditions with carbohydrate buildup.'),
('OAR00-01', 'Endo-dormancy', 'Winter dormancy stage that requires chilling accumulation to break.'),
('OAR00-02', 'Eco-dormancy', 'Dormancy stage limited by external environmental conditions.'),

('OAR(01-04)', 'Bud Development', 'Progressive development of buds from swelling to bud break.'),
('OAR01-03', 'Leaf Bud Swelling', 'Stage where bud scales elongate and lighten, preparing for break.'),
('OAR(01-04)-BB-09', 'Bud Break', 'Appearance of green leaf tips indicating bud break.'),

('OAR(10-19)', 'Leaf Development', 'Rapid leaf unfolding and expansion phase.'),
('OAR(31-39)', 'Shoot Development', 'Shoot elongation following a sigmoid growth pattern.'),

('OAR(40-45)', 'Inflorescence Emergence', 'Floral bud development culminating in visible flowers.'),
('OAR40', 'Floral Bud Swelling', 'Stage where floral buds swell prominently.'),
('OAR42', 'Bud Burst', 'Emergence of green leaf tips and visible flowers.'),
('OAR44', 'Pink Bud Stage', 'Petal elongation and sepals opening just before flowering.'),
('OAR45', 'Hollow Ball Formation', 'Flowers form a hollow ball shape at stage culmination.'),

('OAR(50-59)', 'Flowering', 'Progressive flower bloom with overlapping phases.'),
('OAR50', 'First Flower', 'Opening of first flowers in the orchard.'),
('OAR50-00', 'Pollination', 'Transfer of pollen grains between flowers.'),
('OAR50-01', 'Fertilisation', 'Union of gametes resulting in zygote formation.'),
('OAR50-02', 'Fruit Set', 'Formation of fruit following successful fertilisation.'),
('OAR55', 'Full Bloom / Anthesis', 'Peak flowering period with maximum open blooms.'),
('OAR57', 'End of Flowering', 'Petal fall indicating flowering completion.'),

('OAR(60-62)', 'Flower Bud Formation for Next Season', 'Development of floral meristems for the following season.'),
('OAR60', 'Flower Induction', 'Initial physiological commitment to floral formation.'),
('OAR61', 'Flower Initiation', 'Early morphological changes indicating floral development.'),
('OAR62', 'Bud Differentiation', 'Complex differentiation within the floral bud structure.'),

('OAR(70-79)', 'Fruit Development', 'Fruit growth phase with size increase and physiological changes.'),
('OAR70', 'Fruit Size Increase', 'Rapid fruit expansion and growth.'),
('OAR70-00', 'Cell Division', 'Cell multiplication contributing to fruit growth.'),
('OAR70-01', 'Cell Enlargement', 'Cell expansion and volume increase.'),
('OAR71', 'First Fruit Fall', 'Initial drop of unviable or excess fruitlets.'),
('OAR72', 'Second Fruit Fall', 'Subsequent natural thinning of fruits.'),
('OAR79', 'Shoot Growth Completed', 'Cessation of shoot elongation.'),

('OAR(80-89)', 'Maturity of Fruit and Seed', 'Final ripening stage for fruit and seeds.'),
('OAR80', 'Beginning of Ripening', 'Initial stages of fruit coloration and ripening.'),
('OAR81', 'Advanced Coloring', 'Deepening of fruit color indicating ripeness.'),
('OAR82', 'Fruit Harvest', 'Harvest-ready stage of fruits.'),

('OAR(90-93)', 'Senescence', 'Progressive leaf senescence and drop.'),
('OAR90', 'Leaves Begin to Discolor', 'Initial color change in leaves.'),
('OAR91', 'Beginning of Leaf Fall', 'Start of significant leaf drop.'),
('OAR92', '50% Leaves Discolored', 'Midway point of leaf discoloration.'),
('OAR93', 'All Leaves Fallen', 'Completion of leaf fall and onset of dormancy.');



INSERT INTO general_operation (
   stage_id, reference_id, description
) VALUES 
(
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG00' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  '- For commercial orchard preparation, refer to Table ref{2.1} <br><br> - Adequately moisten planting-hole cite{ferreeApplesBotanyProduction2003} and Fertigation soon after planting cite{robinsonCropLoadManagement2008}.<br> - Use stakes or trellis to support trees to prevent branch breakage and find structures via cite{ferreeApplesBotanyProduction2003}.'
);

INSERT INTO general_operation (
   stage_id, reference_id, description
) VALUES 
(
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG01' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'For typical orchard management strategies for young trees, refer to Table ref{2.2}.'
);

INSERT INTO general_operation (
   stage_id, reference_id, description
) VALUES 
(
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG02' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'For typical orchard management strategies for mature trees, refer to Table ref{2.3}.'
);

INSERT INTO general_operation (
   stage_id, reference_id, description
) VALUES 
(
  (SELECT stage_id FROM stage WHERE stage_code = 'OAR00' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  '- For suggested opperation, refer to Table ref{OAR00}'
);





-- Landscape modification
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection,
  third_party_database, link, page_number
) VALUES 
(
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG00' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'Involves adding topsoil to flatter or uniformly shaped ground',
  'Modify Landscape', 'Levelling',
  'Apples: Botany, Production, and Uses', 'https://books.google.com.au/books/about/Apples.html?id=MmuBCwAAQBAJ&redir_esc=y', 'p.12'
),
(
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG00' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'Establish the orchard parallel to natural contour of the land',
  'Modify Landscape', 'Contouring',
  'Apples: Botany, Production, and Uses', 'https://books.google.com.au/books/about/Apples.html?id=MmuBCwAAQBAJ&redir_esc=y', 'p.12'
),
(
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG00' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'Create stepped ground only considered when other soil and water conservation methods are insufficient',
  'Modify Landscape', 'Terracing',
  'Apples: Botany, Production, and Uses', 'https://books.google.com.au/books/about/Apples.html?id=MmuBCwAAQBAJ&redir_esc=y', 'p.12'
),
(
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG00' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'Perform subsoiling parallel and perpendicular to the position of tree rows cite{parkerHighDensityApple1998}',
  'Modify Landscape', 'Subsoil',
  'Apples: Botany, Production, and Uses', 'https://books.google.com.au/books/about/Apples.html?id=MmuBCwAAQBAJ&redir_esc=y', 'p.12'
),
(
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG00' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'schwabSoilWaterConservation1982' LIMIT 1),
  'Find practical information in the article cite{schwabSoilWaterConservation1982}',
  'Modify Landscape', 'Modifying Drainage',
  'Apples: Botany, Production, and Uses', 'https://books.google.com.au/books/about/Apples.html?id=MmuBCwAAQBAJ&redir_esc=y', 'p.12'
);

-- Soil chemical management
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection,
  third_party_database, link, page_number
) VALUES 
(
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG00' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'Adjust soil pH using liming material for neutralization and material like elemental sulfur for acidification, based on soil test result. Common liming materials are listed in cite{ferreeApplesBotanyProduction2003}',
  'Apply Material to Adjust Soil Condition', 'Liming/Acidifying materials',
  'Apples: Botany, Production, and Uses', 'https://books.google.com.au/books/about/Apples.html?id=MmuBCwAAQBAJ&redir_esc=y', 'p.12'
),
(
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG00' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'Apply material such as hay, straw, woodchips and manure at an effective rate of 30-60 t/ha and mix them into root zone depth; application post-planting on the surface also feasible cite{ferreeApplesBotanyProduction2003}',
  'Apply Material to Adjust Soil Condition', 'Organic material',
  'Apples: Botany, Production, and Uses', 'https://books.google.com.au/books/about/Apples.html?id=MmuBCwAAQBAJ&redir_esc=y', 'p.12'
),
(
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG00' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = '2023IntegratedOrchard2023' LIMIT 1),
  'Apply nutrient like phosphorous and potassium based on soil test, as outlined from cite{2023IntegratedOrchard2023}',
  'Apply Material to Adjust Soil Condition', 'Fertilizer',
  'Apples: Botany, Production, and Uses', 'https://books.google.com.au/books/about/Apples.html?id=MmuBCwAAQBAJ&redir_esc=y', 'p.12'
);

-- Tillage
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection,
  third_party_database, link, page_number
) VALUES 
(
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG00' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'Typically executed to about 20 cm depth below ground. Deeper ploughing up to 35-40 cm is possible, but not recommended cite{ferreeApplesBotanyProduction2003}.',
  'Perform Tillage', 'Ploughing',
  'Apple Botany Reference', 'https://example.com/ploughing', 'p.72'
);

-- Disease management
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection,
  third_party_database, link, page_number
) VALUES 
(
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG00' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'parkerHighDensityApple1998' LIMIT 1),
  'Apply chemical biocides if needed, especially for replant sites cite{parkerHighDensityApple1998}. For some successful treatment, refer to cite{ferreeApplesBotanyProduction2003}',
  'Disease management', 'Fumigate',
  'High Density Apple Systems', 'https://example.com/fumigation', 'p.39'
);

-- Irrigation
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection,
  third_party_database, link, page_number
) VALUES 
(
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG00' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'koechImprovingIrrigationWater2018' LIMIT 1),
  'Utilize drippers, sprinklers, or pipes, depending on orchard requirements cite{koechImprovingIrrigationWater2018, petersDripIrrigationAgricultural2015}',
  'Irrigation', 'Pre-plant irrigation system setup',
  'Irrigation Water Management Guide', 'https://example.com/irrigation', 'p.102'
);




-- Thinning
INSERT INTO operation (
    stage_id, reference_id, description, section, subsection,
    third_party_database, link, page_number
) VALUES 
(
    (SELECT stage_id FROM stage WHERE stage_code = 'ODG01' LIMIT 1),
    (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
    'No crop in second year for lower density orchard; Control crop load at 4-6 fruits per square cm trunk cross-sectional area (TCSA) depending on variety cite{robinsonCropLoadManagement2008}',
    'Thinning', 'Fruit load management',
    'Washington Apple Guidelines', 'https://example.com/thinning', 'p.88'
),
(
    (SELECT stage_id FROM stage WHERE stage_code = 'ODG01' LIMIT 1),
    (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
    'Defruiting practices help delay fruit set and manage energy distribution',
    'Thinning', 'Fruit load management',
    'New Jersey Apple IPM & Fertility Bulletins', 'https://njaes.rutgers.edu/pubs/subcategory.php?cat=3&sub=19', 'p.88'
);

-- Pruning & Training (leader control)
INSERT INTO operation (
    stage_id, reference_id, description, section, subsection,
    third_party_database, link, page_number
) VALUES 
(
    (SELECT stage_id FROM stage WHERE stage_code = 'ODG01' LIMIT 1),
    (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
    'Manage leader development by removing competing shoots and new shoots below the leader when they reach 2-5 cm, but not recommended for low-vigour trees cite{ferreeApplesBotanyProduction2003}; Bending, scoring and ringing can be applied to regulate tree growth if flowering is postponed cite{ferreeApplesBotanyProduction2003};<br>
                Control shoots growth of leader shoot with an incremental increase: 12-24 inches in first year, 30-36 inches in second and third years, and 18 inches in fourth year cite{robinsonCropLoadManagement2008}.',
    'Pruning & Training', 'Leader management',
    'New England Orchard BMP', 'https://example.com/pruning-leader', 'N/A'
);

-- Pruning & Training (growth increments)
INSERT INTO operation (
    stage_id, reference_id, description, section, subsection,
    third_party_database, link, page_number
) VALUES 
(
    (SELECT stage_id FROM stage WHERE stage_code = 'ODG01' LIMIT 1),
    (SELECT id FROM reference_data WHERE bibtex_key = 'robinsonCropLoadManagement2008' LIMIT 1),
    'Manage leader development by removing competing shoots and new shoots below the leader when they reach 2-5 cm, but not recommended for low-vigour trees [2]; Bending, scoring and ringing can be applied to regulate tree growth if flowering is postpond',
    'Pruning & Training', 'Leader shoot growth',
    'New England Orchard BMP', 'https://example.com/pruning-growth', 'N/A'
),
(
    (SELECT stage_id FROM stage WHERE stage_code = 'ODG01' LIMIT 1),
    (SELECT id FROM reference_data WHERE bibtex_key = 'robinsonCropLoadManagement2008' LIMIT 1),
    'Branching techniques for training structure',
    'Pruning & Training', 'Leader management',
    'New England Orchard BMP', 'https://ag.umass.edu/fruit/publications/orchard-bmp-manual', 'N/A'
),
(
    (SELECT stage_id FROM stage WHERE stage_code = 'ODG01' LIMIT 1),
    (SELECT id FROM reference_data WHERE bibtex_key = 'robinsonCropLoadManagement2008' LIMIT 1),
    'Manage leader development by removing competing shoots and new shoots below the leader when they reach 2-5 cm, but not recommended for low-vigour trees [2]; Bending, scoring and ringing can be applied to regulate tree growth if flowering is postpond',
    'Pruning & Training', 'Leader shoot growth',
    'New England Orchard BMP', 'https://ag.umass.edu/fruit/publications/orchard-bmp-manual', 'N/A'
);

-- Nutrient management (fertilization)
INSERT INTO operation (
    stage_id, reference_id, description, section, subsection,
    third_party_database, link, page_number
) VALUES 
(
    (SELECT stage_id FROM stage WHERE stage_code = 'ODG01' LIMIT 1),
    (SELECT id FROM reference_data WHERE bibtex_key = 'robinsonCropLoadManagement2008' LIMIT 1),
    'Apply before bud break in early spring based on soil test cite{howFertilizeApple2023}; Recommendations available via guide cite{2023IntegratedOrchard2023}.',
    'Nutrient management', 'Fertilization',
    '2023 Integrated Orchard Management Guide', 'https://example.com/fertilization', 'N/A'
);

-- Plant growth regulator
INSERT INTO operation (
    stage_id, reference_id, description, section, subsection,
    third_party_database, link, page_number
) VALUES 
(
    (SELECT stage_id FROM stage WHERE stage_code = 'ODG01' LIMIT 1),
    (SELECT id FROM reference_data WHERE bibtex_key = '2023IntegratedOrchard2023' LIMIT 1),
    'According to goals, practical recommendations during different stages via cite{2023IntegratedOrchard2023}.',
    'Plant growth regulator', '',
    'Washington Apple', 'https://example.com/pgr', 'New Jersey p.88'
),
(
    (SELECT stage_id FROM stage WHERE stage_code = 'ODG01' LIMIT 1),
    (SELECT id FROM reference_data WHERE bibtex_key = '2023IntegratedOrchard2023' LIMIT 1),
    'Use of PGRs in non-bearing trees',
    'Plant growth regulator', '',
    'Washington Apple', 'https://treefruit.wsu.edu/', 'N/A'
),
(
    (SELECT stage_id FROM stage WHERE stage_code = 'ODG01' LIMIT 1),
    (SELECT id FROM reference_data WHERE bibtex_key = '2023IntegratedOrchard2023' LIMIT 1),
    'According to goals, practical recommendations during different stages via cite{2023IntegratedOrchard2023}.',
    'Plant growth regulator', '',
    'New Jersey Apple IPM & Fertility Bulletins', 'https://njaes.rutgers.edu/pubs/subcategory.php?cat=5&sub=37', 'New Jersey p.88'
);

-- Irrigation
INSERT INTO operation (
    stage_id, reference_id, description, section, subsection,
    third_party_database, link, page_number
) VALUES 
(
    (SELECT stage_id FROM stage WHERE stage_code = 'ODG01' LIMIT 1),
    (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
    'The irrigation schedule is based on thresholds or indexes determined by the method or simulation model specific to field, accounting for weather, soil and plant status cite{ferreeApplesBotanyProduction2003}
                Refer to cite{bolandGuideBestPractice2002} for maintaining soil moisture tension between 8 and 40 kPa, except dormancy period. In drought conditions, it is advisable to irrigate even in winter cite{ferreeApplesBotanyProduction2003}.',
    'Irrigation', 'Soil-water model',
    'NSW Guide', 'https://example.com/irrigation', 'p.124–125'
),
(
    (SELECT stage_id FROM stage WHERE stage_code = 'ODG01' LIMIT 1),
    (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
    'Young trees–spray schedule and watering guideline',
    'Irrigation', 'Irrigation schedule',
    'NSW Apple Crop Protection and Nutrition Portal', 'https://www.dpi.nsw.gov.au/agriculture/horticulture/pomes', 'p.124–125'
);

-- Orchard floor management
INSERT INTO operation (
    stage_id, reference_id, description, section, subsection,
    third_party_database, link, page_number
) VALUES 
(
    (SELECT stage_id FROM stage WHERE stage_code = 'ODG01' LIMIT 1),
    (SELECT id FROM reference_data WHERE bibtex_key = 'brightOrchardPlantProtection2006' LIMIT 1),
    'Use mulching or herbicides to eliminate weeds.',
    'Orchard floor management', 'Weed control',
    'Orchard Plant Protection Guide', 'https://example.com/orchard-floor', 'N/A'
),
(
    (SELECT stage_id FROM stage WHERE stage_code = 'ODG01' LIMIT 1),
    (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
    'Up to six cultivations per season may be required; Herbicide spraying requires 200-400L per ha.',
    'Orchard floor management', 'Cultivation practice',
    'Orchard Plant Protection Guide', 'https://example.com/cultivation', 'N/A'
),
(
    (SELECT stage_id FROM stage WHERE stage_code = 'ODG01' LIMIT 1),
    (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
    'Herbicides spraying require 200-400l per ha of material to be effective and the water volume varies with the herbicide type cite{ferreeApplesBotanyProduction2003}',
    'Orchard floor management', 'Cultivation practice',
    'Orchard Plant Protection Guide', 'https://example.com/cultivation', 'N/A'
),
(
    (SELECT stage_id FROM stage WHERE stage_code = 'ODG01' LIMIT 1),
    (SELECT id FROM reference_data WHERE bibtex_key = '2023IntegratedOrchardManagement' LIMIT 1),
    'Refer to herbicide usage guidelines for effectiveness by type.',
    'Orchard floor management', 'Herbicide usage',
    'Orchard Plant Protection Guide', 'https://example.com/herbicide-guide', 'N/A'
);

-- Environmental stress management
INSERT INTO operation (
    stage_id, reference_id, description, section, subsection,
    third_party_database, link, page_number
) VALUES 
(
    (SELECT stage_id FROM stage WHERE stage_code = 'ODG01' LIMIT 1),
    (SELECT id FROM reference_data WHERE bibtex_key = 'bastiasLightQualityManagement2012' LIMIT 1),
    ' Use reflective films and shading such as coloured net cite  cite{bastiasLightQualityManagement2012}; Bagging is also a common management cite{ferreeApplesBotanyProduction2003}',
    'Environmental stress management', 'light managemnet',
    'Light Quality Management Manual', 'https://example.com/light-management', 'N/A'
);

-- IPDM
INSERT INTO operation (
    stage_id, reference_id, description, section, subsection,
    third_party_database, link, page_number
) VALUES 
(
    (SELECT stage_id FROM stage WHERE stage_code = 'ODG01' LIMIT 1),
    (SELECT id FROM reference_data WHERE bibtex_key = 'hetheringtonIntegratedPestDisease2005' LIMIT 1),
    'Refer to monitoring strategy with frequency, symptom description, and appropriate actions.',
    'IPDM', 'Monitoring & intervention',
    'Integrated Pest and Disease Manual', 'https://example.com/ipdm', 'p.198'
);


-- Thinning
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection,
  third_party_database, link, page_number
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG02' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'stoverMethodAssessingRelationship2001' LIMIT 1),
  'Remove buds, flowers, or fruits manually, mechanically, or chemically, depending on the method. This operation generally occurs once per season, with supplementary hand thinning later if the effect of initial thinning on fruit size or return bloom is not sufficient cite{stoverMethodAssessingRelationship2001}; Control 4-6 fruits per square cm of trunk cross-sectional area (TCSA), varying by variety cite{robinsonCropLoadManagement2008}.',
  'Thinning', 'Crop load adjustment',
  'Apple Thinning Guidelines', 'https://example.com/thinning', 'N/A'
);

-- Pruning & Training
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection,
  third_party_database, link, page_number
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG02' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'Remove shoots or limbs to maintain canopy within space during the dormant and summer seasons annually. See different pruning plans at cite{ferreeApplesBotanyProduction2003}. In larger orchards, pruning may be scheduled every second or third year to manage costs cite{ferreeApplesBotanyProduction2003}.',
  'Pruning & Training', 'Canopy management',
  'Apple Production Reference', 'https://example.com/pruning', 'N/A'
);

-- Nutrient management
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection,
  third_party_database, link, page_number
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG02' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'dzikitiEstimatingWaterRequirements2018' LIMIT 1),
  'Apply once in the spring and once in the autumn after fruiting cite{howFertilizeApple2023}; Integrated Orchard Management Guide for Commercial Apples in the Southeast, 2023 cite{2023IntegratedOrchard2023}.',
  'Nutrient management', 'Seasonal fertilization',
  '2023 Fertilization Guide', 'https://example.com/fertilization', 'N/A'
);

-- Plant growth regulator
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection,
  third_party_database, link, page_number
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG02' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'dzikitiEstimatingWaterRequirements2018' LIMIT 1),
  'Apply plant growth regulator to adjust the growth and characteristics of tree and fruit as necessary. For practical recommendation tailored to different developmental stages, refer to cite{2023IntegratedOrchardManagement2023}.',
  'Plant growth regulator', '',
  'Orchard Growth Regulator Guide', 'https://example.com/pgr', 'N/A'
);

-- Irrigation
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection,
  third_party_database, link, page_number
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG02' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'dzikitiEstimatingWaterRequirements2018' LIMIT 1),
  'The irrigation schedule is based on thresholds or indexes determined by the method or simulation model specific to field, accounting for weather, soil and plant status cite{ferreeApplesBotanyProduction2003}
                Refer to cite{bolandGuideBestPractice2002} for maintaining soil moisture tension between 8 and 40 kPa, except dormancy period. In drought conditions, it is advisable to irrigate even in winter cite{ferreeApplesBotanyProduction2003}. Mature trees may require more frequent irrigation cite{dzikitiEstimatingWaterRequirements2018}.',
  'Irrigation', 'Mature orchard watering',
  'Irrigation Management Reference', 'https://example.com/irrigation', 'N/A'
);
-- Orchard floor management
INSERT INTO operation (
    stage_id, reference_id, description, section, subsection,
    third_party_database, link, page_number
) VALUES 
(
    (SELECT stage_id FROM stage WHERE stage_code = 'ODG02' LIMIT 1),
    (SELECT id FROM reference_data WHERE bibtex_key = 'brightOrchardPlantProtection2006' LIMIT 1),
    'Use mulching or herbicides to eliminate weeds.',
    'Orchard floor management', 'Weed control',
    'Orchard Plant Protection Guide', 'https://example.com/orchard-floor', 'N/A'
),
(
    (SELECT stage_id FROM stage WHERE stage_code = 'ODG02' LIMIT 1),
    (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
    'Up to six cultivations per season may be required; Herbicide spraying requires 200-400L per ha.',
    'Orchard floor management', 'Cultivation practice',
    'Orchard Plant Protection Guide', 'https://example.com/cultivation', 'N/A'
),
(
    (SELECT stage_id FROM stage WHERE stage_code = 'ODG02' LIMIT 1),
    (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
    'Herbicides spraying require 200-400l per ha of material to be effective and the water volume varies with the herbicide type cite{ferreeApplesBotanyProduction2003}',
    'Orchard floor management', 'Cultivation practice',
    'Orchard Plant Protection Guide', 'https://example.com/cultivation', 'N/A'
),
(
    (SELECT stage_id FROM stage WHERE stage_code = 'ODG02' LIMIT 1),
    (SELECT id FROM reference_data WHERE bibtex_key = '2023IntegratedOrchardManagement' LIMIT 1),
    'Refer to herbicide usage guidelines for effectiveness by type.',
    'Orchard floor management', 'Herbicide usage',
    'Orchard Plant Protection Guide', 'https://example.com/herbicide-guide', 'N/A'
);

-- Environmental stress management
INSERT INTO operation (
    stage_id, reference_id, description, section, subsection,
    third_party_database, link, page_number
) VALUES 
(
    (SELECT stage_id FROM stage WHERE stage_code = 'ODG02' LIMIT 1),
    (SELECT id FROM reference_data WHERE bibtex_key = 'bastiasLightQualityManagement2012' LIMIT 1),
    ' Use reflective films and shading such as coloured net cite  cite{bastiasLightQualityManagement2012}; Bagging is also a common management cite{ferreeApplesBotanyProduction2003}',
    'Environmental stress management', 'light managemnet',
    'Light Quality Management Manual', 'https://example.com/light-management', 'N/A'
);

-- IPDM
INSERT INTO operation (
    stage_id, reference_id, description, section, subsection,
    third_party_database, link, page_number
) VALUES 
(
    (SELECT stage_id FROM stage WHERE stage_code = 'ODG02' LIMIT 1),
    (SELECT id FROM reference_data WHERE bibtex_key = 'hetheringtonIntegratedPestDisease2005' LIMIT 1),
    'Refer to monitoring strategy with frequency, symptom description, and appropriate actions.',
    'IPDM', 'Monitoring & intervention',
    'Integrated Pest and Disease Manual', 'https://example.com/ipdm', 'p.198'
);



-- IPDM: Mealybugs
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection, third_party_database, link, page_number
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'OAR00' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'Monitor and control Mealybugs during Bud Swell to Beginning of Dormancy.',
  'IPDM', 'Mealybugs',
  '2024-25 IPDM NSW', 'https://example.com/mealybugs', 'p.62'
);

-- IPDM: Oriental fruit moth
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection, third_party_database, link, page_number
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'OAR00' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'Monitor Oriental fruit moth throughout season from Bud Swell through Dormancy.',
  'IPDM', 'Oriental fruit moth',
  '2024-25 IPDM NSW', 'https://example.com/oriental-fruit-moth', 'p.64'
);

-- IPDM: San José scale
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection, third_party_database, link, page_number
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'OAR00' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'Apply dormant oil spray for San José scale from Bud Swell to Dormancy.',
  'IPDM', 'San José scale',
  '2024-25 IPDM NSW', 'https://example.com/san-jose-scale', 'p.79'
);

-- IPDM: Powdery mildew (across stages)
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection, third_party_database, link, page_number
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'OAR00' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'Manage powdery mildew through bud removal and fungicide at Bud Swell and blossom stage.',
  'Disease management', 'Powdery mildew',
  '2020-21 IPDM Australia', 'https://example.com/powdery-mildew', 'p.266'
);

-- IPDM: Bryobia mite
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection, third_party_database, link, page_number
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'OAR00' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'Apply miticides during Midseason to End of Harvest to control Bryobia mite.',
  'IPDM', 'Bryobia mite',
  '2024-25 IPDM NSW', 'https://example.com/bryobia-mite', 'p.35'
);

-- Orchard Floor Management: Herbicide use
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection, third_party_database, link, page_number
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'OAR00' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'Apply selective herbicides pre- and post-emergence for winter annuals and perennials.',
  'Orchard floor management', 'Herbicide usage',
  '2020-21 IPDM Australia', 'https://example.com/herbicides', 'p.111–115'
);

-- Disease Management: Apple scab (multiple stages)
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection, third_party_database, link, page_number
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'OAR00' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'Apply fungicides preventively at blossom and fruiting to prevent Apple scab.',
  'Disease management', 'Apple scab',
  '2020-21 IPDM Australia', 'https://example.com/apple-scab', 'p.158'
);

-- Disease Management: Silver leaf
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection, third_party_database, link, page_number
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'OAR00' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'Avoid pruning during wet conditions and manage for silver leaf across seasons.',
  'Disease management', 'Silver leaf',
  '2024-25 IPDM NSW', 'https://example.com/silver-leaf', 'p.122'
);

-- Disease Management: Phytophthora root & collar rot
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection, third_party_database, link, page_number
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'OAR00' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'Manage root and collar rot through drainage improvements and chemical drenches across periods.',
  'Disease management', 'Phytophthora',
  '2024-25 IPDM NSW', 'https://example.com/phytophthora', 'p.114'
);


-- OAR01

-- Mealybugs
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection,
  third_party_database, link, page_number
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'OAR01' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'Monitor and control Mealybugs during Bud Swell to Midseason.',
  'IPDM', 'Mealybugs',
  '2024–25 IPDM NSW', 'https://example.com/ipdm-mealybugs', 'p.62'
);

-- Oriental Fruit Moth
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection,
  third_party_database, link, page_number
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'OAR01' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'Apply monitoring for Oriental fruit moth from Bud Swell through Midseason.',
  'IPDM', 'Oriental fruit moth',
  '2024–25 IPDM NSW', 'https://example.com/ipdm-oriental', 'p.64'
);

-- San José scale
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection,
  third_party_database, link, page_number
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'OAR01' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'Apply dormant oil or scale-targeting insecticides during Bud Swell to Beginning of Dormancy.',
  'IPDM', 'San José scale',
  '2024–25 IPDM NSW', 'https://example.com/ipdm-scale', 'p.79'
);

-- Powdery Mildew
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection,
  third_party_database, link, page_number
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'OAR01' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'Preventive fungicide application for Powdery mildew during bud swell to flowering.',
  'Disease management', 'Powdery mildew',
  '2024–25 IPDM NSW', 'https://example.com/ipdm-powdery', 'p.116'
);

-- Australian plague locust
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection,
  third_party_database, link, page_number
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'OAR01' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'Scout and treat for Australian plague locust during Bud Swell to End of Midseason.',
  'IPDM', 'Australian plague locust',
  '2024–25 IPDM NSW', 'https://example.com/ipdm-locust', 'p.32'
);

-- Budworms (Heliothis)
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection,
  third_party_database, link, page_number
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'OAR01' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'Monitor and manage Budworms (Heliothis) in early vegetative stages.',
  'IPDM', 'Budworms',
  '2024–25 IPDM NSW', 'https://example.com/ipdm-budworms', 'p.37'
);

-- Plague Thrips
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection,
  third_party_database, link, page_number
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'OAR01' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'Apply targeted control measures for Plague thrips during Bud Swell to End of Midseason.',
  'IPDM', 'Plague thrips',
  '2024–25 IPDM NSW', 'https://example.com/ipdm-thrips', 'p.69'
);




























-- Insert timing data for orchard stages
INSERT INTO timing (stage_id, reference_id, timing_type, description)
VALUES
    ((SELECT stage_id FROM stage WHERE stage_code = 'ODG00'),
     (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'),
     'description',
     'Two options:
1) Rootstock planted in dormant season and the scion grafted onto rootstock in field in late summer in following year.
2) Bench grafting to rootstock indoors in late winter, and then grafted trees are dug up in spring.');

INSERT INTO timing (stage_id, reference_id, timing_type, description)
VALUES
    ((SELECT stage_id FROM stage WHERE stage_code = 'ODG01'),
     (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'),
     'description',
     'Approximately 5 to 7 years from planting.');

INSERT INTO timing (stage_id, reference_id, timing_type, description)
VALUES
    ((SELECT stage_id FROM stage WHERE stage_code = 'ODG02'),
     (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'),
     'description',
     'Begins around the 6th year after planting.');

INSERT INTO timing (stage_id, reference_id, timing_type, description)
VALUES
    ((SELECT stage_id FROM stage WHERE stage_code = 'ODG03'),
     (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'),
     'description',
     'Varies by variety and management strategies.');


-- Insert observation data
INSERT INTO observation (stage_id, reference_id, description, item, value) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'ODG00'), (SELECT id FROM reference_data WHERE bibtex_key = 'zimmermanHormonalAspectsPhase1985'), 'Inability to flower', 'Flowering', 'Not present'),
((SELECT stage_id FROM stage WHERE stage_code = 'ODG00'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'   ), 'Standard grafting point height.', 'Grafting point height', 'Standard: 15 cm; M.9: 25-35 cm'),
((SELECT stage_id FROM stage WHERE stage_code = 'ODG00'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'   ), 'Preferred row orientation.', 'Row orientation', 'North-South'),
((SELECT stage_id FROM stage WHERE stage_code = 'ODG00'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'   ), 'Planting distance recommendation.', 'Planting distance', 'M.9: 100 cm between rows, 35 cm within rows'),
((SELECT stage_id FROM stage WHERE stage_code = 'ODG01'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'hampsonCanopyGrowthYield2002'   ), 'Increase in leaf canopy area.', 'Leaf canopy area', 'Increase observed'),
((SELECT stage_id FROM stage WHERE stage_code = 'ODG01'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'lordanLongtermEffectsTree2018'   ), 'Increase in light interception.', 'Light interception', 'Increase observed'),
((SELECT stage_id FROM stage WHERE stage_code = 'ODG01'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'   ), 'Start of flowering period varies.', 'Flowering', 'Depends on rootstock type'),
((SELECT stage_id FROM stage WHERE stage_code = 'ODG02'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'lordanLongtermEffectsTree2018'   ), 'Light interception rates by training system.', 'Light interception', '70% for V-shaped; 60% for conic-shaped'),
((SELECT stage_id FROM stage WHERE stage_code = 'ODG02'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'middletonProductivityPerformanceApple2002'   ), 'Range of leaf area index.', 'Leaf area index', '1.5 to 2.8'),
((SELECT stage_id FROM stage WHERE stage_code = 'ODG02'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'lordanLongtermEffectsTree2018'   ), 'Tree height by training system.', 'Tree height', '2.5-2.75m (V-shaped); 3.0-5.5m (conic-shaped)');

-- Insert key measurement data
INSERT INTO key_measurement (stage_id, reference_id, measurement_name) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'ODG00'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'   ), 'Tree density'),
((SELECT stage_id FROM stage WHERE stage_code = 'ODG00'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'   ), 'Environmental conditions'),
((SELECT stage_id FROM stage WHERE stage_code = 'ODG00'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'   ), 'Soil moisture'),
((SELECT stage_id FROM stage WHERE stage_code = 'ODG01'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'   ), 'Trunk diameter'),
((SELECT stage_id FROM stage WHERE stage_code = 'ODG01'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'   ), 'Bud count'),
((SELECT stage_id FROM stage WHERE stage_code = 'ODG02'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'   ), 'Fruit yield'),
((SELECT stage_id FROM stage WHERE stage_code = 'ODG02'   ), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'   ), 'Crop load');





INSERT INTO timing (stage_id, reference_id, timing_type, description, reference_timing, reference_timing_distance) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00'), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'), 'description', 'Trees enter dormancy in late summer or early autumn in most regions and resume growth in the following spring when temperature rises.', NULL, NULL),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00'), (SELECT id FROM reference_data WHERE bibtex_key = 'hauaggeAgeGrowingTemperatures1991'), 'description', 'Dormancy influenced by temperature and age factors.', NULL, NULL),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00'), (SELECT id FROM reference_data WHERE bibtex_key = 'mimidaFourTFL1CENlike2009'), 'description', 'Regulation of dormancy via TFL1/CEN-like genes.', NULL, NULL),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00'), (SELECT id FROM reference_data WHERE bibtex_key = 'moserMADSboxGeneMdDAM12020'), 'description', 'Dormancy transitions marked by MADS-box gene expression.', NULL, NULL);

INSERT INTO observation (stage_id, reference_id, description, item, value) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00'), (SELECT id FROM reference_data WHERE bibtex_key = 'langDormancyNewUniversal1987'), 'Temporary suspension of visible growth of plant structures containing a meristem.', 'Dormancy state', 'Suspension of growth'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00'), (SELECT id FROM reference_data WHERE bibtex_key = 'fadonConceptualFrameworkWinter2020'), 'Buds may enter dormancy while trees still carry foliage.', 'Bud dormancy with foliage', 'Possible occurrence'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00'), (SELECT id FROM reference_data WHERE bibtex_key = 'gonzaleznoguerAppleMalusDomestica2023'), 'Carbohydrate concentration peaks at endo-dormancy and decreases before bud break.', 'Carbohydrate concentration', 'Peak and subsequent decrease'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00'), (SELECT id FROM reference_data WHERE bibtex_key = 'gonzaleznoguerAppleMalusDomestica2023'), 'Starch content remains low and declines, with a peak at endodormancy release.', 'Starch content', 'Low, declining with peak at endo-dormancy release'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00'), (SELECT id FROM reference_data WHERE bibtex_key = 'sapkotaChangesReactiveOxygen2021'), 'Soluble sugar levels increase during dormancy.', 'Soluble sugars', 'Increase observed'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00'), NULL, 'Sorbitol concentrations increase with colder temperatures in apples.', 'Sorbitol concentrations', 'Increase with colder temperatures');

INSERT INTO key_measurement (stage_id, reference_id, measurement_name) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00'), NULL, 'Image'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00'), NULL, 'Bud fresh weight'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00'), NULL, 'Microscopy / bud dissection'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00'), NULL, 'Carbohydrate concentration'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00'), NULL, 'Tree characteristics (trunk diameter, tree height)'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00'), NULL, 'Temperature');


INSERT INTO timing (stage_id, reference_id, timing_type, description, reference_timing, reference_timing_distance) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(01-04)'), (SELECT id FROM reference_data WHERE bibtex_key = 'kurokuraRegulationSeasonalFlowering2013'), 'description', 'Occurs in spring, beginning just before inflorescence emergence. This phase continues for 24 days and concludes shortly after mid-flowering.', NULL, NULL),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(01-04)'), (SELECT id FROM reference_data WHERE bibtex_key = 'martinezPhenologicalGrowthStages2019'), 'description', 'Bud development phase spans BBCH stages 01, 03, 07, and 09.', NULL, NULL);

INSERT INTO observation (stage_id, reference_id, description, item, value) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(01-04)'), (SELECT id FROM reference_data WHERE bibtex_key = 'meierGrowthStagesMonoand1997'), 'Bud development begins with visibly swollen buds with elongated bud scales and light-colored patches (BBCH 01). Bud scales lighten and become hairy (BBCH 03). Bud break is marked by the appearance of green leaf tips (BBCH 07) and continues until these tips extend about 5 mm above the bud scales (BBCH 09).', 'Bud development progression', 'BBCH stages 01, 03, 07, 09'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(01-04)'), (SELECT id FROM reference_data WHERE bibtex_key = 'labuschagneSelectionIncreasedBudbreak2003'), 'Average bud break per shoot length.', 'Bud break number', '10 to 35 buds per 100 cm shoot length'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(01-04)'), NULL, 'Starch content decreases in both fine and coarse roots starting from bud break.', 'Starch content', 'Decrease after bud break'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(01-04)'), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'), 'Organic carbon reserves decrease from bud break to about 30 days after full bloom (DAFB); the greatest deficit occurs around 20 DAFB when fruit diameter is approximately 12 mm.', 'Carbon reserve trend', 'Decrease observed');

INSERT INTO key_measurement (stage_id, reference_id, measurement_name) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(01-04)'), NULL, 'Image'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(01-04)'), NULL, 'Bud count per TCSA or per tree'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(01-04)'), NULL, 'Bud strength (size, fresh mass, and dry mass)'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(01-04)'), NULL, 'Microscopy / bud dissection');

INSERT INTO timing (stage_id, reference_id, timing_type, description, reference_timing, reference_timing_distance) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(01-04)'), (SELECT id FROM reference_data WHERE bibtex_key = 'kurokuraRegulationSeasonalFlowering2013'), 'description', 'Occurs in spring, beginning just before inflorescence emergence. This phase continues for 24 days and concludes shortly after mid-flowering.', NULL, NULL),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(01-04)'), (SELECT id FROM reference_data WHERE bibtex_key = 'martinezPhenologicalGrowthStages2019'), 'description', 'Bud development phase spans BBCH stages 01, 03, 07, and 09.', NULL, NULL),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(10-19)'), (SELECT id FROM reference_data WHERE bibtex_key = 'loescherCarbohydrateReservesTranslocation1990'), 'description', 'Begins before bud break and continues for approximately 45 days to two months until all leaves are completely unfolded and expanded.', NULL, NULL),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(10-19)'), (SELECT id FROM reference_data WHERE bibtex_key = 'wunscheRelationshipLeafArea2000'), 'description', 'Leaf development and canopy growth are influenced by environmental factors, apple genetics, training systems, and canopy height.', NULL, NULL),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(10-19)'), (SELECT id FROM reference_data WHERE bibtex_key = 'martinezPhenologicalGrowthStages2019'), 'description', 'Includes BBCH stages 10, 11, 15, and 19.', NULL, NULL);

INSERT INTO observation (stage_id, reference_id, description, item, value) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(10-19)'), (SELECT id FROM reference_data WHERE bibtex_key = 'barrittCultivarCanopyPosition1990'), 'Leaf tip growth and unfolding significantly increase leaf area, influenced by cultivar and canopy position.', 'Leaf area increase', 'Significant growth observed'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(10-19)'), (SELECT id FROM reference_data WHERE bibtex_key = 'wunscheBasesProductivityApple1996'), 'Canopy growth begins with slight increase until bloom, followed by rapid expansion peaking around two months after bud break.', 'Canopy growth pattern', 'Rapid expansion observed'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(10-19)'), (SELECT id FROM reference_data WHERE bibtex_key = 'laksoLeafAreaDevelopment1984'), 'Factors influencing leaf area development include weather, genetics, training systems, and canopy height.', 'Influence factors', 'Various environmental and genetic influences');

INSERT INTO key_measurement (stage_id, reference_id, measurement_name) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(10-19)'), NULL, 'Image'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(10-19)'), NULL, 'Leaf area'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(10-19)'), NULL, 'Leaf area index (LAI)'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(10-19)'), NULL, 'Leaf dry weight'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(10-19)'), NULL, 'Leaf number'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(10-19)'), NULL, 'Light interception'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(10-19)'), NULL, 'Leaf nutrient content'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(10-19)'), NULL, 'Shoot length');


INSERT INTO timing (stage_id, reference_id, timing_type, description, reference_timing, reference_timing_distance) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(31-39)'), (SELECT id FROM reference_data WHERE bibtex_key = 'baiComparisonMachinelearningCasa2021'), 'description', 'Generally in mid-summer but can range widely from 40 to 90 days after full bloom, influenced by environmental conditions, tree genetics, vigor, and fruit behavior.', NULL, NULL),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(31-39)'), (SELECT id FROM reference_data WHERE bibtex_key = 'forsheyRelationshipVegetativeGrowth1989'), 'description', 'Shoot growth begins with visibility of developing shoot axes, followed by a sigmoid increase in shoot length.', NULL, NULL);

INSERT INTO observation (stage_id, reference_id, description, item, value) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(31-39)'), (SELECT id FROM reference_data WHERE bibtex_key = 'meierGrowthStagesMonoand1997'), 'Shoot growth follows a sigmoid pattern.', 'Shoot length', 'Sigmoid increase observed'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(31-39)'), (SELECT id FROM reference_data WHERE bibtex_key = 'riveroFloweringPhenologyInterrelations2017'), 'Shoot length increases progressively.', 'Shoot length progression', 'Increasing length');

INSERT INTO key_measurement (stage_id, reference_id, measurement_name) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(31-39)'), NULL, 'Image'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(31-39)'), NULL, 'Leaf area'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(31-39)'), NULL, 'Light interception'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(31-39)'), NULL, 'Leaf nutrient content'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(31-39)'), NULL, 'Shoot length'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(31-39)'), NULL, 'Trunk diameter');

INSERT INTO timing (stage_id, reference_id, timing_type, description, reference_timing, reference_timing_distance) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(40-45)'), (SELECT id FROM reference_data WHERE bibtex_key = 'martinezPhenologicalGrowthStages2019'), 'description', 'Begins prior to vegetative bud development, lasting for 28 days and concluding before vegetative development ends.', NULL, NULL),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(40-45)'), (SELECT id FROM reference_data WHERE bibtex_key = 'chituTimingPhenologicalStages2020'), 'description', 'From 1969 to 2018, the timing of floral bud swelling and bud burst has advanced by 13.8 and 14.8 days, respectively.', NULL, NULL);

INSERT INTO observation (stage_id, reference_id, description, item, value) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(40-45)'), (SELECT id FROM reference_data WHERE bibtex_key = 'meierGrowthStagesMonoand1997'), 'Floral bud development stages include swollen buds with elongated scales (BBCH 51), scales that lighten and grow hairy (BBCH 52), bud burst with visible flowers (BBCH 53), pink stage with elongating petals and opening sepals (BBCH 57), and hollow ball formation at culmination (BBCH 59).', 'Floral bud development progression', 'Sequential stages from BBCH 51 to BBCH 59');

INSERT INTO key_measurement (stage_id, reference_id, measurement_name) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(40-45)'), NULL, 'Image'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(40-45)'), NULL, 'Buds per unit of trunk cross-sectional area or per tree'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(40-45)'), NULL, 'Record timing for different phases'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(40-45)'), NULL, 'IPDM assessment of pest and diseases'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(40-45)'), (SELECT id FROM reference_data WHERE bibtex_key = 'kamoutsisAppleMalusDomestica2023'), 'Temperature'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(40-45)'), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'), 'Light Intensity');


INSERT INTO timing (stage_id, reference_id, timing_type, description, reference_timing, reference_timing_distance) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(50-59)'), (SELECT id FROM reference_data WHERE bibtex_key = 'martinezPhenologicalGrowthStages2019'), 'description', 'Occurs in spring after flower emergence with a staggered bloom lasting several weeks, typically mid-April.', NULL, NULL),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(50-59)'), (SELECT id FROM reference_data WHERE bibtex_key = 'kurokuraRegulationSeasonalFlowering2013'), 'description', 'Flowering dates vary by more than 30 days among cultivars, with staggered blooming.', NULL, NULL);

INSERT INTO observation (stage_id, reference_id, description, item, value) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(50-59)'), (SELECT id FROM reference_data WHERE bibtex_key = 'malladiMolecularPhysiologyFruit2020'), 'Flower growth temporarily ceases before blooming and resumes after successful pollination and fertilization.', 'Flower growth cycle', 'Interruption before blooming and resumption post-fertilization'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(50-59)'), (SELECT id FROM reference_data WHERE bibtex_key = 'musacchiAppleFruitQuality2018'), 'Number of cells in flowers.', 'Cell count in flowers', 'Approximately 3–6 million cells'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(50-59)'), (SELECT id FROM reference_data WHERE bibtex_key = 'doganGrowthFruitBearing2024a'), 'Number of flowers in a cluster.', 'Flowers per cluster', '5.5 to 5.9'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(50-59)'), (SELECT id FROM reference_data WHERE bibtex_key = 'meierGrowthStagesMonoand1997'), 'Bloom percentage at different stages.', 'Bloom percentage', 'BBCH 61: ~10%; BBCH 65: >50% petal fall');

INSERT INTO key_measurement (stage_id, reference_id, measurement_name) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(50-59)'), NULL, 'Flower count (buds per unit of trunk cross-sectional area or per tree)'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(50-59)'), NULL, 'Flower cluster'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(50-59)'), NULL, 'Flower formation rate'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(50-59)'), NULL, 'Bloom percentage (%)'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(50-59)'), NULL, 'Timing for different phases'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(50-59)'), NULL, 'Light interception'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(50-59)'), NULL, 'Temperature');

INSERT INTO timing (stage_id, reference_id, timing_type, description, reference_timing, reference_timing_distance) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OARSC-91'), (SELECT id FROM reference_data WHERE bibtex_key = 'baiComparisonMachinelearningCasa2021'), 'description', 'Generally occurs in mid-summer, with shoot growth completion varying by shoot type; fruit-bearing shoots stop 3-5 weeks after bud burst, skeletal shoots may continue for months.', NULL, NULL),
((SELECT stage_id FROM stage WHERE stage_code = 'OARSC-91'), (SELECT id FROM reference_data WHERE bibtex_key = 'benkoMorphologicalDifferentiationFlower1967'), 'description', 'Shoot completion marked by terminal bud formation while foliage remains green.', NULL, NULL);

INSERT INTO observation (stage_id, reference_id, description, item, value) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OARSC-91'), (SELECT id FROM reference_data WHERE bibtex_key = 'meierGrowthStagesMonoand1997'), 'Shoot growth completion indicated by terminal bud formation.', 'Shoot termination marker', 'Terminal bud formed with green foliage');

INSERT INTO key_measurement (stage_id, reference_id, measurement_name) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OARSC-91'), NULL, 'Shoot length');

INSERT INTO timing (stage_id, reference_id, timing_type, description, reference_timing, reference_timing_distance) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(60-62)'), (SELECT id FROM reference_data WHERE bibtex_key = 'koflerHighCropLoad2019'), 'description', 'Flower bud formation for the subsequent season occurs simultaneously with fruit growth during the current season.', NULL, NULL),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(60-62)'), (SELECT id FROM reference_data WHERE bibtex_key = 'jonkersBiennialBearingApple1979'), 'description', 'Flower bud formation influenced by fruit behavior, branch type, apple genetics, shoot growth, pruning, and growth regulators.', NULL, NULL);

INSERT INTO observation (stage_id, reference_id, description, item, value) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(60-62)'), (SELECT id FROM reference_data WHERE bibtex_key = 'meierGrowthStagesMonoand1997'), 'Vegetative meristems transition into floral meristems.', 'Meristem transition', 'Sequential commitment to floral formation'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(60-62)'), (SELECT id FROM reference_data WHERE bibtex_key = 'verheijMorphologicalPhysiologicalAspects1996'), 'Low gibberellic acid levels observed during floral commitment.', 'Gibberellic acid level', 'Low');

INSERT INTO key_measurement (stage_id, reference_id, measurement_name) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(60-62)'), NULL, 'Microscopy / bud dissection'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(60-62)'), NULL, 'Histological measurements'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(60-62)'), NULL, 'Hormone level'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(60-62)'), NULL, 'Metabolic analysis of bud samples'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(60-62)'), (SELECT id FROM reference_data WHERE bibtex_key = 'riveroFloweringPhenologyInterrelations2017'), 'Temperature, precipitation, irradiance');

INSERT INTO timing (stage_id, reference_id, timing_type, description, reference_timing, reference_timing_distance) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(70-79)'), (SELECT id FROM reference_data WHERE bibtex_key = 'martinezPhenologicalGrowthStages2019'), 'description', 'Fruit development occurs from summer to autumn and lasts over 160 days.', NULL, NULL);

INSERT INTO observation (stage_id, reference_id, description, item, value) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(70-79)'), (SELECT id FROM reference_data WHERE bibtex_key = 'meierGrowthStagesMonoand1997'), 'Fruit growth follows an expolinear pattern.', 'Fruit size', 'Continuous increase'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(70-79)'), (SELECT id FROM reference_data WHERE bibtex_key = 'arseneaultReviewApplePreharvest2016'), 'Timing of fruit drops.', 'First fruit drop', '3-4 weeks after full bloom'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(70-79)'), (SELECT id FROM reference_data WHERE bibtex_key = 'arseneaultReviewApplePreharvest2016'), 'Timing of fruit drops.', 'Second fruit drop', '4-6 weeks after full bloom');

INSERT INTO key_measurement (stage_id, reference_id, measurement_name) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(70-79)'), NULL, 'Image'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(70-79)'), NULL, 'Fruit firmness'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(70-79)'), NULL, 'Fruit size'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(70-79)'), NULL, 'Fruit weight'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(70-79)'), NULL, 'Starch content');


INSERT INTO timing (stage_id, reference_id, timing_type, description, reference_timing, reference_timing_distance) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(80-89)'), (SELECT id FROM reference_data WHERE bibtex_key = 'martinezPhenologicalGrowthStages2019'), 'description', 'Maturity of fruit and seed lasts around 40 days from initial color change to full development.', NULL, NULL);

INSERT INTO observation (stage_id, reference_id, description, item, value) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(80-89)'), (SELECT id FROM reference_data WHERE bibtex_key = 'meierGrowthStagesMonoand1997'), 'Fruit color progression from initial appearance to fully developed color.', 'Fruit color', 'Transitions to full development');

INSERT INTO key_measurement (stage_id, reference_id, measurement_name) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(80-89)'), NULL, 'Image'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(80-89)'), NULL, 'Firmness'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(80-89)'), NULL, 'Color'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(80-89)'), NULL, 'Starch content');


INSERT INTO timing (stage_id, reference_id, timing_type, description, reference_timing, reference_timing_distance) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(90-93)'), (SELECT id FROM reference_data WHERE bibtex_key = 'martinezPhenologicalGrowthStages2019'), 'description', 'Leaf senescence occurs in autumn and lasts around 118 days including the winter rest period.', NULL, NULL);

INSERT INTO observation (stage_id, reference_id, description, item, value) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(90-93)'), (SELECT id FROM reference_data WHERE bibtex_key = 'esperancaInductionSenescenceFoliar2019'), 'Chlorophyll degradation and leaf drop mark this stage.', 'Leaf condition', 'Chlorophyll reduction and falling leaves');

INSERT INTO key_measurement (stage_id, reference_id, measurement_name) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(90-93)'), NULL, 'Image'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(90-93)'), NULL, 'Photosynthesis rate'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(90-93)'), NULL, 'Chlorophyll content'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR(90-93)'), NULL, 'Leaf nutrient content');


INSERT INTO timing (stage_id, reference_id, timing_type, description, reference_timing, reference_timing_distance) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00-00'), (SELECT id FROM reference_data WHERE bibtex_key = 'moserMADSboxGeneMdDAM12020'), 'description', 'Para-dormancy begins in late summer and is controlled by internal tree conditions.', NULL, NULL);

INSERT INTO observation (stage_id, reference_id, description, item, value) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00-00'), (SELECT id FROM reference_data WHERE bibtex_key = 'fadonConceptualFrameworkWinter2020'), 'Carbohydrate storage behavior during para-dormancy.', 'Carbohydrate concentration', 'Increase observed');

INSERT INTO key_measurement (stage_id, reference_id, measurement_name) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00-00'), NULL, 'Carbohydrate concentration'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00-00'), NULL, 'Temperature'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00-00'), NULL, 'Apical dominance observation');

INSERT INTO timing (stage_id, reference_id, timing_type, description, reference_timing, reference_timing_distance) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00-01'), (SELECT id FROM reference_data WHERE bibtex_key = 'parkesChillingRequirementsApple2020'), 'description', 'Endo-dormancy occurs during autumn and winter, requiring chilling accumulation for bud break.', NULL, NULL);

INSERT INTO observation (stage_id, reference_id, description, item, value) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00-01'), (SELECT id FROM reference_data WHERE bibtex_key = 'fadonConceptualFrameworkWinter2020'), 'Changes in sugar and starch levels during endo-dormancy.', 'Sugar and starch balance', 'Sugar increases, starch decreases');

INSERT INTO key_measurement (stage_id, reference_id, measurement_name) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00-01'), NULL, 'Carbohydrate concentration'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00-01'), NULL, 'Sugar levels'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00-01'), NULL, 'Starch levels'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00-01'), NULL, 'Temperature monitoring');




INSERT INTO timing (stage_id, reference_id, timing_type, description, reference_timing, reference_timing_distance) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00-01'), (SELECT id FROM reference_data WHERE bibtex_key = 'parkesChillingRequirementsApple2020'), 'description', 'Endo-dormancy occurs during autumn and winter, requiring chilling accumulation for bud break.', NULL, NULL),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00-02'), (SELECT id FROM reference_data WHERE bibtex_key = 'moserMADSboxGeneMdDAM12020'), 'description', 'Eco-dormancy concludes by the end of winter or early spring as heat requirements are met.', NULL, NULL);

INSERT INTO observation (stage_id, reference_id, description, item, value) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00-01'), (SELECT id FROM reference_data WHERE bibtex_key = 'fadonConceptualFrameworkWinter2020'), 'Changes in sugar and starch levels during endo-dormancy.', 'Sugar and starch balance', 'Sugar increases, starch decreases'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00-02'), (SELECT id FROM reference_data WHERE bibtex_key = 'fadonConceptualFrameworkWinter2020'), 'End of dormancy marked by carbohydrate adjustment according to environmental conditions.', 'Carbohydrate levels', 'Adjusted for environmental conditions');

INSERT INTO key_measurement (stage_id, reference_id, measurement_name) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00-01'), NULL, 'Carbohydrate concentration'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00-01'), NULL, 'Sugar levels'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00-01'), NULL, 'Starch levels'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00-01'), NULL, 'Temperature monitoring'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00-02'), NULL, 'Carbohydrate concentration'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00-02'), NULL, 'Sugar levels'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00-02'), NULL, 'Starch levels'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00-02'), NULL, 'Temperature monitoring');

INSERT INTO timing (stage_id, reference_id, timing_type, description, reference_timing, reference_timing_distance) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OARFI-X'), (SELECT id FROM reference_data WHERE bibtex_key = 'hankeNoFlowerNo2007'), 'description', 'Flower induction occurs around mid-June in the Northern Hemisphere.', NULL, NULL),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR61'), (SELECT id FROM reference_data WHERE bibtex_key = 'wilkieRegulationFloralInitiation2008a'), 'description', 'Flower initiation begins in summer, leading to morphological changes.', NULL, NULL);

INSERT INTO observation (stage_id, reference_id, description, item, value) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OARFI-X'), (SELECT id FROM reference_data WHERE bibtex_key = 'milyaevProfilingPhytohormonesApple2022'), 'No visible morphological changes during flower induction.', 'Flower induction visibility', 'None'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR61'), (SELECT id FROM reference_data WHERE bibtex_key = 'hirstRootstockEffectsFlowering1995'), 'Shoot apex broadening and doming in sequential development.', 'Apex morphological change', 'Sequential broadening and doming');

INSERT INTO key_measurement (stage_id, reference_id, measurement_name) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OARFI-X'), NULL, 'Hormonal analysis'),
((SELECT stage_id FROM stage WHERE stage_code = 'OARFI-X'), NULL, 'Gene expression profiling'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR61'), NULL, 'Microscopy / bud dissection'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR61'), NULL, 'Histological measurements'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR61'), NULL, 'Temperature monitoring');


INSERT INTO timing (stage_id, reference_id, timing_type, description, reference_timing, reference_timing_distance) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OARFI-X'), (SELECT id FROM reference_data WHERE bibtex_key = 'hankeNoFlowerNo2007'), 'description', 'Flower induction occurs around mid-June in the Northern Hemisphere.', NULL, NULL),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR61'), (SELECT id FROM reference_data WHERE bibtex_key = 'wilkieRegulationFloralInitiation2008a'), 'description', 'Flower initiation begins in summer, leading to morphological changes.', NULL, NULL),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR62'), (SELECT id FROM reference_data WHERE bibtex_key = 'mcartneySeasonalVariationOnset2001'), 'description', 'Bud differentiation starts in summer and completes before dormancy, varying between 15 to 22 weeks after full bloom.', NULL, NULL),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR70-00'), (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'), 'description', 'Cell division begins after flowering and continues for about 4 to 6 weeks.', NULL, NULL);

INSERT INTO observation (stage_id, reference_id, description, item, value) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OARFI-X'), (SELECT id FROM reference_data WHERE bibtex_key = 'milyaevProfilingPhytohormonesApple2022'), 'No visible morphological changes during flower induction.', 'Flower induction visibility', 'None'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR61'), (SELECT id FROM reference_data WHERE bibtex_key = 'hirstRootstockEffectsFlowering1995'), 'Shoot apex broadening and doming in sequential development.', 'Apex morphological change', 'Sequential broadening and doming'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR62'), (SELECT id FROM reference_data WHERE bibtex_key = 'fosterMorphologicalQuantitativeCharacterization2003'), 'Sequential development of floral organs within buds.', 'Floral organ formation sequence', 'Sequential order: sepals, petals, stamens, carpels'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR70-00'), (SELECT id FROM reference_data WHERE bibtex_key = 'malladiMolecularPhysiologyFruit2020'), 'Cell number increases during early fruit development.', 'Cell number change', 'Increase observed');

INSERT INTO key_measurement (stage_id, reference_id, measurement_name) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OARFI-X'), NULL, 'Hormonal analysis'),
((SELECT stage_id FROM stage WHERE stage_code = 'OARFI-X'), NULL, 'Gene expression profiling'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR61'), NULL, 'Microscopy / bud dissection'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR61'), NULL, 'Histological measurements'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR61'), NULL, 'Temperature monitoring'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR62'), NULL, 'Microscopy / bud dissection'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR62'), NULL, 'Histological measurements'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR62'), NULL, 'Temperature monitoring'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR70-00'), NULL, 'Cell number index (CNI)'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR70-00'), NULL, 'Cell and cell space size index (CSSI)'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR70-00'), NULL, 'Temperature monitoring'),
((SELECT stage_id FROM stage WHERE stage_code = 'OAR70-00'), NULL, 'Light measurement');


-- OAR70-00'


-- -- Observation
-- INSERT INTO observation (stage_id, reference_id, description, item, value)
-- VALUES (
--     (SELECT stage_id FROM stage WHERE stage_code = 'OAR70-00'),
--     (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'),
--     'Begins shortly after flowering and typically ceases about 4–6 weeks after bloom. Varies significantly among cultivars.',
--     'Cell division',
--     'Cell numbers are established within 35–50 days after full blossom. Fruits experience exponential growth in size.'
-- );

-- -- Key Measurements
-- INSERT INTO key_measurement (stage_id, reference_id, description, item, value)
-- VALUES 
--     ((SELECT stage_id FROM stage WHERE stage_code = 'OAR70-00'),
--      (SELECT id FROM reference_data WHERE bibtex_key = 'malladiMolecularPhysiologyFruit2020'),
--      'Increase in cell number.',
--      'Cell number',
--      'Increase'),

--     ((SELECT stage_id FROM stage WHERE stage_code = 'OAR70-00'),
--      (SELECT id FROM reference_data WHERE bibtex_key = 'haradaInvolvementCellProliferation2005'),
--      'CSSI increases linearly ~0.04 → 0.15 for Fuji, Mutsu, and Sekaiichi.',
--      'Cell and cell space size index (CSSI, um)',
--      '0.04 → 0.15'),

--     ((SELECT stage_id FROM stage WHERE stage_code = 'OAR70-00'),
--      (SELECT id FROM reference_data WHERE bibtex_key = 'haradaInvolvementCellProliferation2005'),
--      'CNI increases from 200 to 500 for Fuji and Mutsu, and up to 600 for Sekaiichi.',
--      'Change in cell number index (CNI)',
--      '200 → 600'),

--     ((SELECT stage_id FROM stage WHERE stage_code = 'OAR70-00'),
--      (SELECT id FROM reference_data WHERE bibtex_key = 'stanleyUnderstandingRoleTemperature2000a'),
--      'Environmental influence on cell division.',
--      'Temperature',
--      'Variable'),

--     ((SELECT stage_id FROM stage WHERE stage_code = 'OAR70-00'),
--      NULL,
--      'Environmental influence on cell division.',
--      'Light',
--      'Required');

-- format wrong
-- -- 🧪 Cell Division (OAR70-00)
-- INSERT INTO observation (stage_id, reference_id, description, item, value)
-- VALUES (
--   (SELECT stage_id FROM stage WHERE stage_code = 'OAR70-00'),
--   (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'),
--   'Begins shortly after flowering and typically ceases about 4–6 weeks after bloom. Varies significantly among cultivars.',
--   'Cell division',
--   'Cell numbers are established within 35–50 days after full blossom. Fruits experience exponential growth in size.'
-- );

-- INSERT INTO key_measurement (stage_id, reference_id, measurement_name, unit, value_range, calculation_method)
-- VALUES
--   ((SELECT stage_id FROM stage WHERE stage_code = 'OAR70-00'),
--    (SELECT id FROM reference_data WHERE bibtex_key = 'malladiMolecularPhysiologyFruit2020'),
--    'Cell number', NULL, 'Increase', 'Observed via cell count analysis'),

--   ((SELECT stage_id FROM stage WHERE stage_code = 'OAR70-00'),
--    (SELECT id FROM reference_data WHERE bibtex_key = 'haradaInvolvementCellProliferation2005'),
--    'Cell and cell space size index (CSSI)', 'µm', '0.04 → 0.15', 'Perimeter² ÷ cell count'),

--   ((SELECT stage_id FROM stage WHERE stage_code = 'OAR70-00'),
--    (SELECT id FROM reference_data WHERE bibtex_key = 'haradaInvolvementCellProliferation2005'),
--    'Change in cell number index (CNI)', NULL, '200 → 600', 'Fruit diameter ÷ CSSI'),

--   ((SELECT stage_id FROM stage WHERE stage_code = 'OAR70-00'),
--    (SELECT id FROM reference_data WHERE bibtex_key = 'stanleyUnderstandingRoleTemperature2000a'),
--    'Temperature', '°C', 'Variable', 'Field observation'),

--   ((SELECT stage_id FROM stage WHERE stage_code = 'OAR70-00'),
--    NULL,
--    'Light', NULL, 'Required', 'Photoperiod effect');


-- -- 📈 Cell Enlargement (OAR70-01)
-- INSERT INTO observation (stage_id, reference_id, description, item, value)
-- VALUES (
--   (SELECT stage_id FROM stage WHERE stage_code = 'OAR70-01'),
--   (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'),
--   'Primary phase of enlargement starts as cell division slows, peaking between 40–60 days after anthesis.',
--   'Cell enlargement',
--   'Linear fruit size growth through cell expansion. Cell volume and intercellular spaces increase, packing density decreases.'
-- );

-- INSERT INTO key_measurement (stage_id, reference_id, measurement_name, unit, value_range, calculation_method)
-- VALUES
--   ((SELECT stage_id FROM stage WHERE stage_code = 'OAR70-01'),
--    (SELECT id FROM reference_data WHERE bibtex_key = 'janssenGlobalGeneExpression2008'),
--    'Cell and cell space size index (CSSI)', 'µm', '0.15 → 0.2', 'Perimeter² ÷ cell count'),

--   ((SELECT stage_id FROM stage WHERE stage_code = 'OAR70-01'),
--    (SELECT id FROM reference_data WHERE bibtex_key = 'haradaInvolvementCellProliferation2005'),
--    'Change in cell number index (CNI)', NULL, 'Stable', 'Fruit diameter ÷ CSSI'),

--   ((SELECT stage_id FROM stage WHERE stage_code = 'OAR70-01'),
--    (SELECT id FROM reference_data WHERE bibtex_key = 'janssenGlobalGeneExpression2008'),
--    'Starch (mg/fruit)', 'mg', 'Rises to ~100 DAP, then falls', 'Biochemical assay');


-- -- 🌸 Pollination (OAR50-00)
-- INSERT INTO observation (stage_id, reference_id, description, item, value)
-- VALUES (
--   (SELECT stage_id FROM stage WHERE stage_code = 'OAR50-00'),
--   (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'),
--   'Occurs during overlapping flowering duration between fruit-producing trees and pollinating trees. Optimal pollination from ~30% to >50% bloom.',
--   'Pollination',
--   'Pollen from pollinator trees transferred by insects to stigmas.'
-- );

-- INSERT INTO key_measurement (stage_id, reference_id, measurement_name, unit, value_range, calculation_method)
-- VALUES
--   ((SELECT stage_id FROM stage WHERE stage_code = 'OAR50-00'),
--    (SELECT id FROM reference_data WHERE bibtex_key = 'ramirezApplePollinationReview2013'),
--    'Temperature', '°C', 'Influential', 'Field condition dependency'),

--   ((SELECT stage_id FROM stage WHERE stage_code = 'OAR50-00'),
--    (SELECT id FROM reference_data WHERE bibtex_key = 'ramirezApplePollinationReview2013'),
--    'Irradiation', NULL, 'Important', 'Pollinator activity dependency');


-- -- 🧬 Fertilization (OAR50-01)
-- INSERT INTO observation (stage_id, reference_id, description, item, value)
-- VALUES (
--   (SELECT stage_id FROM stage WHERE stage_code = 'OAR50-01'),
--   (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'),
--   'Time from pollination to fertilization: 48 hours to 13 days. EPP varies 2–9 days depending on cultivar, condition, and temperature.',
--   'Fertilization',
--   'Pollen tubes reach ovules; fertilization forms zygote and triploid nucleus.'
-- );

-- INSERT INTO key_measurement (stage_id, reference_id, measurement_name, unit, value_range, calculation_method)
-- VALUES
--   ((SELECT stage_id FROM stage WHERE stage_code = 'OAR50-01'),
--    (SELECT id FROM reference_data WHERE bibtex_key = 'ramirezApplePollinationReview2013'),
--    'Temperature', '°C', 'Variable', 'Affects fertilization timing'),

--   ((SELECT stage_id FROM stage WHERE stage_code = 'OAR50-01'),
--    (SELECT id FROM reference_data WHERE bibtex_key = 'ramirezApplePollinationReview2013'),
--    'Irradiation', NULL, 'Relevant', 'Linked to stigma receptivity and pollen tube growth');


-- -- 🍈 Fruit Set (OAR50-02)
-- INSERT INTO observation (stage_id, reference_id, description, item, value)
-- VALUES (
--   (SELECT stage_id FROM stage WHERE stage_code = 'OAR50-02'),
--   (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003'),
--   'Occurs shortly after fertilization; for Golden Delicious, ~7 days after pollination. Noted when >95% petals have fallen.',
--   'Fruit Set',
--   'Fertilized ovary and tissues develop into fruit.'
-- );

-- INSERT INTO key_measurement (stage_id, reference_id, measurement_name, unit, value_range, calculation_method)
-- VALUES (
--   (SELECT stage_id FROM stage WHERE stage_code = 'OAR50-02'),
--   NULL,
--   'Microscopy / bud dissection', NULL, 'Used', 'Confirm anatomical changes');


-- -- 🌱 Flower Induction (OAR60)
-- INSERT INTO observation (stage_id, reference_id, description, item, value)
-- VALUES (
--   (SELECT stage_id FROM stage WHERE stage_code = 'OAR60'),
--   (SELECT id FROM reference_data WHERE bibtex_key = 'hankeNoFlowerNo2007'),
--   'Occurs mid-June (Northern Hemisphere); no morphological change visible.',
--   'Flower Induction',
--   'No morphological indicators observed.'
-- );

-- INSERT INTO key_measurement (stage_id, reference_id, measurement_name, unit, value_range, calculation_method)
-- VALUES (
--   (SELECT stage_id FROM stage WHERE stage_code = 'OAR60'),
--   (SELECT id FROM reference_data WHERE bibtex_key = 'milyaevProfilingPhytohormonesApple2022'),
--   'Morphological change', NULL, 'None', 'Visual inspection');


-- -- 🌼 Flower Initiation (OAR61)
-- INSERT INTO observation (stage_id, reference_id, description, item, value)
-- VALUES (
--   (SELECT stage_id FROM stage WHERE stage_code = 'OAR61'),
--   (SELECT id FROM reference_data WHERE bibtex_key = 'wilkieRegulationFloralInitiation2008a'),
--   'Initiates in summer; shoot apex broadens and domes sequentially.',
--   'Flower Initiation',
--   'Shoot apex undergoes early visible transformation.'
-- );

-- INSERT INTO key_measurement (stage_id, reference_id, measurement_name, unit, value_range, calculation_method)
-- VALUES
--   ((SELECT stage_id FROM stage WHERE stage_code = 'OAR61'),
--    (SELECT id FROM reference_data WHERE bibtex_key = 'hirstRootstockEffectsFlowering1995'),
--    'Microscopy / bud dissection', NULL, 'Used', 'Detect meristem doming'),

--   ((SELECT stage_id FROM stage WHERE stage_code = 'OAR61'),
--    NULL,
--    'Histological measurements', NULL, 'Applied', 'Tissue section analysis'),

--   ((SELECT stage_id FROM stage WHERE stage_code = 'OAR61'),
--    NULL,
--    'Appendages number', NULL, 'Counted', 'Morphological quantification'),

--   ((SELECT stage_id FROM stage WHERE stage_code = 'OAR61'),
--    NULL,
--    'Plastochron', NULL, 'Measured', 'Interval between leaf primordia initiation');


-- -- 🌸 Bud Differentiation (OAR62)
-- INSERT INTO observation (stage_id, reference_id, description, item, value)
-- VALUES (
--   (SELECT stage_id FROM stage WHERE stage_code = 'OAR62'),
--   (SELECT id FROM reference_data WHERE bibtex_key = 'hackettJuvenilityMaturationRejuvenation2011'),
--   'Begins in summer, continues into autumn; largely complete before dormancy. 15–22 weeks post bloom.',
--   'Bud Differentiation',
--   'Differentiation varies by tree position. Spur buds develop earlier than extension shoots.'
-- );

-- INSERT INTO key_measurement (stage_id, reference_id, measurement_name, unit, value_range, calculation_method)
-- VALUES
--   ((SELECT stage_id FROM stage WHERE stage_code = 'OAR62'),
--    (SELECT id FROM reference_data WHERE bibtex_key = 'malladiMolecularPhysiologyFruit2020'),
--    'Microscopy / bud dissection', NULL, 'Used', 'Apical meristem analysis'),

--   ((SELECT stage_id FROM stage WHERE stage_code = 'OAR62'),
--    (SELECT id FROM reference_data WHERE bibtex_key = 'fosterMorphologicalQuantitativeCharacterization2003'),
--    'Histological measurements', NULL, 'Used', 'Tissue differentiation study'),

--   ((SELECT stage_id FROM stage WHERE stage_code = 'OAR62'),
--    (SELECT id FROM reference_data WHERE bibtex_key = 'trompLowerbudFormationPome2000'),
--    'Temperature', '°C', 'Influences rate', 'Correlates with completion timing');
