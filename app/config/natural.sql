-- protocol.sql layers these on top of `stage` and `key_measurement`, so they have to
-- go first or the DROPs below fail on every restart after the first.
DROP TABLE IF EXISTS protocol_stage;
DROP TABLE IF EXISTS protocol_reference;

DROP TABLE IF EXISTS guidereference;
DROP TABLE IF EXISTS operation;
DROP TABLE IF EXISTS general_operation;
DROP TABLE IF EXISTS key_measurement;
DROP TABLE IF EXISTS observation;
DROP TABLE IF EXISTS timing;
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


CREATE TABLE operation (
    operation_id SERIAL PRIMARY KEY,
    stage_id INT REFERENCES stage(stage_id),
    reference_id INT REFERENCES reference_data(id),
    description TEXT,
    section TEXT CHECK (section IN (
        'Thinning',
        'Pruning & Training',
        'Pollination',
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
        'Post-harvest handling',
        'Perform Tillage',
        'Fertilization',
        'Harvest management'
    )),
    subsection TEXT
);

CREATE TABLE guidereference (
    guidereference_id SERIAL PRIMARY KEY,
    operation_id INT REFERENCES operation(operation_id) ON DELETE CASCADE,
    third_party_database TEXT NOT NULL,
    link TEXT NOT NULL,
    page_number TEXT
);;





INSERT INTO stage (stage_code, stage_name, description) VALUES
('NDG00', 'Seed Germination', 'Emergence of the seedling from seed, ending with established cotyledons and first leaves.'),
('NDG01', 'Juvenile Period', 'Vegetative phase before the tree is able to flower, lasting 4 to 12 years depending on cultivar.'),
('NDG02', 'Transition Period', 'Juvenile-to-adult phase change in which reproductive competence is acquired.'),
('NDG03', 'Reproductive Phase', 'Adult phase with regular flowering and fruiting.'),
('NDG04', 'Aging', 'Progressive decline in vegetative and reproductive performance.'),

('ODG00', 'Planting Tree', 'Initial phase of planting orchard trees, including rootstock preparation and grafting.'),
('ODG01', 'Young Tree', 'Early growth phase where trees establish roots and vegetative structures.'),
('ODG02', 'Mature Tree', 'Productive phase with active fruiting and full canopy development.'),
('ODG03', 'End of Productive Life', 'Decline phase marked by reduced vigor and fruit yield.'),
('OAR00', 'Dormancy', 'Temporary suspension of visible growth with changes in carbohydrate, starch, and soluble sugar content.'),
('OAR00-00', 'Para-dormancy', 'Dormancy controlled by internal conditions with carbohydrate buildup.'),
('OAR00-01', 'Endo-dormancy', 'Winter dormancy stage that requires chilling accumulation to break.'),
('OAR00-02', 'Eco-dormancy', 'Dormancy stage limited by external environmental conditions.'),

('OAR(01-04)', 'Bud Development', 'Progressive development of buds from swelling to bud break.'),
('OAR01', 'Leaf Bud Swelling', 'Stage where bud scales elongate and lighten, preparing for break.'),
('OAR01-03', 'Leaf Bud Swelling', 'Stage where bud scales elongate and lighten, preparing for break.'),
('OAR(01-04)-BB-09', 'Bud Break', 'Appearance of green leaf tips indicating bud break.'),

('OAR(10-19)', 'Leaf Development', 'Rapid leaf unfolding and expansion phase.'),
('OAR10', 'Leaf Development', 'Rapid leaf unfolding and expansion phase.'),
('OAR11', 'Leaf Development', 'Rapid leaf unfolding and expansion phase.'),
('OAR12', 'Leaf Development', 'Rapid leaf unfolding and expansion phase.'),
('OAR(31-39)', 'Shoot Development', 'Shoot elongation following a sigmoid growth pattern.'),

('OAR(40-45)', 'Inflorescence Emergence', 'Floral bud development culminating in visible flowers.'),
('OAR40', 'Floral Bud Swelling', 'Stage where floral buds swell prominently.'),
('OAR42', 'Bud Burst', 'Emergence of green leaf tips and visible flowers.'),
('OAR43', 'Pink Bud Stage', 'Petal elongation and sepals opening just before flowering.'),
('OAR44', 'Pink Bud Stage', 'Petal elongation and sepals opening just before flowering.'),
('OAR45', 'Hollow Ball Formation', 'Flowers form a hollow ball shape at stage culmination.'),

('OAR(50-59)', 'Flowering', 'Progressive flower bloom with overlapping phases.'),
('OAR50', 'First Flower', 'Opening of first flowers in the orchard.'),
('OAR50-00', 'Pollination', 'Transfer of pollen grains between flowers.'),
('OAR50-01', 'Fertilization', 'Union of gametes resulting in zygote formation.'),
('OAR50-02', 'Fruit Set', 'Formation of fruit following successful fertilisation.'),
('OAR55', 'Full Bloom / Anthesis', 'Peak flowering period with maximum open blooms.'),
('OAR57', 'End of Flowering', 'Petal fall indicating flowering completion.'),
('OAR59', 'End of Flowering', 'Petal fall indicating flowering completion.'),


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
('OAR73', 'Shoot Growth Completed', 'Cessation of shoot elongation.'),

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
  '- For commercial orchard preparation, refer to operation Table ref{ODG00} <br><br> - Adequately moisten planting-hole cite{ferreeApplesBotanyProduction2003} and Fertigation soon after planting cite{robinsonCropLoadManagement2008}.<br> - Use stakes or trellis to support trees to prevent branch breakage and find structures via cite{ferreeApplesBotanyProduction2003}.'
);

INSERT INTO general_operation (
   stage_id, reference_id, description
) VALUES 
(
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG01' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'For typical orchard management strategies for young trees, refer to operation Table ref{ODG01}.'
);

INSERT INTO general_operation (
   stage_id, reference_id, description
) VALUES 
(
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG02' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'For typical orchard management strategies for mature trees, refer to operation Table ref{ODG02}.'
);

INSERT INTO general_operation (
   stage_id, reference_id, description
) VALUES 
(
  (SELECT stage_id FROM stage WHERE stage_code = 'OAR00' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  '- For suggested opperation, refer to Table ref{OAR00}'
);


INSERT INTO general_operation (
   stage_id, reference_id, description
) VALUES 
(
  (SELECT stage_id FROM stage WHERE stage_code = 'OAR00' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  '- For suggested opperation, refer to Table ref{OAR00}'
);


 INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG00' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'Involves adding topsoil to flatter or uniformly shaped ground',
  'Modify Landscape', 'Levelling'
);
INSERT INTO guidereference (operation_id, third_party_database, link, page_number)
SELECT operation_id, 'Apples: Botany, Production, and Uses',
  'https://books.google.com.au/books/about/Apples.html?id=MmuBCwAAQBAJ&redir_esc=y', 'p. 249'
FROM operation
WHERE description = 'Involves adding topsoil to flatter or uniformly shaped ground';

-- 2. Contouring
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG00' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'Establish the orchard parallel to natural contour of the land',
  'Modify Landscape', 'Contouring'
);
INSERT INTO guidereference (operation_id, third_party_database, link, page_number)
SELECT operation_id, 'Apples: Botany, Production, and Uses',
  'https://books.google.com.au/books/about/Apples.html?id=MmuBCwAAQBAJ&redir_esc=y', 'p. 249'
FROM operation
WHERE description = 'Establish the orchard parallel to natural contour of the land';

-- 3. Terracing
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG00' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'Create stepped ground only considered when other soil and water conservation methods are insufficient',
  'Modify Landscape', 'Terracing'
);
INSERT INTO guidereference (operation_id, third_party_database, link, page_number)
SELECT operation_id, 'Apples: Botany, Production, and Uses',
  'https://books.google.com.au/books/about/Apples.html?id=MmuBCwAAQBAJ&redir_esc=y', 'p. 249'
FROM operation
WHERE description = 'Create stepped ground only considered when other soil and water conservation methods are insufficient';

-- 4. Subsoil
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG00' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'Perform subsoiling parallel and perpendicular to the position of tree rows cite{parkerHighDensityApple1998}',
  'Modify Landscape', 'Subsoil'
);
INSERT INTO guidereference (operation_id, third_party_database, link, page_number)
SELECT operation_id, 'Apples: Botany, Production, and Uses',
  'https://books.google.com.au/books/about/Apples.html?id=MmuBCwAAQBAJ&redir_esc=y', 'pp. 248-249'
FROM operation
WHERE description LIKE 'Perform subsoiling%';

-- 5. Modifying Drainage
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG00' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'Find practical information in the article cite{schwabSoilWaterConservation1982}',
  'Modify Landscape', 'Modifying Drainage'
);
INSERT INTO guidereference (operation_id, third_party_database, link, page_number)
SELECT operation_id, 'Soil & Water Conservation Engineering',
  'https://elibrary.asabe.org/textbook.asp?confid=swce2012', 'p. 303'
FROM operation
WHERE description LIKE 'Find practical information in the article%';

-- 6. Liming / Acidifying
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG00' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'Adjust soil pH using liming material for neutralization and material like elemental sulfur for acidification, based on soil test result.',
  'Apply Material to Adjust Soil Condition', 'Liming/Acidifying materials'
);
INSERT INTO guidereference (operation_id, third_party_database, link, page_number)
SELECT operation_id, 'Apples: Botany, Production, and Uses',
  'https://books.google.com.au/books/about/Apples.html?id=MmuBCwAAQBAJ&redir_esc=y', 'p. 252'
FROM operation
WHERE description LIKE 'Adjust soil pH using liming material%';

-- 7. Organic Material
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG00' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'Apply hay, straw, woodchips and manure at 30–60 t/ha and mix into the root zone.',
  'Apply Material to Adjust Soil Condition', 'Organic material'
);
INSERT INTO guidereference (operation_id, third_party_database, link, page_number)
SELECT operation_id, 'Apples: Botany, Production, and Uses',
  'https://books.google.com.au/books/about/Apples.html?id=MmuBCwAAQBAJ&redir_esc=y', 'p. 252'
FROM operation
WHERE description LIKE 'Apply hay, straw, woodchips%';

-- 8. Fertilizer
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG00' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = '2023IntegratedOrchard2023' LIMIT 1),
  'Apply nutrient like phosphorous and potassium based on soil test',
  'Apply Material to Adjust Soil Condition', 'Fertilizer'
);
INSERT INTO guidereference (operation_id, third_party_database, link, page_number)
SELECT operation_id, 'Southeast USA Apple Orchard Integrated Guide',
  'https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast', 'p. 54'
FROM operation
WHERE description LIKE 'Apply nutrient like phosphorous%';

-- 9. Ploughing
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG00' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'Typically executed to about 20 cm depth below ground. Deeper ploughing up to 35–40 cm is possible, but not recommended.',
  'Perform Tillage', 'Ploughing'
);
INSERT INTO guidereference (operation_id, third_party_database, link, page_number)
SELECT operation_id, 'Apples: Botany, Production, and Uses',
  'https://books.google.com.au/books/about/Apples.html?id=MmuBCwAAQBAJ&redir_esc=y', 'p. 248'
FROM operation
WHERE description LIKE 'Typically executed to about 20 cm%';

-- 10. Fumigate
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG00' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'parkerHighDensityApple1998' LIMIT 1),
  'Apply chemical biocides if needed, especially for replant sites cite{parkerHighDensityApple1998}',
  'Disease management', 'Fumigate'
);
INSERT INTO guidereference (operation_id, third_party_database, link, page_number)
SELECT operation_id, 'Apples: Botany, Production, and Uses',
  'https://books.google.com.au/books/about/Apples.html?id=MmuBCwAAQBAJ&redir_esc=y', 'pp. 253-254'
FROM operation
WHERE description LIKE 'Apply chemical biocides%';

-- 11. Irrigation System Setup
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG00' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'koechImprovingIrrigationWater2018' LIMIT 1),
  'Utilize drippers, sprinklers, or pipes depending on orchard requirements.',
  'Irrigation', 'Pre-plant irrigation system setup'
);
INSERT INTO guidereference (operation_id, third_party_database, link, page_number)
SELECT operation_id, 'Irrigation Water Management Guide',
  'https://apal.org.au/wp-content/uploads/2019/09/fo-ow-handout-09-sept-irrigation-guidelines.pdf', 'p. 9'
FROM operation
WHERE description LIKE 'Utilize drippers, sprinklers, or pipes%';




-- Thinning: Fruit load management
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG01' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'No crop in second year for lower density orchard; Control crop load at 4-6 fruits per square cm trunk cross-sectional area (TCSA) depending on variety cite{robinsonCropLoadManagement2008}',
  'Thinning', 'Fruit load management'
);
INSERT INTO guidereference (operation_id, third_party_database, link, page_number)
VALUES (
  (SELECT operation_id FROM operation WHERE description LIKE 'No crop in second year%' LIMIT 1),
  'Washington Apple Orchard Systems Hub', 'https://treefruit.wsu.edu/orchard-management/', NULL
);

-- Thinning: Defruiting
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG01' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'Defruiting practices help delay fruit set and manage energy distribution',
  'Thinning', 'Fruit load management'
);
INSERT INTO guidereference (operation_id, third_party_database, link, page_number)
VALUES (
  (SELECT operation_id FROM operation WHERE description LIKE 'Defruiting practices help%' LIMIT 1),
  'New Jersey Apple IPM & Fertility Bulletins', 'https://njaes.rutgers.edu/pubs/subcategory.php?cat=3&sub=19', 'p. 88'
);

-- Pollination: Defruiting
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG01' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'Select appropirate pollinizer trees and ensure sufficient pollen availability; Use of honeybees is recommended for pollination; Avoid using insecticides during flowering to protect pollinators; Use of pheromone traps to monitor pest populations and reduce pesticide use.',
  'Pruning & Training', 'Pollination'
);
INSERT INTO guidereference (operation_id, third_party_database, link, page_number)
VALUES (
  (SELECT operation_id FROM operation WHERE description LIKE 'Select appropirate pollinizer trees%' LIMIT 1),
  'NSW Apple Crop Protection and Nutrition Portal', 'https://www.dpi.nsw.gov.au/agriculture/horticulture/pomes/apples/crabapple-pollinators', NULL
);
INSERT INTO guidereference (operation_id, third_party_database, link, page_number)
VALUES (
  (SELECT operation_id FROM operation WHERE description LIKE 'Select appropirate pollinizer trees%' LIMIT 1),
  'Washington Apple Orchard Systems Hub', 'https://treefruit.wsu.edu/orchard-management/pollination/', NULL
);




-- Pruning & Training: Leader management
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG01' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'Manage leader development by removing competing shoots and new shoots below the leader when they reach 2-5 cm, but not recommended for low-vigour trees cite{ferreeApplesBotanyProduction2003}; Bending, scoring and ringing can be applied to regulate tree growth if flowering is postponed cite{ferreeApplesBotanyProduction2003}; Control shoots growth of leader shoot with an incremental increase: 12-24 inches in first year, 30-36 inches in second and third years, and 18 inches in fourth year cite{robinsonCropLoadManagement2008}.',
  'Pruning & Training', 'Leader management'
);
INSERT INTO guidereference (operation_id, third_party_database, link, page_number)
VALUES (
  (SELECT operation_id FROM operation WHERE description LIKE 'Manage leader development by removing competing shoots and new shoots below the leader%' LIMIT 1),
  'New England Orchard BMP', 'https://www.umass.edu/agriculture-food-environment/fruit/publications/orchard-bmp-manual', NULL
);


-- Nutrient management
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG01' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'robinsonCropLoadManagement2008' LIMIT 1),
  'Apply before bud break in early spring based on soil test cite{howFertilizeApple2023}; Recommendations available via guide cite{2023IntegratedOrchard2023}.',
  'Nutrient management', 'Fertilization'
);
INSERT INTO guidereference (operation_id, third_party_database, link, page_number)
VALUES (
  (SELECT operation_id FROM operation WHERE description LIKE 'Apply before bud break in early spring%' LIMIT 1),
  'Southeast USA Apple Orchard Integrated Guide', 'https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast', NULL
);

-- Plant growth regulator: general
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG01' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = '2023IntegratedOrchard2023' LIMIT 1),
  'According to goals, practical recommendations during different stages via cite{2023IntegratedOrchard2023}.',
  'Plant growth regulator', ''
);
INSERT INTO guidereference (operation_id, third_party_database, link, page_number)
VALUES (
  (SELECT operation_id FROM operation WHERE description LIKE 'According to goals, practical recommendations%' LIMIT 1),
  'Washington Apple Crop Protection Guide', 'https://cpg.treefruit.wsu.edu/bioregulator-sprays/other-apple-programs/', NULL
);

-- Plant growth regulator: non-bearing trees
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG01' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = '2023IntegratedOrchard2023' LIMIT 1),
  'Use of PGRs in non-bearing trees',
  'Plant growth regulator', ''
);
INSERT INTO guidereference (operation_id, third_party_database, link, page_number)
VALUES (
  (SELECT operation_id FROM operation WHERE description = 'Use of PGRs in non-bearing trees' LIMIT 1),
  'Washington Apple Crop Protection Guide', 'https://cpg.treefruit.wsu.edu/bioregulator-sprays/other-apple-programs/', NULL
);


-- ODG01 - Young Tree

-- Insert irrigation operation for young orchards
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG01' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'The schedule is based on thresholds or indexes determined by the method or simulation model specific to field, accounting for weather, soil, and plant status. Maintaining soil moisture. Young trees spray schedule and watering guideline.',
  'Irrigation',
  'Young orchard watering'
);

-- Add guide reference for the operation
INSERT INTO guidereference (
  operation_id, third_party_database, link, page_number
) VALUES (
  (SELECT operation_id FROM operation WHERE description = 'The schedule is based on thresholds or indexes determined by the method or simulation model specific to field, accounting for weather, soil, and plant status. Maintaining soil moisture. Young trees spray schedule and watering guideline.' LIMIT 1),
  'Washington Apple Orchard Systems Hub',
  'https://treefruit.wsu.edu/orchard-management/irrigation-management/',
  NULL
);

-- Insert orchard floor management operation
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG01' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'Use mulching or herbicides to eliminate weeds; Up to six cultivation per season may be required to suppress weeds; Herbicide spraying requires 200–400 L/ha of material; water volume varies with herbicide type; Refer to guidelines for practical herbicide application strategies.',
  'Orchard floor management',
  'Weed control'
);

-- Add guide reference for the orchard floor management operation
INSERT INTO guidereference (
  operation_id, third_party_database, link, page_number
) VALUES (
  (SELECT operation_id FROM operation WHERE description = 'Use mulching or herbicides to eliminate weeds; Up to six cultivation per season may be required to suppress weeds; Herbicide spraying requires 200–400 L/ha of material; water volume varies with herbicide type; Refer to guidelines for practical herbicide application strategies.' LIMIT 1),
  'New Jersey Commercial Tree Fruit Production Guide – Weed and Floor Management',
  'https://njaes.rutgers.edu/pubs/subcategory.php?cat=5&sub=37',
  'pp. 49, 77, 94'
);

-- Insert environmental stress management operation
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG01' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'Use reflective films and shading such as coloured net; Bagging is also a common management strategy to protect fruit from sunburn and environmental damage.',
  'Environmental stress management',
  'Light & heat protection'
);

-- Add guide reference for environmental stress management
INSERT INTO guidereference (
  operation_id, third_party_database, link, page_number
) VALUES (
  (SELECT operation_id FROM operation WHERE description = 'Use reflective films and shading such as coloured net; Bagging is also a common management strategy to protect fruit from sunburn and environmental damage.' LIMIT 1),
  'New England Orchard BMP Manual',
  'https://www.umass.edu/agriculture-food-environment/fruit/publications/orchard-bmp-manual',
  'p. 80'
);

-- Insert operation: Environmental stress management - extreme events
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG01' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'Guides for mitigating orchard environmental stress: hail, bushfires, drought, and wildlife. Includes bird protection, critical temperature charts, and sunburn prevention practices.',
  'Environmental stress management',
  'Extreme weather and animal protection'
);

-- Add multiple relevant third-party resource links
INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
(
  (SELECT operation_id FROM operation WHERE description LIKE 'Guides for mitigating orchard environmental stress:%' LIMIT 1),
  'Environmental Stress Guide – Apple',
  'https://www.horticulture.com.au/globalassets/hort-innovation/resource-assets/hail-damage-and-your-apple-orchard.pdf',
  NULL
),
(
  (SELECT operation_id FROM operation WHERE description LIKE 'Guides for mitigating orchard environmental stress: hail, bushfires, drought, and wildlife. Includes bird protection, critical temperature charts, and sunburn prevention practices.' LIMIT 1),
  'Bushfire Response for Orchards',
  'https://www.horticulture.com.au/globalassets/hort-innovation/resource-assets/bushfires-in-orchards-preparedness-response-recovery.pdf',
  NULL
),
(
  (SELECT operation_id FROM operation WHERE description LIKE 'Guides for mitigating orchard environmental stress:%' LIMIT 1),
  'Managing Fruit Crops in Drought',
  'https://www.horticulture.com.au/globalassets/hort-innovation/resource-assets/managing-horticultural-crops-in-drought.pdf',
  NULL
),
(
  (SELECT operation_id FROM operation WHERE description LIKE 'Guides for mitigating orchard environmental %' LIMIT 1),
  'Critical Temperatures / Bud Death Table',
  'https://cpg.treefruit.wsu.edu/environmental-fruit-protectants/apple-sunburn/',
  NULL
),
(
  (SELECT operation_id FROM operation WHERE description LIKE 'Guides for mitigating orchard environmental %' LIMIT 1),
  'Wildlife Management in Apples',
  'https://www.horticulture.com.au/globalassets/hort-innovation/resource-assets/managing-bird-damage-to-fruit-and-other-horticultural-crops.pdf',
  NULL
);


-- Insert Integrated Pest and Disease Management operation
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG01' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'Refer to the strategy outlined in the manual for monitoring duration and frequency, symptom descriptions, and appropriate actions. Practical recommendations are available for different stages based on crop goals and observations.',
  'IPDM',
  'Monitoring and action thresholds'
);

-- Add guide reference for IPDM operation
INSERT INTO guidereference (
  operation_id, third_party_database, link, page_number
) VALUES (
  (SELECT operation_id FROM operation WHERE description = 'Refer to the strategy outlined in the manual for monitoring duration and frequency, symptom descriptions, and appropriate actions. Practical recommendations are available for different stages based on crop goals and observations.' LIMIT 1),
  'Integrated Pest Management for Australian Apples & Pears',
  'https://www.horticulture.com.au/globalassets/hort-innovation/resource-assets/2020-21-australian-apple-and-pear-ipdm-manual.pdf',
  'pp. 12-18'
);





-- Thinning (ODG02)
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG02' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'Remove buds, flowers, or fruits manually, mechanically, or chemically, depending on the method. This operation generally occurs once per season, with supplementary hand thinning later if the effect of initial thinning on fruit size or return bloom is not sufficient cite{stoverMethodAssessingRelationship2001}; Control 4-6 fruits per square cm of trunk cross-sectional area (TCSA), varying by variety cite{robinsonCropLoadManagement2008}.',
  'Thinning',
  'Fruit load management'
);

-- Add guide reference for environmental stress management
INSERT INTO guidereference (
  operation_id, third_party_database, link, page_number
) VALUES (
  (SELECT operation_id FROM operation WHERE description = 'Remove buds, flowers, or fruits manually, mechanically, or chemically, depending on the method. This operation generally occurs once per season, with supplementary hand thinning later if the effect of initial thinning on fruit size or return bloom is not sufficient cite{stoverMethodAssessingRelationship2001}; Control 4-6 fruits per square cm of trunk cross-sectional area (TCSA), varying by variety cite{robinsonCropLoadManagement2008}.'),
  'Oregon Apple Pest and Frost Management Guide',
  'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf',
  'p. 82'
);

INSERT INTO guidereference (
  operation_id, third_party_database, link, page_number
) VALUES (
  (SELECT operation_id FROM operation WHERE description = 'Remove buds, flowers, or fruits manually, mechanically, or chemically, depending on the method. This operation generally occurs once per season, with supplementary hand thinning later if the effect of initial thinning on fruit size or return bloom is not sufficient cite{stoverMethodAssessingRelationship2001}; Control 4-6 fruits per square cm of trunk cross-sectional area (TCSA), varying by variety cite{robinsonCropLoadManagement2008}.'),
  'Agriculture: Apple Pest Management Guidelines',
  'https://ipm.ucanr.edu/agriculture/apple/apple-thinning-sprays/#gsc.tab=0',
  NULL
);


INSERT INTO guidereference (
  operation_id, third_party_database, link, page_number
) VALUES (
  (SELECT operation_id FROM operation WHERE description = 'Remove buds, flowers, or fruits manually, mechanically, or chemically, depending on the method. This operation generally occurs once per season, with supplementary hand thinning later if the effect of initial thinning on fruit size or return bloom is not sufficient cite{stoverMethodAssessingRelationship2001}; Control 4-6 fruits per square cm of trunk cross-sectional area (TCSA), varying by variety cite{robinsonCropLoadManagement2008}.'),
  'Washington Apple Orchard Systems Hub',
  'https://cpg.treefruit.wsu.edu/bioregulator-sprays/apple-chemical-thinning/',
  NULL
);

-- Pruning & Training

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG02' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'Remove shoots or limbs to maintain canopy within space during the dormant and summer seasons annually. See different pruning plans at cite{ferreeApplesBotanyProduction2003}. In larger orchards, pruning may be scheduled every second or third year to manage costs cite{ferreeApplesBotanyProduction2003}.',
 'Pruning & Training',
  'Canopy management'
);

-- Add guide reference for environmental stress management
INSERT INTO guidereference (
  operation_id, third_party_database, link, page_number
) VALUES (
  (SELECT operation_id FROM operation WHERE description = 'Remove shoots or limbs to maintain canopy within space during the dormant and summer seasons annually. See different pruning plans at cite{ferreeApplesBotanyProduction2003}. In larger orchards, pruning may be scheduled every second or third year to manage costs cite{ferreeApplesBotanyProduction2003}.'),
    'Apples: Botany, Production, and Uses',
  'https://books.google.com.au/books/about/Apples.html?id=MmuBCwAAQBAJ&redir_esc=y',
  'pp. 319-344'
);



-- Step 1: Insert operations into new structure
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES

-- Nutrient management
((SELECT stage_id FROM stage WHERE stage_code = 'ODG02' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'dzikitiEstimatingWaterRequirements2018' LIMIT 1),
 'Apply once in the spring and once in the autumn after fruiting cite{howFertilizeApple2023}; Integrated Orchard Management Guide for Commercial Apples in the Southeast, 2023 cite{2023IntegratedOrchard2023}.',
 'Nutrient management', 'Seasonal fertilization'),

-- Plant growth regulator
((SELECT stage_id FROM stage WHERE stage_code = 'ODG02' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'dzikitiEstimatingWaterRequirements2018' LIMIT 1),
 'Apply plant growth regulator to adjust the growth and characteristics of tree and fruit as necessary. For practical recommendation tailored to different developmental stages, refer to cite{2023IntegratedOrchardManagement2023}.',
 'Plant growth regulator', ''),

-- Irrigation
((SELECT stage_id FROM stage WHERE stage_code = 'ODG02' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'dzikitiEstimatingWaterRequirements2018' LIMIT 1),
 'The irrigation schedule is based on thresholds or indexes determined by the method or simulation model specific to field, accounting for weather, soil and plant status cite{ferreeApplesBotanyProduction2003} Refer to cite{bolandGuideBestPractice2002} for maintaining soil moisture tension between 8 and 40 kPa, except dormancy period. In drought conditions, it is advisable to irrigate even in winter cite{ferreeApplesBotanyProduction2003}. Mature trees may require more frequent irrigation cite{dzikitiEstimatingWaterRequirements2018}.',
 'Irrigation', 'Mature orchard watering'),

-- Orchard floor management
((SELECT stage_id FROM stage WHERE stage_code = 'ODG02' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'brightOrchardPlantProtection2006' LIMIT 1),
 'Use mulching or herbicides to eliminate weeds.',
 'Orchard floor management', 'Weed control'),

((SELECT stage_id FROM stage WHERE stage_code = 'ODG02' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Up to six cultivations per season may be required; Herbicide spraying requires 200-400L per ha.',
 'Orchard floor management', 'Cultivation practice'),

((SELECT stage_id FROM stage WHERE stage_code = 'ODG02' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Herbicides spraying require 200-400l per ha of material to be effective and the water volume varies with the herbicide type cite{ferreeApplesBotanyProduction2003}',
 'Orchard floor management', 'Weed control'),

((SELECT stage_id FROM stage WHERE stage_code = 'ODG02' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = '2023IntegratedOrchardManagement' LIMIT 1),
 'Refer to herbicide usage guidelines for effectiveness by type.',
 'Orchard floor management', 'Herbicide usage'),


-- IPDM
((SELECT stage_id FROM stage WHERE stage_code = 'ODG02' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'hetheringtonIntegratedPestDisease2005' LIMIT 1),
 'Refer to monitoring strategy with frequency, symptom description, and appropriate actions.',
 'IPDM', 'Monitoring & intervention');

-- Step 2: Add references to guidereference table
INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES

-- Nutrient
((SELECT operation_id FROM operation WHERE description LIKE 'Apply once in the spring and once in the autumn%' LIMIT 1),
 'Washington Apple Orchard Systems Hub', 'https://treefruit.wsu.edu/orchard-management/soils-nutrition/', NULL),

-- PGR
((SELECT operation_id FROM operation WHERE description LIKE 'Apply plant growth regulator to adjust%' LIMIT 1),
 'Orchard Growth Regulator Guide', 'https://cpg.treefruit.wsu.edu/bioregulator-sprays/', NULL),

-- Irrigation
((SELECT operation_id FROM operation WHERE description LIKE 'The irrigation schedule is based on thresholds%' LIMIT 1),
 'Washington Apple Orchard Systems Hub', 'https://treefruit.wsu.edu/orchard-management/irrigation-management/', NULL),

-- Weed control
((SELECT operation_id FROM operation WHERE description LIKE 'Use mulching or herbicides to eliminate weeds%' LIMIT 1),
 'Orchard Plant Protection Guide', 'https://treefruit.wsu.edu/orchard-management/orchard-floor-management/', NULL),

-- Cultivation 1
((SELECT operation_id FROM operation WHERE description LIKE 'Up to six cultivations per season%' LIMIT 1),
 'Apples: Botany, Production, and Uses',
  'https://books.google.com.au/books/about/Apples.html?id=MmuBCwAAQBAJ&redir_esc=y', NULL),

-- Cultivation 2
((SELECT operation_id FROM operation WHERE description LIKE 'Herbicides spraying require 200-400l%' LIMIT 1),
 'Apples: Botany, Production, and Uses',
  'https://books.google.com.au/books/about/Apples.html?id=MmuBCwAAQBAJ&redir_esc=y', NULL),

-- Herbicide usage
((SELECT operation_id FROM operation WHERE description LIKE 'Refer to herbicide usage guidelines%' LIMIT 1),
 'Apples: Botany, Production, and Uses',
  'https://books.google.com.au/books/about/Apples.html?id=MmuBCwAAQBAJ&redir_esc=y', NULL),


-- IPDM
((SELECT operation_id FROM operation WHERE description LIKE 'Refer to monitoring strategy with frequency%' LIMIT 1),
 'Northeast Apple Orchard Best Practices Manual', 'https://netreefruit.org/apples', 'p. 198');






INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG02' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'Use reflective films and shading such as coloured net; Bagging is also a common management strategy to protect fruit from sunburn and environmental damage.',
  'Environmental stress management',
  'Light & heat protection'
);

-- Add guide reference for environmental stress management
INSERT INTO guidereference (
  operation_id, third_party_database, link, page_number
) VALUES (
  (SELECT operation_id FROM operation WHERE description = 'Use reflective films and shading such as coloured net; Bagging is also a common management strategy to protect fruit from sunburn and environmental damage.' LIMIT 1),
  'New England Orchard BMP Manual',
  'https://www.umass.edu/agriculture-food-environment/fruit/publications/orchard-bmp-manual',
  'p. 80'
);

-- Insert operation: Environmental stress management - extreme events
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG02' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'Guides for mitigating orchard environmental stress: hail, bushfires, drought, and wildlife. Includes bird protection, critical temperature charts, and sunburn prevention practices.',
  'Environmental stress management',
  'Extreme weather and animal protection'
);

-- Add multiple relevant third-party resource links
INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
(
  (SELECT operation_id FROM operation WHERE description LIKE 'Guides for mitigating orchard environmental stress: hail, bushfires, drought, and wildlife. Includes bird protection, critical temperature charts, and sunburn prevention practices.' LIMIT 1),
  'Environmental Stress Guide – Apple',
  'https://www.horticulture.com.au/globalassets/hort-innovation/resource-assets/hail-damage-and-your-apple-orchard.pdf',
  NULL
),
(
  (SELECT operation_id FROM operation WHERE description LIKE 'Guides for mitigating orchard environmental stress: hail, bushfires, drought, and wildlife. Includes bird protection, critical temperature charts, and sunburn prevention practices.' LIMIT 1),
  'Bushfire Response for Orchards',
  'https://www.horticulture.com.au/globalassets/hort-innovation/resource-assets/bushfires-in-orchards-preparedness-response-recovery.pdf',
  NULL
),
(
  (SELECT operation_id FROM operation WHERE description LIKE 'Guides for mitigating orchard environmental stress: hail, bushfires, drought, and wildlife. Includes bird protection, critical temperature charts, and sunburn prevention practices.' LIMIT 1),
  'Managing Fruit Crops in Drought',
  'https://www.horticulture.com.au/globalassets/hort-innovation/resource-assets/managing-horticultural-crops-in-drought.pdf',
  NULL
),
(
  (SELECT operation_id FROM operation WHERE description LIKE 'Guides for mitigating orchard environmental stress: hail, bushfires, drought, and wildlife. Includes bird protection, critical temperature charts, and sunburn prevention practices.' LIMIT 1),
  'Critical Temperatures / Bud Death Table',
  'https://cpg.treefruit.wsu.edu/environmental-fruit-protectants/apple-sunburn/',
  NULL
),
(
  (SELECT operation_id FROM operation WHERE description LIKE 'Guides for mitigating orchard environmental stress: hail, bushfires, drought, and wildlife. Includes bird protection, critical temperature charts, and sunburn prevention practices.' LIMIT 1),
  'Wildlife Management in Apples',
  'https://www.horticulture.com.au/globalassets/hort-innovation/resource-assets/managing-bird-damage-to-fruit-and-other-horticultural-crops.pdf',
  NULL
);

-- Pollination: Defruiting
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'ODG02' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'Select appropirate pollinizer trees and ensure sufficient pollen availability; Use of honeybees is recommended for pollination; Avoid using insecticides during flowering to protect pollinators; Use of pheromone traps to monitor pest populations and reduce pesticide use.',
  'Pruning & Training', 'Pollination'
);
INSERT INTO guidereference (operation_id, third_party_database, link, page_number)
VALUES (
  (SELECT operation_id FROM operation WHERE description LIKE 'Select appropirate pollinizer trees%' LIMIT 1),
  'NSW Apple Crop Protection and Nutrition Portal', 'https://www.dpi.nsw.gov.au/agriculture/horticulture/pomes/apples/crabapple-pollinators', NULL
);
INSERT INTO guidereference (operation_id, third_party_database, link, page_number)
VALUES (
  (SELECT operation_id FROM operation WHERE description LIKE 'Select appropirate pollinizer trees%' LIMIT 1),
  'Washington Apple Orchard Systems Hub', 'https://treefruit.wsu.edu/orchard-management/pollination/', NULL
);
















-- Insert operations
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
-- Mealybugs
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Monitor and control Mealybugs during Bud Swell to Beginning of Dormancy.',
 'IPDM', 'Mealybugs'),

-- Oriental fruit moth
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Monitor Oriental fruit moth throughout season from Bud Swell through Dormancy.',
 'IPDM', 'Oriental fruit moth'),

-- San José scale
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply dormant oil spray for San José scale from Bud Swell to Dormancy.',
 'IPDM', 'San José scale'),

-- Powdery mildew
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Manage powdery mildew through bud removal and fungicide at Bud Swell and blossom stage.',
 'Disease management', 'Powdery mildew'),

-- Bryobia mite
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply miticides during Midseason to End of Harvest to control Bryobia mite.',
 'IPDM', 'Bryobia mite'),

-- Herbicide usage
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply selective herbicides pre- and post-emergence for winter annuals and perennials.',
 'Orchard floor management', 'Herbicide usage'),

-- Apple scab
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply fungicides preventively at blossom and fruiting to prevent Apple scab.',
 'Disease management', 'Apple scab'),

-- Silver leaf
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Avoid pruning during wet conditions and manage for silver leaf across seasons.',
 'Disease management', 'Silver leaf'),

-- Phytophthora
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Manage root and collar rot through drainage improvements and chemical drenches across periods.',
 'Disease management', 'Phytophthora');



-- Mealybugs
INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description = 'Monitor and control Mealybugs during Bud Swell to Beginning of Dormancy.' LIMIT 1),
 '2020-21 IPDM Australia', 'https://www.horticulture.com.au/growers/help-your-business-grow/research-reports-publications-fact-sheets-and-more/grower-resources/ap16007-assets/2020-21-australian-apple-and-pear-ipdm-manual/', 'pp. 128-129');

-- Oriental fruit moth
INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description = 'Monitor Oriental fruit moth throughout season from Bud Swell through Dormancy.' LIMIT 1),
 '2020-21 IPDM Australia', 'https://www.horticulture.com.au/growers/help-your-business-grow/research-reports-publications-fact-sheets-and-more/grower-resources/ap16007-assets/2020-21-australian-apple-and-pear-ipdm-manual/', 'pp. 122-124');

-- San José scale
INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description = 'Apply dormant oil spray for San José scale from Bud Swell to Dormancy.' LIMIT 1),
 'NSW apple portal', 'https://www.dpi.nsw.gov.au/agriculture/horticulture/pomes/pests-etc/ipm-apples-pears', 'p. 193');

-- San José scale
INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description = 'Apply dormant oil spray for San José scale from Bud Swell to Dormancy.' LIMIT 1),
 'Washington Apple Crop Protection Guide', 'https://cpg.treefruit.wsu.edu/apple-programs/overview/', NULL);


-- Powdery mildew
INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description = 'Manage powdery mildew through bud removal and fungicide at Bud Swell and blossom stage.' LIMIT 1),
 '2020-21 IPDM Australia', 'https://www.horticulture.com.au/growers/help-your-business-grow/research-reports-publications-fact-sheets-and-more/grower-resources/ap16007-assets/2020-21-australian-apple-and-pear-ipdm-manual/', 'p. 266');


INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description = 'Manage powdery mildew through applying products' LIMIT 1),
 'New England Mangament Guide', 'https://netreefruit.org/apples/spray-table/1-dormant-silver-tip-apple', NULL);



-- Bryobia mite
INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description = 'Apply miticides during Midseason to End of Harvest to control Bryobia mite.' LIMIT 1),
 '2020-21 IPDM Australia', 'https://www.horticulture.com.au/growers/help-your-business-grow/research-reports-publications-fact-sheets-and-more/grower-resources/ap16007-assets/2020-21-australian-apple-and-pear-ipdm-manual/', 'p. 47');

-- Herbicide usage
INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description = 'Apply selective herbicides pre- and post-emergence for winter annuals and perennials.' LIMIT 1),
 '2020-21 IPDM Australia', 'https://www.horticulture.com.au/growers/help-your-business-grow/research-reports-publications-fact-sheets-and-more/grower-resources/ap16007-assets/2020-21-australian-apple-and-pear-ipdm-manual/', 'pp. 111-115');

-- Apple scab
INSERT INTO guidereference  (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description = 'Apply fungicides preventively at blossom and fruiting to prevent Apple scab.' LIMIT 1),
 '2020-21 IPDM Australia', 'https://www.horticulture.com.au/growers/help-your-business-grow/research-reports-publications-fact-sheets-and-more/grower-resources/ap16007-assets/2020-21-australian-apple-and-pear-ipdm-manual/', 'pp. 39-42');

-- Silver leaf
INSERT INTO guidereference (operation_id, third_party_database, link, page_number)  VALUES
((SELECT operation_id FROM operation WHERE description = 'Avoid pruning during wet conditions and manage for silver leaf across seasons.' LIMIT 1),
 'NSW apple portal', 'https://www.dpi.nsw.gov.au/__data/assets/pdf_file/0011/1580069/Silver-leaf.pdf', 'p. 122');

-- Phytophthora
INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description = 'Manage root and collar rot through drainage improvements and chemical drenches across periods.' LIMIT 1),
 'NSW apple portal', 'https://www.dpi.nsw.gov.au/agriculture/horticulture/pomes/pests-etc/phytophthora-root-and-collar-rot', 'p. 114');




-- OAR01
-- OAR01 Operation Inserts

-- -- Apple Scab
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR01' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Manage for apple scab at delayed dormant and green tip stages using protective fungicide programs.',
--  'Disease management', 'Apple scab');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Manage for apple scab at delayed dormant and green tip stages using protective fungicide programs.' LIMIT 1),
--  'New Jersey Tree Fruit Guide', 'https://njaes.rutgers.edu/tree-fruit/', 'pp. 254-255');

-- -- Powdery Mildew
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR01' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Apply fungicide for powdery mildew at green tip stage.',
--  'Disease management', 'Powdery mildew');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Apply fungicide for powdery mildew at green tip stage.' LIMIT 1),
--  'New Jersey Tree Fruit Guide', 'https://njaes.rutgers.edu/tree-fruit/', 'pp. 254-255');

-- -- Rosy Apple Aphid, Scale Insects, European Red Mite Eggs
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR01' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Monitor and control Rosy Apple Aphid, Scale Insects, and ERM eggs during delayed dormant stage.',
--  'IPDM', 'Multiple insects');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Monitor and control Rosy Apple Aphid, Scale Insects, and ERM eggs during delayed dormant stage.' LIMIT 1),
--  'New Jersey Tree Fruit Guide', 'https://njaes.rutgers.edu/tree-fruit/', 'p. 256');

-- -- Fire Blight
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR01' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Manage fire blight with copper-based sprays at bud swell or green ti ',
--  'Disease management', 'Fire blight');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Manage fire blight with copper-based sprays at bud swell or green ti ' LIMIT 1),
--  'Integrated Orchard Management Guide for Commercial Apples in the Southeast', 'https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast', 'p. 6');

-- -- Black Rot, Crown Rot
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR01' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Prevent and treat black rot and crown rot with cultural and chemical measures at delayed dormant stage.',
--  'Disease management', 'Black rot and crown rot');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Prevent and treat black rot and crown rot with cultural and chemical measures at delayed dormant stage.' LIMIT 1),
--  'Integrated Orchard Management Guide for Commercial Apples in the Southeast', 'https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast', 'p. 6');

-- -- Plant Growth Regulators (MaxCel, Promalin)
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR01' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Apply MaxCel or Promalin at green tip to improve fruit set and reduce russeting.',
--  'Plant growth regulator', 'Green tip PGR');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Apply MaxCel or Promalin at green tip to improve fruit set and reduce russeting.' LIMIT 1),
--  'Integrated Orchard Management Guide for Commercial Apples in the Southeast', 'https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast', 'p. 7');


-- OAR10 Operation Inserts

-- -- Apple Scab
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR10' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Apply fungicide spray for scab control at green tip and half-inch green stages.',
--  'Disease management', 'Apple scab');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Apply fungicide spray for scab control at green tip and half-inch green stages.' LIMIT 1),
--  'New Jersey Tree Fruit Guide', 'https://njaes.rutgers.edu/pubs/publication.php?pid=E002', 'pp. 254-255');

-- -- Fire Blight
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR10' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Apply copper-based sprays for fire blight prevention at green tip or half-inch green stages.',
--  'Disease management', 'Fire blight');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Apply copper-based sprays for fire blight prevention at green tip or half-inch green stages.' LIMIT 1),
--  'Integrated Orchard Management Guide for Commercial Apples in the Southeast', 'https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast', 'p. 9');

-- -- Phytophthora
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR10' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Implement rootstock selection and fungicides to manage phytophthora root and collar rot.',
--  'Disease management', 'Phytophthora');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Implement rootstock selection and fungicides to manage phytophthora root and collar rot.' LIMIT 1),
--  'Integrated Orchard Management Guide for Commercial Apples in the Southeast', 'https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast', 'p. 9');

-- -- European Red Mite, Rosy Apple Aphid, Winter Moth
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR10' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Monitor and control ERM, Rosy Apple Aphid, and Winter Moth from green tip through half-inch green.',
--  'IPDM', 'Multiple insects');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Monitor and control ERM, Rosy Apple Aphid, and Winter Moth from green tip through half-inch green.' LIMIT 1),
--  'New England Tree Fruit Management Guide', 'https://netreefruit.org/apples/spray-table/3-half-inch-green-apple', NULL);

-- -- Redbanded Leafroller, White Prunicola Scale, Dogwood Borer
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR10' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Monitor for Redbanded Leafroller, Dogwood Borer, and White Prunicola Scale at half-inch green stage.',
--  'IPDM', 'Lepidoptera borers');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Monitor for Redbanded Leafroller, Dogwood Borer, and White Prunicola Scale at half-inch green stage.' LIMIT 1),
--  'New England Tree Fruit Management Guide', 'https://netreefruit.org/apples/spray-table/3-half-inch-green-apple', NULL);

-- -- Codling Moth, LBAM (Pheromone Mating Disruption)
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR10' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Use pheromone disruption methods to control codling moth and lightbrown apple moth.',
--  'IPDM', 'Mating disruption');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Use pheromone disruption methods to control codling moth and lightbrown apple moth.' LIMIT 1),
--  'Integrated Pest Management for Australian apples & pears', 'https://www.dpi.nsw.gov.au/agriculture/horticulture/pomes/pests-etc/ipm-apples-pears', 'pp. 183, 226');

-- -- Powdery Mildew
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR10' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Apply fungicides for powdery mildew at green cluster and half-inch green stages.',
--  'Disease management', 'Powdery mildew');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Apply fungicides for powdery mildew at green cluster and half-inch green stages.' LIMIT 1),
--  'Integrated Pest Management for Australian apples & pears', 'https://www.dpi.nsw.gov.au/agriculture/horticulture/pomes/pests-etc/ipm-apples-pears', 'pp. 183, 266');

--  -- OAR11 Operation Inserts

-- -- Apple Scab (Fruit Cluster)
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR11' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Apply fungicide during fruit cluster stage to protect against apple scab development.',
--  'Disease management', 'Apple scab');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Apply fungicide during fruit cluster stage to protect against apple scab development.' LIMIT 1),
--  'Midwest Apple Pest Management Guide', 'https://ag.purdue.edu/department/hla/extension/_docs/id-465.pdf', 'p. 21');

-- -- Powdery Mildew
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR11' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Spray against powdery mildew on shoots and young leaves at fruit cluster stage.',
--  'Disease management', 'Powdery mildew');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Spray against powdery mildew on shoots and young leaves at fruit cluster stage.' LIMIT 1),
--  'Integrated Pest Management for Australian apples & pears', 'https://www.dpi.nsw.gov.au/agriculture/horticulture/pomes/pests-etc/ipm-apples-pears', 'p. 266');

-- -- Codling Moth (Mating Disruption)
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR11' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Deploy mating disruption strategies for codling moth before adult emergence.',
--  'IPDM', 'Codling moth');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Deploy mating disruption strategies for codling moth before adult emergence.' LIMIT 1),
--  'Integrated Pest Management for Australian apples & pears', 'https://www.dpi.nsw.gov.au/agriculture/horticulture/pomes/pests-etc/ipm-apples-pears', 'p. 183');

-- -- Lightbrown Apple Moth (Pheromone)
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR11' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Apply pheromone for mating disruption targeting LBAM.',
--  'IPDM', 'Lightbrown Apple Moth');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Apply pheromone for mating disruption targeting LBAM.' LIMIT 1),
--  'Integrated Pest Management for Australian apples & pears', 'https://example.com/ipm-aus', 'p. 183');


-- OAR12 Operation Inserts

-- Blossom Thinning: GA & BA
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR12' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Apply gibberellins (GA) and benzyladenine (BA) for chemical thinning at full bloom stage.',
--  'Thinning', 'Blossom thinning');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Apply gibberellins (GA) and benzyladenine (BA) for chemical thinning at full bloom stage.' LIMIT 1),
--  'Integrated Orchard Management Guide for Commercial Apples in the Southeast', 'https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast', 'p. 191');

-- -- Blossom-End Rot Control
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR12' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Monitor and control blossom-end rot with calcium sprays during full bloom to petal fall.',
--  'Disease management', 'Blossom-end rot');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Monitor and control blossom-end rot with calcium sprays during full bloom to petal fall.' LIMIT 1),
--  'Midwest Apple Pest Management Guide', 'https://ag.purdue.edu/department/hla/extension/_docs/id-465.pdf', 'p. 22');

-- -- European Red Mite & Aphid Spray
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR12' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Apply miticide or aphicide at petal fall to control European red mite and aphids.',
--  'IPDM', 'Aphid & Mite Control');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Apply miticide or aphicide at petal fall to control European red mite and aphids.' LIMIT 1),
--  'New England Tree Fruit Management Guide', 'https://netreefruit.org/apples/chemical-fruit-thinning-and-other-plant-growth-regulator-uses/vegetative-growth-control', NULL);

-- Pollination Management
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR12' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Place honeybee hives prior to 10% bloom and avoid insecticide use during full bloom.',
--  'Environmental stress management', 'Pollinator protection');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Place honeybee hives prior to 10% bloom and avoid insecticide use during full bloom.' LIMIT 1),
--  'Integrated Orchard Management Guide for Commercial Apples in the Southeast', 'https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast', 'p. 24');

-- -- Codling Moth Trapping
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR12' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Install pheromone traps to monitor codling moth flight and adjust sprays accordingly.',
--  'IPDM', 'Moth monitoring');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Install pheromone traps to monitor codling moth flight and adjust sprays accordingly.' LIMIT 1),
--  'Integrated Pest Management for Australian apples & pears', 'https://www.dpi.nsw.gov.au/agriculture/horticulture/pomes/pests-etc/ipm-apples-pears', 'p. 183');


-- OAR43 Operation Inserts

-- Apple Scab and Powdery Mildew Management
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR43' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Spray fungicides to prevent apple scab and powdery mildew infections during tight cluster stage.',
--  'Disease management', 'Apple scab & Powdery mildew');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Spray fungicides to prevent apple scab and powdery mildew infections during tight cluster stage.' LIMIT 1),
--  'New Jersey Commercial Tree Fruit Production Guide', 'https://njaes.rutgers.edu/pubs/publication.php?pid=E002', 'pp. 257-258');

-- -- Rosy Apple Aphid and Leafminer Control
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR43' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Apply insecticides at tight cluster for controlling rosy apple aphid and spotted tentiform leafminer.',
--  'IPDM', 'Aphid & Leafminer');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Apply insecticides at tight cluster for controlling rosy apple aphid and spotted tentiform leafminer.' LIMIT 1),
--  'New Jersey Commercial Tree Fruit Production Guide', 'https://njaes.rutgers.edu/pubs/publication.php?pid=E002', 'pp. 258-259');

-- -- Scale Insect and Red Mite Eggs Management
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR43' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Target San José scale and European red mite eggs with delayed dormant sprays at prepink stage.',
--  'IPDM', 'Scale & Mite Eggs');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Target San José scale and European red mite eggs with delayed dormant sprays at prepink stage.' LIMIT 1),
--  'Oregon Apple Pest and Frost Management Guide', 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 41');

-- -- Codling Moth and Leafroller Monitoring
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR43' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Monitor codling moth and leafroller through pheromone traps and visual inspection during prepink to pink stages.',
--  'IPDM', 'Moth & Leafroller monitoring');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Monitor codling moth and leafroller through pheromone traps and visual inspection during prepink to pink stages.' LIMIT 1),
--  'Integrated Orchard Management Guide for Commercial Apples in the Southeast', 'https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast', 'p. 13');

-- -- Fungicide Rotation Strategy
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR43' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Implement fungicide rotation to prevent resistance for diseases such as rust, black rot, and frogeye.',
--  'Disease management', 'Fungicide resistance strategy');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Implement fungicide rotation to prevent resistance for diseases such as rust, black rot, and frogeye.' LIMIT 1),
--  'Midwest Apple Pest Management Guide', 'https://ag.purdue.edu/department/hla/extension/_docs/id-465.pdf', 'pp. 12-13');




-- OAR44

-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR44' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Apply fungicides to manage apple scab, cedar apple rust, powdery mildew, black rot, white rot, and bitter rot during the pink stage.',
--  'Disease management', 'Apple scab, Powdery mildew, Rusts, Rots');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE  description LIKE 'Apply fungicides to manage apple scab%' LIMIT 1),
--  'Oregon Apple Pest and Frost Management Guide', 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'pp. 46-47');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE  description LIKE 'Apply fungicides to manage apple scab%' LIMIT 1),
--  'New England Tree Fruit Management Guide', 'https://netreefruit.org/apples/spray-table/5-pink-apple', NULL);

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE  description LIKE 'Apply fungicides to manage apple scab%' LIMIT 1),
--  'Washington Apple Crop Protection Guide', 'https://cpg.treefruit.wsu.edu/apple-programs/overview/%23delayed_dormant', NULL);
 
--  INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE  description LIKE 'Apply fungicides to manage apple scab%' LIMIT 1),
--  'Apple Crop Management Research Library (AU)', 'https://www.horticulture.com.au/growers/help-your-business-grow/research-reports-publications-fact-sheets-and-more/grower-resources/ap16007-assets/2020-21-australian-apple-and-pear-ipdm-manual/', 'Apple dimpling bug ( 141), Codling moth ( 193), LBAM ( 226), WFM ( 226), Powdery mildew ( 266)');
 
 


-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR44' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Monitor and manage codling moth, dogwood borer, oriental fruit moth, European apple sawfly, winter moth, mullein plant bug, tarnished plant bug, spotted tentiform leafminer, and rosy apple aphid.',
--  'IPDM', 'Insect & mite control');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE  description LIKE 'Monitor and manage codling moth, dogwood borer%' LIMIT 1),
--  'Oregon Apple Pest and Frost Management Guide', 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 44');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE  description LIKE 'Apply fungicides to manage apple scab%' LIMIT 1),
--  'New England Tree Fruit Management Guide', 'https://netreefruit.org/apples/spray-table/5-pink-apple', NULL);

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE  description LIKE 'Apply fungicides to manage apple scab%' LIMIT 1),
--  'Washington Apple Crop Protection Guide', 'https://cpg.treefruit.wsu.edu/apple-programs/overview/%23delayed_dormant', NULL);
 


-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR44' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Apply pheromone-based mating disruption techniques where appropriate.',
--  'IPDM', 'Codling moth mating disruption');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE  description LIKE 'Apply pheromone-based mating disruption techniques where%' LIMIT 1),
--  'Midwest Apple Pest Management Guide', 'https://ag.purdue.edu/department/hla/extension/_docs/id-465.pdf', 'pp. 12-13');

-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR44' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Target eggs and early nymphs with miticides during this stage.',
--  'IPDM', 'European red mite');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE  description LIKE 'Target eggs and early nymphs with miticides during this stage.%' LIMIT 1),
--  'NSW Apple Crop Protection and Nutrition Portal', 'https://www.dpi.nsw.gov.au/agriculture/horticulture/pomes/pests-etc/ipm-apples-pears', 'p. 185');


-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR44' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Conduct nutrient applications guided by tissue analysis to support healthy bloom and early fruit development.',
--  'Nutrient management', 'Nutrient application');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE  description LIKE 'Conduct nutrient applications guided by tissue analysis to support healthy bloom and early fruit development.%' LIMIT 1),
--  'Midwest Apple Pest Management Guide', 'https://ag.purdue.edu/department/hla/extension/_docs/id-465.pdf', 'pp. 184-185');





-- General Disease Management During Bloom
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR50' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'oregonTreeFruitGuide2025' LIMIT 1),
 'Apply insecticides such as Delegate 25WG, Entrust 2SC, or Success 2L during early through full bloom for control of leafroller and thrips. Time application around petal fall to optimize efficacy while minimizing bee impact.',
 'IPDM', 'Bloom period insects');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply insecticides such as Delegate 25WG%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide', 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 47');


-- -- OAR55 Operation Inserts

-- -- General Disease Management During Bloom
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR55' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Apply fungicides during full bloom for diseases like apple scab, fire blight, powdery mildew, rusts, and rots.',
--  'Disease management', 'Bloom period diseases');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Apply fungicides during full bloom for diseases like apple scab, fire blight, powdery mildew, rusts, and rots.' LIMIT 1),
--  'Oregon Apple Pest and Frost Management Guide', 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 48');

-- -- Cultural Management at Flowering
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR55' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Perform bag removal and leader selection as part of bloom-stage cultural management.',
--  'Pruning & Training', 'Cultural management');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Perform bag removal and leader selection as part of bloom-stage cultural management.' LIMIT 1),
--  'Integrated Orchard Management Guide for Commercial Apples in the Southeast', 'https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast', 'p. 12');

-- -- Use of Promalin for Fruit Development and Frost Recovery
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR55' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Apply Promalin or Perlan at bloom to improve fruit shape, weight, and frost recovery.',
--  'Plant growth regulator', 'Bloom PGR use');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Apply Promalin or Perlan at bloom to improve fruit shape, weight, and frost recovery.' LIMIT 1),
--  'Integrated Orchard Management Guide for Commercial Apples in the Southeast', 'https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast', 'pp. 12-13');

-- -- Organic Alternatives for Bloom Disease Control
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR55' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Use organic products like LifeGard, Cueva, and Serenade during bloom as alternatives for disease control.',
--  'Disease management', 'Organic options');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Use organic products like LifeGard, Cueva, and Serenade during bloom as alternatives for disease control.' LIMIT 1),
--  'Integrated Orchard Management Guide for Commercial Apples in the Southeast', 'https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast', 'p. 13');

-- -- Apple Insect and Mite Monitoring During Bloom
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR55' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Monitor codling moth, oriental fruit moth, and mites (gypsy, lesser appleworm, red mite) during full bloom.',
--  'IPDM', 'Bloom insects & mites');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Monitor codling moth, oriental fruit moth, and mites (gypsy, lesser appleworm, red mite) during full bloom.' LIMIT 1),
--  'New England Tree Fruit Management Guide', 'https://www.umass.edu/agriculture-food-environment/fruit/publications/orchard-bmp-manual', NULL);


-- OAR57 Operation Inserts

-- -- Petal Fall Disease Management
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR57' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Apply fungicides to manage apple scab, cedar apple rust, and powdery mildew during petal fall stage.',
--  'Disease management', 'Apple scab, rust & mildew');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Apply fungicides to manage apple scab, cedar apple rust, and powdery mildew during petal fall stage.' LIMIT 1),
--  'New Jersey Commercial Tree Fruit Production Guide', 'https://njaes.rutgers.edu/pubs/publication.php?pid=E002', 'pp. 263-264');

-- -- Woolly Aphid and Green Apple Aphid Control
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR57' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Target woolly apple aphid and green apple aphid at petal fall with appropriate insecticides.',
--  'IPDM', 'Aphid management');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Target woolly apple aphid and green apple aphid at petal fall with appropriate insecticides.' LIMIT 1),
--  'New Jersey Commercial Tree Fruit Production Guide', 'https://njaes.rutgers.edu/pubs/publication.php?pid=E002', 'p. 265');

-- -- Leafroller, Sawfly, Curculio, and Other Insects
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR57' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Apply sprays to control codling moth, European apple sawfly, oriental fruit moth, leafroller, plum curculio, and tentiform leafminer.',
--  'IPDM', 'Mixed insect pests');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Apply sprays to control codling moth, European apple sawfly, oriental fruit moth, leafroller, plum curculio, and tentiform leafminer.' LIMIT 1),
--  'New Jersey Commercial Tree Fruit Production Guide', 'https://njaes.rutgers.edu/pubs/publication.php?pid=E002', 'p. 266');

-- -- Helicoverpa, Lightbrown Apple Moth, and Codling Moth (Australia)
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR57' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Spray for helicoverpa, loopers, lightbrown apple moth, and codling moth at petal fall.',
--  'IPDM', 'Moth control');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Spray for helicoverpa, loopers, lightbrown apple moth, and codling moth at petal fall.' LIMIT 1),
--  'Integrated Pest Management for Australian apples & pears', 'https://www.dpi.nsw.gov.au/agriculture/horticulture/pomes/pests-etc/ipm-apples-pears', 'p. 186');

-- -- Summer Thinning and Nutrient Management
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR57' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Conduct summer thinning and apply nutrients after petal fall to support fruit development.',
--  'Nutrient management', 'Post-bloom nutrient');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Conduct summer thinning and apply nutrients after petal fall to support fruit development.' LIMIT 1),
--  'Integrated Orchard Management Guide for Commercial Apples in the Southeast', 'https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast', 'p. 31');


-- -- OAR57 Operation Inserts

-- Petal Fall Disease Management
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR59' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Apply fungicides to manage apple scab, cedar apple rust, and powdery mildew during petal fall stage.',
--  'Disease management', 'Apple scab, rust & mildew');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Apply fungicides to manage apple scab, cedar apple rust, and powdery mildew during petal fall stage.' LIMIT 1),
--  'New Jersey Commercial Tree Fruit Production Guide', 'https://njaes.rutgers.edu/pubs/publication.php?pid=E002', 'pp. 263-264');

-- -- Woolly Aphid and Green Apple Aphid Control
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR59' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Target woolly apple aphid and green apple aphid at petal fall with appropriate insecticides.',
--  'IPDM', 'Aphid management');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Target woolly apple aphid and green apple aphid at petal fall with appropriate insecticides.' LIMIT 1),
--  'New Jersey Commercial Tree Fruit Production Guide', 'https://njaes.rutgers.edu/pubs/publication.php?pid=E002', 'p. 265');

-- -- Leafroller, Sawfly, Curculio, and Other Insects
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR59' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Apply sprays to control codling moth, European apple sawfly, oriental fruit moth, leafroller, plum curculio, and tentiform leafminer.',
--  'IPDM', 'Mixed insect pests');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Apply sprays to control codling moth, European apple sawfly, oriental fruit moth, leafroller, plum curculio, and tentiform leafminer.' LIMIT 1),
--  'New Jersey Commercial Tree Fruit Production Guide', 'https://njaes.rutgers.edu/pubs/publication.php?pid=E002', 'p. 266');

-- -- Helicoverpa, Lightbrown Apple Moth, and Codling Moth (Australia)
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR59' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Spray for helicoverpa, loopers, lightbrown apple moth, and codling moth at petal fall.',
--  'IPDM', 'Moth control');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Spray for helicoverpa, loopers, lightbrown apple moth, and codling moth at petal fall.' LIMIT 1),
--  'IPM Australia', 'https://example.com/ipm-aus-petalfall', 'p. 186');



-- OAR00 and OAR01 Entries --

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply dormant fungicide to reduce primary inoculum on bud surfaces.',
 'Disease management', 'Apple scab');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply dormant fungicide to reduce primary inoculum on bud surfaces.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 1');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Prune fire blight cankers and apply early-season bactericide if needed.',
 'Disease management', 'Fire blight');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Prune fire blight cankers and apply early-season bactericide if needed%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 2');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Remove infected buds or shoots to limit initial mildew pressure.',
 'Disease management', 'Powdery mildew');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Remove infected buds or shoots to limit initial mildew pressure.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 2');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Remove mummified fruit and prune dead wood to control latent rot sources.',
 'Disease management', 'Rot fungi');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Remove mummified fruit and prune dead wood to control latent rot sourc%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 2');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Prune canopy to improve fungicide coverage and drying.',
 'Disease management', 'Canopy penetration');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Prune canopy to improve fungicide coverage and drying.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 2');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply mating disruption ties prior to bud break to reduce first generation.',
 'IPDM', 'Codling moth mating disruption');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply mating disruption ties prior to bud break to reduce first genera%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 40');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Monitor bud feeding activity and apply dormant oil if threshold exceeded.',
 'IPDM', 'Winter moth');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Monitor bud feeding activity and apply dormant oil if threshold exceed%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 253');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply dormant oil to reduce overwintering egg populations.',
 'IPDM', 'European red mite');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply dormant oil to reduce overwintering egg populations.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 186');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Use dormant oil or insecticides to suppress scale before bud break.',
 'IPDM', 'European Fruit Lecanium');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Use dormant oil or insecticides to suppress scale before bud break.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 2');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply pre-emergent herbicides to control overwintering weeds.',
 'Orchard floor management', 'Winter annuals and perennials');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply pre-emergent herbicides to control overwintering weeds.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 2');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR00' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Spot treat with post-emergent herbicides where perennials persist.',
 'Orchard floor management', 'Broadleaf weeds');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Spot treat with post-emergent herbicides where perennials persist.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 2');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR01' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply protectant fungicides at delayed dormant to green tip.',
 'Disease management', 'Apple scab');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply protectant fungicides at delayed dormant to green tip.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 41');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR01' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Use systemic fungicides to protect emerging buds and shoots.',
 'Disease management', 'Powdery mildew');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Use systemic fungicides to protect emerging buds and shoots.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 41');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR01' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Remove early-season cankers and apply bactericides near green tip.',
 'Disease management', 'Fire blight');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Remove early-season cankers and apply bactericides near green tip.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 6');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR01' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply dormant fungicides and avoid trunk injury near soil line.',
 'Disease management', 'Black rot, Crown rot');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply dormant fungicides and avoid trunk injury near soil line.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 6');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR01' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply systemic insecticides before leaf curling begins.',
 'IPDM', 'Rosy apple aphid');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply systemic insecticides before leaf curling begins.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 256');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR01' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Target San Jose scale and other armored scales with oil sprays.',
 'IPDM', 'Scale insects');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Target San Jose scale and other armored scales with oil sprays.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 256');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR01' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Use dormant oil for effective egg suppression on branches.',
 'IPDM', 'European red mite eggs');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Use dormant oil for effective egg suppression on branches.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 256');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR01' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply near green tip to influence fruit set or mitigate frost injury.',
 'Plant growth regulator', 'MaxCel, Promalin');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply near green tip to influence fruit set or mitigate frost injury.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 7');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR01' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Clean up cankers and old fruit; apply early-season fungicides.',
 'Disease management', 'Bitter rot (Glomerella)');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Clean up cankers and old fruit; apply early-season fungicides.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 187');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR01' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply preventative fungicides to reduce early Alternaria symptoms.',
 'Disease management', 'Alternaria leaf spot');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply preventative fungicides to reduce early Alternaria symptoms.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 186');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR01' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply oil sprays targeting overwintering scales on trunks and limbs.',
 'IPDM', 'San José scale');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply oil sprays targeting overwintering scales on trunks and limbs.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 188');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR01' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Begin pheromone-based mating disruption before first emergence.',
 'IPDM', 'Oriental fruit moth');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Begin pheromone-based mating disruption before first emergence.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 64');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR01' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Scout trunks and roots, apply systemic insecticide if needed.',
 'IPDM', 'Mealybugs');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Scout trunks and roots, apply systemic insecticide if needed.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 62');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR01' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Survey and treat field margins to suppress locust swarms.',
 'IPDM', 'Australian plague locust');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Survey and treat field margins to suppress locust swarms.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 32');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR01' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply contact insecticides during bud burst if presence confirmed.',
 'IPDM', 'Budworms (Heliothis)');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply contact insecticides during bud burst if presence confirmed.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 37');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR01' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Treat infested buds before damage spreads to flowers and fruitlets.',
 'IPDM', 'Plague thrips');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Treat infested buds before damage spreads to flowers and fruitlets.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 69');




-- OAR10 and OAR11 Entries --

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR10' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Initiate primary scab control sprays during green tip and early leaf expansion.',
 'Disease management', 'Apple scab');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Initiate primary scab control sprays during green tip and early leaf e%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 8');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR10' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply copper or streptomycin sprays to prevent early infections.',
 'Disease management', 'Fire blight');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply copper or streptomycin sprays to prevent early infections.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 9');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR10' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply fungicide to control root and crown rot in wet soil conditions.',
 'Disease management', 'Phytophthora');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply fungicide to control root and crown rot in wet soil conditions.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 9');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR10' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply dormant oil or miticide if overwintering eggs are present.',
 'IPDM', 'European red mite');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply dormant oil or miticide if overwintering eggs are present.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 10');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR10' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Scout and apply insecticides at green tip before leaf curl.',
 'IPDM', 'Rosy apple aphid');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Scout and apply insecticides at green tip before leaf curl.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 10');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR10' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Treat young larvae with contact insecticides if bud feeding occurs.',
 'IPDM', 'Winter moth');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Treat young larvae with contact insecticides if bud feeding occurs.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 10');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR10' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Inspect trunk wounds and apply sprays around tree base if needed.',
 'IPDM', 'American plum borer');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Inspect trunk wounds and apply sprays around tree base if needed.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 10');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR10' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Monitor burr knots and apply trunk sprays if infestation is observed.',
 'IPDM', 'Dogwood borer');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Monitor burr knots and apply trunk sprays if infestation is observed.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 10');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR10' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Inspect trunk near soil line and treat for larvae if present.',
 'IPDM', 'Roundheaded apple tree borer');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Inspect trunk near soil line and treat for larvae if present.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 10');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR10' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Time control sprays based on pheromone traps or plant phenology.',
 'IPDM', 'Redbanded leafroller');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Time control sprays based on pheromone traps or plant phenology.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 10');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR10' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Use dormant oil or early insecticides to suppress scale crawlers.',
 'IPDM', 'San Jose scale');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Use dormant oil or early insecticides to suppress scale crawlers.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 10');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR10' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Treat early stage crawlers with oil or systemic insecticide.',
 'IPDM', 'White Prunicola Scale (WPS)');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Treat early stage crawlers with oil or systemic insecticide.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 10');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR10' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Begin mating disruption early in spring to reduce population buildup.',
 'IPDM', 'Lightbrown apple moth (LBAM)');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Begin mating disruption early in spring to reduce population buildup.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 183');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR10' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Monitor and treat early-season WFT feeding on green tissue.',
 'IPDM', 'Western flower thrips (WFT)');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Monitor and treat early-season WFT feeding on green tissue.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 226');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR10' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Prevent mildew infection with early protectant sprays at green cluster.',
 'Disease management', 'Powdery mildew');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Prevent mildew infection with early protectant sprays at green cluster%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 266');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR10' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply mating disruption products before bloom if traps indicate early activity.',
 'IPDM', 'Codling moth');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply mating disruption products before bloom if traps indicate early %' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 183');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR11' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Maintain coverage in humid weather to prevent secondary infections.',
 'Disease management', 'Apple scab');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Maintain coverage in humid weather to prevent secondary infections.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 53');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR11' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Control mildew through protective sprays on leaves and fruit.',
 'Disease management', 'Powdery mildew');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Control mildew through protective sprays on leaves and fruit.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 116');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR11' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply fungicides targeting summer rot pathogens under warm, wet conditions.',
 'Disease management', 'Bitter rot');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply fungicides targeting summer rot pathogens under warm, wet condit%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 189');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR11' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Rotate fungicides and maintain tree health to prevent infection.',
 'Disease management', 'Black and white rots');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Rotate fungicides and maintain tree health to prevent infection.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 189');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR11' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Use final fungicide coverage and sanitation to suppress blemishes.',
 'Disease management', 'Sooty blotch and flyspeck');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Use final fungicide coverage and sanitation to suppress blemishes.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 192');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR11' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Monitor for buildup and apply miticides if thresholds are exceeded.',
 'IPDM', 'European red mite');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Monitor for buildup and apply miticides if thresholds are exceeded.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 51');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR11' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Continue scheduled insecticide applications based on degree-day model.',
 'IPDM', 'Codling moth');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Continue scheduled insecticide applications based on degree-day model.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 45');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR11' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Target summer generation larvae feeding on fruit and leaves.',
 'IPDM', 'Obliquebanded leafroller');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Target summer generation larvae feeding on fruit and leaves.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 53');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR11' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Monitor and apply control measures through midseason generations.',
 'IPDM', 'Oriental fruit moth');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Monitor and apply control measures through midseason generations.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 64');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR11' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Treat crawlers during summer for effective suppression.',
 'IPDM', 'San Jose scale');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Treat crawlers during summer for effective suppression.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 53');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR11' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Treat if beetles are present on foliage or feeding on fruit.',
 'IPDM', 'Japanese beetle');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Treat if beetles are present on foliage or feeding on fruit.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 53');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR11' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply contact insecticides when fruit damage or feeding is detected.',
 'IPDM', 'Western flower thrips');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply contact insecticides when fruit damage or feeding is detected.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 85');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR11' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Spot treat orchard perimeters if damage is observed.',
 'IPDM', 'Wingless grasshopper');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Spot treat orchard perimeters if damage is observed.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 87');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR11' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Use bait sprays and traps to prevent late-season infestations.',
 'IPDM', 'Queensland fruit fly');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Use bait sprays and traps to prevent late-season infestations.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 71');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR11' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply border sprays if high populations are found near harvest.',
 'IPDM', 'Rutherglen bug');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply border sprays if high populations are found near harvest.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 74');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR11' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Treat larvae if they begin feeding internally on fruit.',
 'IPDM', 'Sparganothis fruitworm');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Treat larvae if they begin feeding internally on fruit.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 53');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR11' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply miticides or insecticides based on colony presence in canopy or roots.',
 'IPDM', 'Woolly apple aphid');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply miticides or insecticides based on colony presence in canopy or %' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 88');














-- OAR12
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR12' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Maintain fungicide coverage for scab, mildew, and fruit rots during cover sprays.',
 'Disease management', 'General disease control');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Maintain fungicide coverage for scab, mildew, and fruit rots during co%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 53');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR12' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Rotate insecticides for pests such as codling moth, aphids, and stink bugs in late spring and summer.',
 'IPDM', 'Insect pest control');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Rotate insecticides for pests such as codling moth, aphids, and stink %' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 53');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR12' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Scout for red mites and two-spotted mites and apply miticides based on thresholds.',
 'IPDM', 'Mite management');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Scout for red mites and two-spotted mites and apply miticides based on%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 54');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR12' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Use PGRs like prohexadione-calcium to control excessive shoot growth in summer.',
 'Plant growth regulator', 'Vegetative growth control');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Use PGRs like prohexadione-calcium to control excessive shoot growth i%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 53');



-- OAR60: Return Bloom Enhancement

-- Operation: Return Bloom Enhancement (PGR based)
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES (
  (SELECT stage_id FROM stage WHERE stage_code = 'OAR60' LIMIT 1),
  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
  'Apply plant growth regulators (e.g., NAA or Ethrel) approximately six to eight weeks after petal fall to encourage flower bud formation for the following season.',
  'Plant growth regulator', 'Return bloom enhancement'
);

-- Guidereference: New England Bloom Enhancement Protocol
INSERT INTO guidereference (
  operation_id, third_party_database, link, page_number
) VALUES (
  (SELECT operation_id FROM operation WHERE description LIKE 'Apply plant growth regulators (e.g., NAA or Ethrel)%' LIMIT 1),
  'New England Tree Fruit Management Guide', 'https://netreefruit.org/apples/chemical-fruit-thinning-and-other-plant-growth-regulator-uses/return-bloom-enhancement', NULL
);




-- OAR71 Operation Inserts (Fruit Set / First Cover)

-- Disease Management: Apple Scab and Rots
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR71' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Apply first cover fungicides for apple scab, bitter rot, black and white rots, cedar apple rust, fire blight, and powdery mildew.',
--  'Disease management', 'First cover fungicide');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Apply first cover fungicides for apple scab, bitter rot, black and white rots, cedar apple rust, fire blight, and powdery mildew.' LIMIT 1),
--  'New Jersey Commercial Tree Fruit Production Guide', 'https://njaes.rutgers.edu/pubs/publication.php?pid=E002', 'pp. 267-268');

-- -- Insect Management: Codling moth and San Jose scale
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR71' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Apply control measures for codling moth and San Jose scale crawlers 7–14 days after petal fall.',
--  'IPDM', 'Codling moth and scale');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Apply control measures for codling moth and San Jose scale crawlers 7–14 days after petal fall.' LIMIT 1),
--  'Midwest Apple Pest Management Guide', 'https://ag.purdue.edu/department/hla/extension/_docs/id-465.pdf', 'p. 34');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Apply control measures for codling moth and San Jose scale crawlers 7–14 days after petal fall.' LIMIT 1),
--  'Integrated Orchard Management Guide for Commercial Apples in the Southeast', 'https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast', 'pp. 23-24');


-- -- Insect Management: Leafhoppers and Aphids
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR71' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Manage potato leafhopper, leafminers, and aphids during early fruit development.',
--  'IPDM', 'Leafhopper and aphid control');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Manage potato leafhopper, leafminers, and aphids during early fruit development.' LIMIT 1),
--  'Midwest Apple Pest Management Guide', 'https://ag.purdue.edu/department/hla/extension/_docs/id-465.pdf', 'p. 35');

-- -- Broad Insect & Disease Coverage (Australia)
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR71' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Apply sprays for codling moth, lightbrown apple moth, red mite, two-spotted mite, and bitter rot during fruit set.',
--  'IPDM', 'Broad pest control (AUS)');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Apply sprays for codling moth, lightbrown apple moth, red mite, two-spotted mite, and bitter rot during fruit set.' LIMIT 1),
--  'Integrated Pest Management for Australian apples & pears', 'https://www.dpi.nsw.gov.au/agriculture/horticulture/pomes/pests-etc/ipm-apples-pears', 'pp. 187-190');


-- OAR72 Operation Inserts

-- Insect Management: Aphids, Codling Moth, and Other Insects
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR72' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Manage aphids, codling moth, sawfly, tentiform leafminer, plum curculio, oriental fruit moth, and leafhoppers during second cover spray stage.',
--  'IPDM', 'Second cover insect pests');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Manage aphids, codling moth, sawfly, tentiform leafminer, plum curculio, oriental fruit moth, and leafhoppers during second cover spray stage.' LIMIT 1),
--  'New Jersey Commercial Tree Fruit Production Guide', 'https://njaes.rutgers.edu/pubs/publication.php?pid=E002', 'pp. 269-271');

-- -- Disease Management: Apple Scab and Rots
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR72' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Apply fungicides to control apple scab, bitter rot, and black and white rots during second cover.',
--  'Disease management', 'Scab and rot control');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Apply fungicides to control apple scab, bitter rot, and black and white rots during second cover.' LIMIT 1),
-- 'New Jersey Commercial Tree Fruit Production Guide', 'https://njaes.rutgers.edu/pubs/publication.php?pid=E002', 'pp. 272-273');

-- -- Fertilization Strategy
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR72' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Apply calcium nitrate and calcium chloride fertilizers using a split application strategy.',
--  'Nutrient management', 'Fertilizer split');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Apply calcium nitrate and calcium chloride fertilizers using a split application strategy.' LIMIT 1),
--  'Integrated Orchard Management Guide for Commercial Apples in the Southeast', 'https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast', 'p. 24');

-- -- Canopy and Vegetative Growth Management
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR72' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Manage canopy and vegetative growth by leader bending, canopy control, and pruning.',
--  'Pruning & Training', 'Canopy and vegetative control');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Manage canopy and vegetative growth by leader bending, canopy control, and pruning.' LIMIT 1),
--  'Integrated Orchard Management Guide for Commercial Apples in the Southeast', 'https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast', 'p. 24');

-- -- Return Bloom and Sucker Control
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR72' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Enhance return bloom using NAA or Ethrel; control suckers using Tre-Hold A-112 or herbicide.',
--  'Plant growth regulator', 'Bloom enhancement and sucker control');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Enhance return bloom using NAA or Ethrel; control suckers using Tre-Hold A-112 or herbicide.' LIMIT 1),
--  'Integrated Orchard Management Guide for Commercial Apples in the Southeast', 'https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast' 'p.25');

-- OAR7 Operation Inserts (Third to Seventh Cover)


-- IPDM: Aphids and Fruit Borers
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR73' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Control green apple aphid, woolly apple aphid, codling moth, sawfly, leafroller, plum curculio, and tentiform leafminer.',
--  'IPDM', 'Third to seventh cover pests');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Control green apple aphid, woolly apple aphid, codling moth, sawfly, leafroller, plum curculio, and tentiform leafminer.' LIMIT 1),
--  'New Jersey Commercial Tree Fruit Production Guide', 'https://njaes.rutgers.edu/pubs/publication.php?pid=E002', 'THIRD AND FOURTH COVERS :AppleScab,BitterRot,Black andWhite Rots(Sooty Blotch and Flyspeck (p. 272-274); THIRD THROUGH SEVENTH COVERS:Green Apple Aphid WoollyApple
--  Aphid, CodlingMoth,EuropeanApple Sawfly, Leaf-roller,OrientalFruitMoth, PlumCurculio,SpottedTentiform Leafminer,Tarnished Plant Bug,WhiteApple,Leafhoppe (p.276-278)');

--  INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Control green apple aphid, woolly apple aphid, codling moth, sawfly, leafroller, plum curculio, and tentiform leafminer.' LIMIT 1),
--  'Midwest Apple Pest Management Guide', 'https://ag.purdue.edu/department/hla/extension/_docs/id-465.pdf', 'Apple maggot flies, Codling moth, Japanese beetles, Brown marmorated stink bug (BMSB), San Jose scale crawlers (p.37-40)');

-- -- Disease Management: Late-Season Fungicide Sprays
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR73' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Apply sprays for scab (spray 8), powdery mildew, bitter rot (sprays 4–5), and sooty blotch and flyspeck during late fruit development.',
--  'IPDM', 'Late cover');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Apply sprays for scab (spray 8), powdery mildew, bitter rot (sprays 4–5), and sooty blotch and flyspeck during late fruit development.' LIMIT 1),
--  'Integrated Pest Management for Australian apples & pears', 'https://www.dpi.nsw.gov.au/agriculture/horticulture/pomes/pests-etc/ipm-apples-pears', 'Apple Scab (spray 8) (p.189), Powdery mildew (p.189), Bitter rot (spray 4-5) (p.189-190), Sooty blotch and fly speck (p.192), Codling moth (4th spray onwards) (p.189-190), San José scale (p.188), Woolly aphid (p.190), Wingless grasshopper (p.190), Apple leafhopper (p.190), Queensland fruit fly (p.191), Lightbrown apple moth (late season) (p.191)');


-- -- IPDM: Summer Insect and Mite Pests
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR73' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Manage apple maggot flies, Japanese beetles, BMSB, San Jose scale, woolly aphid, wingless grasshopper, apple leafhopper, and QFly during summer fruit development.',
--  'IPDM', 'Summer insect complex');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Manage apple maggot flies, Japanese beetles, BMSB, San Jose scale, woolly aphid, wingless grasshopper, apple leafhopper, and QFly during summer fruit development.' LIMIT 1),
--   'Integrated Pest Management for Australian apples & pears', 'https://www.dpi.nsw.gov.au/agriculture/horticulture/pomes/pests-etc/ipm-apples-pears', 'Apple Scab (spray 8) (p.189), Powdery mildew (p.189), Bitter rot (spray 4-5) (p.189-190), Sooty blotch and fly speck (p.192), Codling moth (4th spray onwards) (p.189-190), San José scale (p.188), Woolly aphid (p.190), Wingless grasshopper (p.190), Apple leafhopper (p.190), Queensland fruit fly (p.191), Lightbrown apple moth (late season) (p.191)');

-- -- OAR82 Operation Inserts (Harvest and Post-Harvest)

-- -- Disease Management: Preharvest and Postharvest Rot Control
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR82' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Apply fungicide treatments to manage preharvest and postharvest diseases including apple scab, bitter rot, and sooty blotch.',
--  'Disease management', 'Preharvest & postharvest management');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Apply fungicide treatments to manage preharvest and postharvest diseases including apple scab, bitter rot, and sooty blotch.' LIMIT 1),
--  'Oregon Apple Pest and Frost Management Guide', 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 56');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Apply fungicide treatments to manage preharvest and postharvest diseases including apple scab, bitter rot, and sooty blotch.' LIMIT 1),
--  'Washington Apple Orchard Systems Hub', 'https://cpg.treefruit.wsu.edu/apple-programs/overview/%23delayed_dormant', NULL);

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Apply fungicide treatments to manage preharvest and postharvest diseases including apple scab, bitter rot, and sooty blotch.' LIMIT 1),
--  'Orchard plant protection guide for deciduous fruits in NSW', 'https://www.dpi.nsw.gov.au/agriculture/horticulture/pests-diseases-hort/information-for-multiple-crops/orchard-plant-protection-guide', 'San José scale (p.79)');




-- -- Disease Management: Late-Season and Leaf Fall
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR82' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Apply postharvest urea treatment for scab suppression and manage woolly aphids with chlorpyrifos or endosulfan.',
--  'Disease management', 'Leaf fall and pest');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Apply postharvest urea treatment for scab suppression and manage woolly aphids with chlorpyrifos or endosulfan.' LIMIT 1),
--  '2020-21 Australian apple and pear IPDM manual', 'https://www.horticulture.com.au/growers/help-your-business-grow/research-reports-publications-fact-sheets-and-more/grower-resources/ap16007-assets/2020-21-australian-apple-and-pear-ipdm-manual/', 'QFly (p.206), Medfly (p.206), Apple scab (p.158), Alternaria (p.130)');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Apply postharvest urea treatment for scab suppression and manage woolly aphids with chlorpyrifos or endosulfan.' LIMIT 1),
--  'Integrated Pest Management for Australian apples & pears', 'https://www.horticulture.com.au/growers/help-your-business-grow/research-reports-publications-fact-sheets-and-more/grower-resources/ap16007-assets/2020-21-australian-apple-and-pear-ipdm-manual/', 'Woolly aphid, postharvest chlorpyrifos or endosulfan (p.192)');


-- -- Disease Management: Alternaria and Sooty Blotch
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR82' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Manage Alternaria and sooty blotch with appropriate late-season fungicides in postharvest period.',
--  'Disease management', 'Alternaria and blotch');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Manage Alternaria and sooty blotch with appropriate late-season fungicides in postharvest period.' LIMIT 1),
--  'Orchard plant protection guide for deciduous fruits in NSW', 'https://www.dpi.nsw.gov.au/agriculture/horticulture/pests-diseases-hort/information-for-multiple-crops/orchard-plant-protection-guide', NULL);

-- -- Harvest Management: Fruit Drop and Readiness
-- INSERT INTO operation (
--   stage_id, reference_id, description, section, subsection
-- ) VALUES
-- ((SELECT stage_id FROM stage WHERE stage_code = 'OAR82' LIMIT 1),
--  (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
--  'Apply harvest drop control and use maturity testing methods to optimize harvest timing.',
--  'Harvest management', 'Fruit Drop control');

-- INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Apply harvest drop control %' LIMIT 1),
--  'New England Tree Fruit Management Guide', 'https://netreefruit.org/apples/chemical-fruit-thinning-and-other-plant-growth-regulator-uses/harvest-management-and', NULL);
--  INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
-- ((SELECT operation_id FROM operation WHERE description = 'Apply harvest drop control %' LIMIT 1),
--  'Washington Apple Orchard Systems Hub', 'https://treefruit.wsu.edu/orchard-management/harvest/', NULL);





-- OAR43 Entries --

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR43' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply protectant fungicides to prevent primary scab infections at tight cluster.',
 'Disease management', 'Apple scab');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply protectant fungicides to prevent primary scab infections at tigh%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 42');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR43' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply systemic fungicides to suppress early mildew establishment.',
 'Disease management', 'Powdery mildew');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply systemic fungicides to suppress early mildew establishment.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 42');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR43' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Initiate preventative sprays and prune any holdover cankers if visible.',
 'Disease management', 'Fire blight');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Initiate preventative sprays and prune any holdover cankers if visible%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 42');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR43' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply early-season fungicide to suppress rust species such as cedar apple rust.',
 'Disease management', 'Rust');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply early-season fungicide to suppress rust species such as cedar ap%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 43');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR43' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Begin fungicide program to limit early leaf spot development.',
 'Disease management', 'Frogeye leaf spot');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Begin fungicide program to limit early leaf spot development.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 43');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR43' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Rotate fungicides to suppress spore release and shoot infection.',
 'Disease management', 'Black rot');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Rotate fungicides to suppress spore release and shoot infection.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 43');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR43' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply contact insecticides early to prevent leaf curling at tight cluster.',
 'IPDM', 'Rosy apple aphid');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply contact insecticides early to prevent leaf curling at tight clus%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 41');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR43' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply dormant oil spray to suppress overwintering mite eggs.',
 'IPDM', 'European red mite eggs');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply dormant oil spray to suppress overwintering mite eggs.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 41');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR43' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Use degree-day model to time treatment for overwintering generation.',
 'IPDM', 'Spotted tentiform leafminer');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Use degree-day model to time treatment for overwintering generation.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 41');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR43' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Start pheromone trap monitoring during tight cluster to track emergence.',
 'IPDM', 'Codling moth');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Start pheromone trap monitoring during tight cluster to track emergenc%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 13');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR43' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply early insecticide sprays to control larvae on leaf surfaces.',
 'IPDM', 'Redbanded leafroller');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply early insecticide sprays to control larvae on leaf surfaces.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 41');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR43' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Use trunk sprays or wraps to manage larvae during early season.',
 'IPDM', 'American plum borer');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Use trunk sprays or wraps to manage larvae during early season.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 41');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR43' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Scout burr knots and use protectants around tree base.',
 'IPDM', 'Dogwood borer');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Scout burr knots and use protectants around tree base.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 41');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR43' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Monitor trunk injuries and treat areas prone to infestation.',
 'IPDM', 'Roundheaded apple tree borer');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Monitor trunk injuries and treat areas prone to infestation.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 41');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR43' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Spray larvae as they emerge to prevent damage to developing buds.',
 'IPDM', 'Winter moth');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Spray larvae as they emerge to prevent damage to developing buds.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 41');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR43' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply dormant oil or insecticides at tight cluster stage to suppress crawlers.',
 'IPDM', 'San Jose scale');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply dormant oil or insecticides at tight cluster stage to suppress c%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 41');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR43' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Use crawler-stage insecticides in orchards with known history.',
 'IPDM', 'White Prunicola scale (WPS)');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Use crawler-stage insecticides in orchards with known history.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 41');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR43' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Scout for tarnished plant bugs and apply early treatments if threshold is reached.',
 'IPDM', 'Plant bugs');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Scout for tarnished plant bugs and apply early treatments if threshold%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 13');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR43' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Rotate FRAC groups to prevent resistance buildup during early season.',
 'Disease management', 'Fungicide rotation');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Rotate FRAC groups to prevent resistance buildup during early season.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 11');




 --OAR44
 



INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR44' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply fungicides for primary scab control.',
 'Disease management', 'Apple scab');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply fungicides for primary scab control.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 46');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR44' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Treat early to prevent infection of shoots and blossoms.',
 'Disease management', 'Powdery mildew');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Treat early to prevent infection of shoots and blossoms.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 46');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR44' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply protective fungicides before infection events.',
 'Disease management', 'Cedar apple rust');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply protective fungicides before infection events.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 46');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR44' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Manage rot complex with broad-spectrum fungicides.',
 'Disease management', 'Black rot, White rot, Bitter rot');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Manage rot complex with broad-spectrum fungicides.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 47');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR44' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Begin mating disruption or apply insecticides as needed.',
 'IPDM', 'Codling moth');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Begin mating disruption or apply insecticides as needed.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 45');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR44' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Monitor and treat at early signs of emergence.',
 'IPDM', 'Dogwood borer and other borers');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Monitor and treat at early signs of emergence.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 44');

-- (Due to message length limits, remaining INSERTS will continue in next message) --
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR44' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply insecticide to prevent leaf curl.',
 'IPDM', 'Rosy apple aphid');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply insecticide to prevent leaf curl.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 44');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR44' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Control overwintering generation during pink.',
 'IPDM', 'Spotted tentiform leafminer');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Control overwintering generation during pink.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 44');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR44' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Spray based on trap counts and thresholds.',
 'IPDM', 'European apple sawfly');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Spray based on trap counts and thresholds.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 44');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR44' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Suppress to avoid fruit deformation.',
 'IPDM', 'Tarnished plant bug, Mullein plant bug');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Suppress to avoid fruit deformation.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 44');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR44' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Target early larval activity with sprays.',
 'IPDM', 'Winter moth');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Target early larval activity with sprays.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 44');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR44' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Monitor and apply treatments if above threshold.',
 'IPDM', 'Oriental fruit moth');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Monitor and apply treatments if above threshold.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 44');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR44' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply miticides to control eggs and early nymphs.',
 'IPDM', 'European red mite');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply miticides to control eggs and early nymphs.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 44');

-- (Remaining INSERTS for OAR44 continue in next message) --
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR44' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Scout and manage early colonies at pink stage.',
 'IPDM', 'Woolly apple aphid');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Scout and manage early colonies at pink stage.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 44');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR44' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply control during pink to reduce fruit damage.',
 'IPDM', 'Apple dimpling bug');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply control during pink to reduce fruit damage.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 44');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR44' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Monitor and control to avoid scarring on young fruit.',
 'IPDM', 'Plague thrips');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Monitor and control to avoid scarring on young fruit.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 44');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR44' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Use targeted insecticides to manage WFT.',
 'IPDM', 'Western flower thrips (WFT)');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Use targeted insecticides to manage WFT.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 44');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR44' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply insecticides if thresholds exceeded.',
 'IPDM', 'Helicoverpa and loopers');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply insecticides if thresholds exceeded.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 44');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR44' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Monitor and manage at pink stage.',
 'IPDM', 'Lightbrown apple moth (LBAM)');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Monitor and manage at pink stage.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 44');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR44' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply nutrients based on spring tissue analysis to support bloom and early fruit development.',
 'Nutrient management', 'Pink stage nutrient application');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply nutrients based on spring tissue analysis to support bloom and early fruit development.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 23');


-- OAR50 EARLY THROUGH FULL BLOOM
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR50' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply insecticides during early through full bloom for control of leafrollers and thrips.',
 'IPDM', 'Insect and mite management');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply insecticides during early through full bloom for control of leafrollers and thrips.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 47');


 -- OAR55 
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR55' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply protectant fungicides during bloom to control primary scab infections.',
 'Disease management', 'Apple scab');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply protectant fungicides during bloom to control primary scab infec%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 48');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR55' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Treat to prevent infection of flowers and shoots.',
 'Disease management', 'Powdery mildew');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Treat to prevent infection of flowers and shoots.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 48');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR55' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Use systemic or protectant fungicides as needed.',
 'Disease management', 'Cedar apple rust');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Use systemic or protectant fungicides as needed.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 48');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR55' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply biologicals or antibiotics during high-risk bloom periods.',
 'Disease management', 'Fire blight');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply biologicals or antibiotics during high-risk bloom periods.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 48');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR55' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Manage blossom-end rot complex with broad-spectrum fungicides.',
 'Disease management', 'Black rot, White rot, Bitter rot');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Manage blossom-end rot complex with broad-spectrum fungicides.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 48');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR55' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Use products like LifeGard, Cueva, or Serenade as alternatives.',
 'Disease management', 'Organic options');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Use products like LifeGard, Cueva, or Serenade as alternatives.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 48');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR55' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Monitor trap catches and delay spray until post-bloom.',
 'IPDM', 'Codling moth');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Monitor trap catches and delay spray until post-bloom.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 48');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR55' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Delay insecticide application until after petal fall.',
 'IPDM', 'Oriental fruit moth');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Delay insecticide application until after petal fall.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 48');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR55' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Monitor for activity; avoid insecticide use during bloom.',
 'IPDM', 'Gypsy moth, Lesser appleworm, Obliquebanded leafroller');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Monitor for activity; avoid insecticide use during bloom.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 48');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR55' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Monitor with traps; no sprays should be used during full bloom to protect pollinators.',
 'IPDM', 'LBAM, WFM, Budworm, Helicoverpa, Apple dimpling bug');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Monitor with traps; no sprays should be used during full bloom to prot%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 48');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR55' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply during bloom to improve fruit shape, weight, and assist with frost recovery.',
 'Plant growth regulator', 'Promalin, Perlan');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply during bloom to improve fruit shape, weight, and assist with fro%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 13');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR55' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Conduct bag removal and leader selection as part of full bloom training.',
 'Pruning & Training', 'Cultural management');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Conduct bag removal and leader selection as part of full bloom trainin%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 12');

 -- OAR57
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR57' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Continue fungicide application to prevent secondary scab infections post-bloom.',
 'Disease management', 'Apple scab');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Continue fungicide application to prevent secondary scab infections po%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 50');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR57' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply protective fungicides to control secondary infection cycles.',
 'Disease management', 'Cedar apple rust');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply protective fungicides to control secondary infection cycles.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 50');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR57' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Treat to protect young leaves and shoots after petal fall.',
 'Disease management', 'Powdery mildew');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Treat to protect young leaves and shoots after petal fall.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 50');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR57' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply targeted fungicides if cultivar is susceptible or history of infection exists.',
 'Disease management', 'Alternaria leaf spot');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply targeted fungicides if cultivar is susceptible or history of inf%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 50');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR57' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Scout for aphid colonies on shoot tips and manage using insecticides or predators if needed.',
 'IPDM', 'Green apple aphid');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Scout for aphid colonies on shoot tips and manage using insecticides o%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 49');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR57' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply control measures as colonies establish on limbs or roots post bloom.',
 'IPDM', 'Woolly apple aphid');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply control measures as colonies establish on limbs or roots post bl%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 49');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR57' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Begin first spray at petal fall to control emerging larvae.',
 'IPDM', 'Codling moth');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Begin first spray at petal fall to control emerging larvae.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 49');

-- Additional 9 insect-related operations follow --
INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR57' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Target insecticide application before oviposition begins on fruitlets.',
 'IPDM', 'European apple sawfly');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Target insecticide application before oviposition begins on fruitlets.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 49');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR57' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply broad-spectrum or targeted insecticides depending on regional species.',
 'IPDM', 'Leafrollers');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply broad-spectrum or targeted insecticides depending on regional sp%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 49');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR57' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Initiate control based on degree-day models and trap captures post bloom.',
 'IPDM', 'Oriental fruit moth');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Initiate control based on degree-day models and trap captures post blo%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 49');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR57' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply insecticides to protect fruitlets immediately after petal fall.',
 'IPDM', 'Plum curculio');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply insecticides to protect fruitlets immediately after petal fall.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 49');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR57' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Treat based on mine density threshold or pheromone trap data.',
 'IPDM', 'Spotted tentiform leafminer');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Treat based on mine density threshold or pheromone trap data.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 49');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR57' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Continue scouting and treat if thresholds are exceeded.',
 'IPDM', 'Tarnished plant bug');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Continue scouting and treat if thresholds are exceeded.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 49');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR57' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Monitor nymphs and apply insecticide if needed to protect foliage.',
 'IPDM', 'White apple leafhopper');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Monitor nymphs and apply insecticide if needed to protect foliage.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 49');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR57' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Begin treatment post bloom to suppress early larval activity.',
 'IPDM', 'Helicoverpa and loopers');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Begin treatment post bloom to suppress early larval activity.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 49');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR57' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply first generation spray after bloom if present.',
 'IPDM', 'Lightbrown apple moth (LBAM)');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply first generation spray after bloom if present.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 49');


INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR57' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Supplement with nitrogen or potassium after bloom to support fruit development.',
 'Nutrient management', 'Summer thinning nutrient');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Supplement with nitrogen or potassium after bloom to support fruit dev%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 31');




 -- OAR59

 INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR59' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply boron to prevent cork spot symptoms during early postbloom period.',
 'Pruning & Training', 'Boron for cork spot');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply boron to prevent cork spot symptoms during early postbloom perio%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 15');




INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR59' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply calcium chloride to improve fruit quality and reduce physiological disorders.',
 'Nutrient management', 'Calcium chloride');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply calcium chloride to improve fruit quality and reduce physiologic%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 15');


INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR59' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply GA4+7 to reduce fruit russeting and improve skin finish.',
 'Plant growth regulator', 'GA4+7 for russet prevention');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply GA4+7 to reduce fruit russeting and improve skin finish.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 15');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR59' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply thinning agents during postbloom to adjust fruit load.',
 'Plant growth regulator', 'Chemical thinning');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply thinning agents during postbloom to adjust fruit load.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 15');


INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR59' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Use prohexadione-calcium to regulate vegetative growth and improve fruit quality.',
 'Plant growth regulator', 'Prohexadione-calcium');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Use prohexadione-calcium to regulate vegetative growth and improve fr%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 16');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR59' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply fungicides to control summer rots as conditions become favorable.',
 'Disease management', 'Bitter rot, White rot');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply fungicides to control summer rots as conditions become favorable%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 16');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR59' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Use protective fungicide programs to prevent lesion development on foliage.',
 'Disease management', 'Frogeye leaf spot');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Use protective fungicide programs to prevent lesion development on fol%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 16');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR59' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Target anthracnose control through effective fungicide rotation.',
 'Disease management', 'Colletotrichum');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Target anthracnose control through effective fungicide rotation.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 16');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR59' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Prune infected shoots and apply appropriate bactericides to manage shoot blight.',
 'Disease management', 'Fire blight shoot blight');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Prune infected shoots and apply appropriate bactericides to manage sho%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 18');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR59' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Rotate fungicide modes of action to delay resistance development.',
 'Disease management', 'Fungicide resistance');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Rotate fungicide modes of action to delay resistance development.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 17');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR59' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Scout and apply miticides or insecticides as necessary based on thresholds.',
 'IPDM', 'Mites, aphids, leafminer');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Scout and apply miticides or insecticides as necessary based on thresh%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 18');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR59' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Use miticide products strategically to control resistant mite populations.',
 'IPDM', 'Agri-Mek, Savey');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Use miticide products strategically to control resistant mite populati%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 18');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR59' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply plant defense activators to stimulate host resistance mechanisms.',
 'Disease management', 'LifeGard, Actigard');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply plant defense activators to stimulate host resistance mechanisms%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 18');


-- OAR71


INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR71' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply follow-up fungicide sprays to protect expanding fruit and leaves.',
 'Disease management', 'Apple scab');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply follow-up fungicide sprays to protect expanding fruit and leaves%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 52');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR71' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Treat young foliage and developing fruitlets to suppress mildew spread.',
 'Disease management', 'Powdery mildew');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Treat young foliage and developing fruitlets to suppress mildew spread%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 52');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR71' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Continue fungicide coverage, especially under warm and wet conditions.',
 'Disease management', 'Bitter rot');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Continue fungicide coverage, especially under warm and wet conditions.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 52');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR71' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Rotate fungicides for continued protection against trunk and fruit rots.',
 'Disease management', 'Black and white rots');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Rotate fungicides for continued protection against trunk and fruit rot%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 52');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR71' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply systemic fungicides as rust infection risk persists.',
 'Disease management', 'Cedar apple rust');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply systemic fungicides as rust infection risk persists.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 52');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR71' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Monitor shoot symptoms and apply bactericides or growth regulators as needed.',
 'Disease management', 'Fire blight');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Monitor shoot symptoms and apply bactericides or growth regulators as %' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 52');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR71' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Use protectant sprays if history or conditions support Alternaria outbreaks.',
 'Disease management', 'Alternaria');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Use protectant sprays if history or conditions support Alternaria outb%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 52');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR71' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply calcium nutrients to reduce incidence of physiological disorder.',
 'Disease management', 'Bitter pit');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply calcium nutrients to reduce incidence of physiological disorder.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 188');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR71' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply second spray targeting hatching larvae based on trap captures or degree-days.',
 'IPDM', 'Codling moth');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply second spray targeting hatching larvae based on trap captures or%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 51');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR71' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply insecticide during crawler stage for effective suppression.',
 'IPDM', 'San Jose scale');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply insecticide during crawler stage for effective suppression.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 51');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR71' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Scout for hopperburn symptoms and apply controls if needed.',
 'IPDM', 'Potato leafhopper');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Scout for hopperburn symptoms and apply controls if needed.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 51');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR71' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Treat based on mines per leaf or trap counts at early fruit set.',
 'IPDM', 'Leafminers');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Treat based on mines per leaf or trap counts at early fruit set.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 51');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR71' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Monitor colonies and apply insecticides if thresholds are exceeded.',
 'IPDM', 'Aphids');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Monitor colonies and apply insecticides if thresholds are exceeded.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 51');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR71' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply miticides to manage developing populations.',
 'IPDM', 'European red mite');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply miticides to manage developing populations.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 51');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR71' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Treat with specific miticides if population builds post bloom.',
 'IPDM', 'Two-spotted mite');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Treat with specific miticides if population builds post bloom.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 51');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR71' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply cover sprays if flight and egg-laying are active.',
 'IPDM', 'Lightbrown apple moth (LBAM)');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply cover sprays if flight and egg-laying are active.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 188');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR71' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Monitor and control WFT in fruit clusters if visible damage occurs.',
 'IPDM', 'Western flower thrips (WFT)');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Monitor and control WFT in fruit clusters if visible damage occurs.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 188');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR71' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Treat larvae post petal fall if chewing damage exceeds thresholds.',
 'IPDM', 'Budworm, Helicoverpa, Loopers');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Treat larvae post petal fall if chewing damage exceeds thresholds.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 220');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR71' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Begin fruit fly bait sprays if present in region.',
 'IPDM', 'Queensland fruit fly (QFly), Mediterranean fruit fly (Medfly)');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Begin fruit fly bait sprays if present in region.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 206');


-- OAR72

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR72' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Continue fungicide sprays to protect expanding fruit from secondary infections.',
 'Disease management', 'Apple scab');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Continue fungicide sprays to protect expanding fruit from secondary in%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 272');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR72' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply fungicides to protect fruit during warm, humid periods.',
 'Disease management', 'Bitter rot');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply fungicides to protect fruit during warm, humid periods.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 272');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR72' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Maintain broad-spectrum fungicide rotation during fruitlet growth.',
 'Disease management', 'Black and white rots');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Maintain broad-spectrum fungicide rotation during fruitlet growth.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 273');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR72' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Scout and treat aphid colonies before leaf curling affects photosynthesis.',
 'IPDM', 'Green apple aphid');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Scout and treat aphid colonies before leaf curling affects photosynthe%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 269');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR72' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply systemic insecticides or biological controls for early colony suppression.',
 'IPDM', 'Woolly apple aphid');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply systemic insecticides or biological controls for early colony su%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 269');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR72' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply second or third spray as needed based on degree-day model.',
 'IPDM', 'Codling moth');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply second or third spray as needed based on degree-day model.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 269');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR72' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Monitor for larval injury in fruitlets and apply control if damage observed.',
 'IPDM', 'European apple sawfly');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Monitor for larval injury in fruitlets and apply control if damage obs%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 269');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR72' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Treat based on infestation level and host sensitivity during cover sprays.',
 'IPDM', 'Leafrollers');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Treat based on infestation level and host sensitivity during cover spr%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 269');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR72' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply insecticide during second generation if trap captures exceed thresholds.',
 'IPDM', 'Oriental fruit moth');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply insecticide during second generation if trap captures exceed thr%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 270');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR72' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Treat for plum curculio if recent rainfall and egg-laying activity is evident.',
 'IPDM', 'Plum curculio');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Treat for plum curculio if recent rainfall and egg-laying activity is %' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 270');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR72' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Monitor leaf mines and consider selective treatments during second cover.',
 'IPDM', 'Spotted tentiform leafminer');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Monitor leaf mines and consider selective treatments during second cov%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 270');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR72' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Continue scouting and apply insecticides if activity persists.',
 'IPDM', 'Tarnished plant bug');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Continue scouting and apply insecticides if activity persists.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 270');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR72' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply insecticide if leafhopper nymph populations are high.',
 'IPDM', 'White apple leafhopper');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply insecticide if leafhopper nymph populations are high.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 271');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR72' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply calcium nitrate to enhance fruit firmness and reduce bitter pit.',
 'Nutrient management', 'Calcium nitrate');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply calcium nitrate to enhance fruit firmness and reduce bitter pit.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 24');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR72' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Supplement calcium through foliar sprays to improve storage quality.',
 'Nutrient management', 'Calcium chloride');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Supplement calcium through foliar sprays to improve storage quality.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 24');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR72' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Divide fertilizer application to match nutrient demand phases.',
 'Nutrient management', 'Fertilizer split application');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Divide fertilizer application to match nutrient demand phases.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 24');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR72' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Remove water sprouts and train canopy for light penetration.',
 'Pruning & Training', 'Summer pruning and water sprout removal');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Remove water sprouts and train canopy for light penetration.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 24');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR72' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Bend leaders and manage shoots to balance vegetative and fruit growth.',
 'Pruning & Training', 'Leader bending, canopy control');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Bend leaders and manage shoots to balance vegetative and fruit growth.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 24');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR72' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply chemical thinners to optimize fruit number and size.',
 'Plant growth regulator', 'Thinning for crop load');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply chemical thinners to optimize fruit number and size.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 25');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR72' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply NAA or Ethrel to encourage flower bud formation for next season.',
 'Plant growth regulator', 'Return bloom enhancement');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply NAA or Ethrel to encourage flower bud formation for next season.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 25');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR72' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply products like Tre-Hold A-112 or herbicides to suppress suckers.',
 'Orchard floor management', 'Sucker control');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply products like Tre-Hold A-112 or herbicides to suppress suckers.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 25');


--OAR73


INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR73' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply late-season protectants to maintain coverage during rainy periods.',
 'Disease management', 'Apple scab');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply late-season protectants to maintain coverage during rainy period%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 272');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR73' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Continue treatments to prevent fruit surface infections late in season.',
 'Disease management', 'Powdery mildew');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Continue treatments to prevent fruit surface infections late in season%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 189');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR73' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply rot-specific fungicides during warm, wet conditions.',
 'Disease management', 'Bitter rot');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply rot-specific fungicides during warm, wet conditions.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 189');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR73' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Maintain fungicide rotation to prevent buildup of trunk rots.',
 'Disease management', 'Black and white rots');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Maintain fungicide rotation to prevent buildup of trunk rots.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 273');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR73' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply fungicides starting 270 degree days after petal fall.',
 'Disease management', 'Sooty blotch and flyspeck');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply fungicides starting 270 degree days after petal fall.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 274');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR73' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Scout colonies and treat with aphicides if pressure is high.',
 'IPDM', 'Green apple aphid');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Scout colonies and treat with aphicides if pressure is high.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 276');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR73' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply systemic insecticides if colonies expand during midsummer.',
 'IPDM', 'Woolly apple aphid');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply systemic insecticides if colonies expand during midsummer.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 276');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR73' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply fourth or subsequent sprays based on trap counts and models.',
 'IPDM', 'Codling moth');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply fourth or subsequent sprays based on trap counts and models.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 189');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR73' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Monitor for late larval signs and damage to fruit flesh.',
 'IPDM', 'European apple sawfly');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Monitor for late larval signs and damage to fruit flesh.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 276');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR73' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply cover sprays for summer generation larvae feeding on fruit.',
 'IPDM', 'Leafrollers');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply cover sprays for summer generation larvae feeding on fruit.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 276');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR73' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Treat if second or third generations exceed trap thresholds.',
 'IPDM', 'Oriental fruit moth');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Treat if second or third generations exceed trap thresholds.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 276');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR73' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Treat for summer activity in humid areas with history of pressure.',
 'IPDM', 'Plum curculio');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Treat for summer activity in humid areas with history of pressure.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 277');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR73' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Control summer generations based on trap thresholds.',
 'IPDM', 'Spotted tentiform leafminer');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Control summer generations based on trap thresholds.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 277');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR73' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply insecticides if populations are detected during midseason.',
 'IPDM', 'Tarnished plant bug');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply insecticides if populations are detected during midseason.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 277');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR73' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Treat if nymphs or adults exceed visual thresholds.',
 'IPDM', 'White apple leafhopper');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Treat if nymphs or adults exceed visual thresholds.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 278');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR73' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply insecticide upon first capture of adult maggots.',
 'IPDM', 'Apple maggot flies');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply insecticide upon first capture of adult maggots.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 37');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR73' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply foliar insecticides when beetles are active on fruit or foliage.',
 'IPDM', 'Japanese beetles');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply foliar insecticides when beetles are active on fruit or foliage.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 38');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR73' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Scout borders and apply controls for fruit-probing adults.',
 'IPDM', 'Brown marmorated stink bug (BMSB)');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Scout borders and apply controls for fruit-probing adults.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 39');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR73' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Treat crawler stage during summer for effective suppression.',
 'IPDM', 'San Jose scale');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Treat crawler stage during summer for effective suppression.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 188');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR73' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply spot treatment to orchard margins if populations are present.',
 'IPDM', 'Wingless grasshopper');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply spot treatment to orchard margins if populations are present.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 190');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR73' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Use systemic or contact sprays if nymphs are damaging foliage.',
 'IPDM', 'Apple leafhopper');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Use systemic or contact sprays if nymphs are damaging foliage.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 190');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR73' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Use baiting and trapping strategies for suppression.',
 'IPDM', 'Queensland fruit fly (QFly)');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Use baiting and trapping strategies for suppression.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 191');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR73' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Treat late-season generations if fruit damage risk increases.',
 'IPDM', 'Lightbrown apple moth (LBAM)');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Treat late-season generations if fruit damage risk increases.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 191');

-- OAR82 Entries --

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR82' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'Apply urea postharvest to reduce overwintering scab inoculum.',
 'Disease management', 'Apple scab (urea treatment)');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply urea postharvest to reduce overwintering scab inoculum.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 192');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR82' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'apply chlorpyrifos or endosulfan after harvest to manage root colonies.',
 'Disease management', 'Woolly aphid (postharvest)');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'Apply chlorpyrifos or endosulfan after harvest to manage root colonies%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 192');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR82' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'continue late-season protection or sanitation depending on pressure.',
 'Disease management', 'Apple scab');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'continue late-season protection or sanitation depending on pressure.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 56');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR82' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'apply postharvest sprays if high-pressure seasons or known carryover risk.',
 'Disease management', 'Alternaria');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'apply postharvest sprays if high-pressure seasons or known carryover r%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 56');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR82' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'control with final fungicide spray preharvest to prevent blemishes.',
 'Disease management', 'Sooty blotch');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'control with final fungicide spray preharvest to prevent blemishes.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 123');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR82' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'use baiting and mass-trapping strategies near harvest.',
 'IPDM', 'Queensland fruit fly (QFly)');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'use baiting and mass-trapping strategies near harvest.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 206');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR82' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'implement traps and cover sprays for fruit fly control near harvest.',
 'IPDM', 'Mediterranean fruit fly (Medfly)');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'implement traps and cover sprays for fruit fly control near harvest.%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 206');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR82' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'postharvest treatment to target overwintering scale and crawler suppression.',
 'IPDM', 'San José scale');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'postharvest treatment to target overwintering scale and crawler suppre%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 79');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR82' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'conduct starch index, firmness, and Brix testing to determine harvest timing.',
 'Harvest management', 'Fruit maturity testing');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'conduct starch index, firmness, and Brix testing to determine harvest %' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 56');

INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR82' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'apply fruit-retaining agents such as ReTain or Harvista to reduce drop.',
 'Harvest management', 'Pre-harvest drop control');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'apply fruit-retaining agents such as ReTain or Harvista to reduce drop%' LIMIT 1),
 'Oregon Apple Pest and Frost Management Guide',
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p. 56');


INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR82' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'maintain optimal temperature and humidity to preserve fruit freshness and extend shelf life.',
 'Post-harvest handling', 'Storage conditions');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'maintain optimal temperature and humidity to preserve fruit freshness and extend shelf life%' LIMIT 1),
 'Apples: Botany, Production, and Uses',
  'https://books.google.com.au/books/about/Apples.html?id=MmuBCwAAQBAJ&redir_esc=y', 'pp. 596-598');


INSERT INTO operation (
  stage_id, reference_id, description, section, subsection
) VALUES
((SELECT stage_id FROM stage WHERE stage_code = 'OAR82' LIMIT 1),
 (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
 'adjust oxygen and carbon dioxide levels to prolong storage duration and maintain quality.',
 'Post-harvest handling', 'Controlled atmosphere storage');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number) VALUES
((SELECT operation_id FROM operation WHERE description LIKE 'adjust oxygen and carbon dioxide levels to prolong storage duration and maintain quality%' LIMIT 1),
 'Apples: Botany, Production, and Uses',
  'https://books.google.com.au/books/about/Apples.html?id=MmuBCwAAQBAJ&redir_esc=y', 'pp. 592-614');


