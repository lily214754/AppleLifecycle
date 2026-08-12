-- ---------------------------------------------------------------------------
-- Pass 11: management material found outside the pdf/ folder.
--
--   Greene, Precision Thinning and Crop Load Management (UMass, 38 slides)
--   CropLife Australia Insecticide Resistance Management Strategies 2025 (54 pp)
--   CropLife Australia Fungicide Resistance Management Strategies 2025 (71 pp)
--   ChemCert AQF3 Chemical Accreditation Resource Manual 2025 (212 pp)
--
-- The precision thinning deck is the most operationally specific material in the
-- whole corpus: it gives the actual method for setting crop load at dormant
-- pruning and for reading the three models growers use through the thinning
-- window. The portal had thinning products but not the decision process.
-- ---------------------------------------------------------------------------

CREATE TEMP TABLE f_new(stage_code TEXT, section TEXT, subsection TEXT, description TEXT, db TEXT, url TEXT, page TEXT);

INSERT INTO f_new VALUES
-- Precision thinning: setting crop load at dormant pruning
('OAR00','Thinning','Crop load target','Count the flower buds on five representative trees and take the mean, then prune to leave 1.5 to 2 times the buds needed for the target crop -- never to the exact target, since frost, poor pollination and poor flower quality will each take a share.','Precision Thinning and Crop Load Management (Greene, UMass)','https://www.umass.edu/agriculture-food-environment/fruit','p. 9'),
('OAR00','Thinning','Post-pruning bud count','Count the buds left after pruning as an early check that the block is actually tracking towards its crop load goal, rather than assuming the cuts achieved it.','Precision Thinning and Crop Load Management (Greene, UMass)','https://www.umass.edu/agriculture-food-environment/fruit','p. 10'),
('OAR00','Pruning & Training','Precision pruning method','Reduce flower bud numbers by removing one to three whole limbs and the secondary laterals on those remaining, rather than shortening everything.','Precision Thinning and Crop Load Management (Greene, UMass)','https://www.umass.edu/agriculture-food-environment/fruit','p. 12'),

-- Precision thinning: the models through the thinning window
('OAR55','Thinning','Pollen tube growth model','Time caustic bloom thinners from the pollen tube growth model; it is what makes thinning at bloom predictable rather than a gamble.','Precision Thinning and Crop Load Management (Greene, UMass)','https://www.umass.edu/agriculture-food-environment/fruit','p. 14'),
('OAR71','Thinning','Six millimetre assessment','Wait until fruit reach 6 mm before judging the response to pruning, bloom and petal-fall thinning; initial set cannot be read reliably before then.','Precision Thinning and Crop Load Management (Greene, UMass)','https://www.umass.edu/agriculture-food-environment/fruit','p. 17'),
('OAR71','Thinning','Carbon balance model','Run the carbon balance model at 6 mm, when fruit enter log growth and carbohydrate demand peaks: the greater the deficit, the more easily the tree will thin. Treat it as a warning signal, not an instruction.','Precision Thinning and Crop Load Management (Greene, UMass)','https://www.umass.edu/agriculture-food-environment/fruit','p. 19'),
('OAR71','Thinning','Temperature governs response','Whatever the carbon balance indicates, temperature decides the outcome; check it before and after application rather than trusting the model alone.','Precision Thinning and Crop Load Management (Greene, UMass)','https://www.umass.edu/agriculture-food-environment/fruit','p. 34'),
('OAR71','Thinning','Fruit growth model','Measure fruitlet diameters and read the fruit growth model -- the only one that shows accurately whether a fruit will set or abscise. Around 15 spurs is enough to see the trend without running the full model.','Precision Thinning and Crop Load Management (Greene, UMass)','https://www.umass.edu/agriculture-food-environment/fruit','p. 35'),

-- CropLife resistance management strategies
('ODG02','IPDM','Mode of action rotation','Rotate insecticides and miticides between Mode of Action groups; it is alternation across MoA groups, not switching product names, that slows resistance.','CropLife Australia Insecticide Resistance Management Strategies','https://www.croplife.org.au/resources/programs/resistance-management/','p. 2'),
('ODG02','IPDM','Resistance mechanisms','Understand how resistance arises -- metabolic, target-site and penetration -- because it explains why part rates and repeated use of one group select for it so effectively.','CropLife Australia Insecticide Resistance Management Strategies','https://www.croplife.org.au/resources/programs/resistance-management/','p. 3'),
('ODG02','Disease management','Fungicide resistance strategy','Follow the published fungicide resistance strategy for each disease, and where products are tank-mixed or co-formulated apply the most stringent strategy that covers the pathogen most at risk.','CropLife Australia Fungicide Resistance Management Strategies','https://www.croplife.org.au/resources/programs/resistance-management/','p. 4'),
('ODG02','Disease management','Protected cropping resistance','Treat netting, tunnels and other protected structures as high resistance-risk: continuous infection pressure drives repeat applications at short intervals, which is exactly what selects for resistance.','CropLife Australia Fungicide Resistance Management Strategies','https://www.croplife.org.au/resources/programs/resistance-management/','p. 4'),

-- Chemical accreditation
('ODG02','IPDM','Chemical accreditation','Hold current chemical accreditation for anyone who purchases and applies pesticides without supervision; AQF Level 3 is the standard for that role in Australia.','ChemCert AQF3 Chemical Accreditation Resource Manual','https://chemcert.com.au/','p. 5');

DELETE FROM guidereference WHERE operation_id IN (
    SELECT o.operation_id FROM operation o JOIN f_new n ON n.description = o.description);
DELETE FROM operation o USING f_new n WHERE n.description = o.description;

INSERT INTO operation (stage_id, reference_id, description, section, subsection, status)
SELECT s.stage_id,
       (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
       n.description, n.section, n.subsection, 'confirmed'
FROM f_new n JOIN stage s ON s.stage_code = n.stage_code;

INSERT INTO guidereference (operation_id, third_party_database, link, page_number)
SELECT o.operation_id, n.db, n.url, n.page
FROM f_new n
JOIN stage s ON s.stage_code = n.stage_code
JOIN operation o ON o.stage_id = s.stage_id AND o.description = n.description;

DROP TABLE f_new;

DELETE FROM guidereference g
WHERE g.guidereference_id NOT IN (
    SELECT MIN(guidereference_id) FROM guidereference
    GROUP BY operation_id, third_party_database, link, COALESCE(page_number, ''));
