-- ---------------------------------------------------------------------------
-- Pass 2 of the corpus review: 2020-21 Australian Apple and Pear IPDM Manual.
--
-- Read cover to cover against the local copy. Chapter 2 ("Developing an IPDM
-- Plan", Steps 1-3, pp. 21-33) turned out to carry most of the orchard
-- establishment work the portal was missing; Chapter 2's Step 1 also covers the
-- equipment and monitoring preparation that had no home in the guides at all.
--
-- Two kinds of change:
--   1. Operations this manual describes that the portal did not have  -> new rows
--   2. Operations the portal already had that this manual also covers -> the
--      manual's page is added alongside the existing citation, so [Details]
--      shows both sources.
--
-- Printed page numbers equal PDF page numbers in this document (verified).
-- ---------------------------------------------------------------------------

-- 1. Operations this manual adds ---------------------------------------------

CREATE TEMP TABLE ipdm_new(stage_code TEXT, section TEXT, subsection TEXT, description TEXT, page TEXT);

INSERT INTO ipdm_new VALUES
-- Step 1: Prevention -- planning before the block goes in (pp. 21-25)
('ODG00','Modify Landscape','Block mapping','Map the existing block, or work from an aerial photograph, marking drainage problems, soil types, frost pockets, prevailing winds and the old tree rows, so new rows can be positioned away from them.','p. 22'),
('ODG00','Disease management','Replant testing','Test the site for apple replant syndrome, nematodes and other soil-borne problems before planting; a bioassay shows how much unamended soil will hold back young trees.','p. 22'),
('ODG00','Disease management','Nursery stock','Contract a reputable nursery for certified, pathogen-tested trees, and specify the tree type the training system needs rather than accepting what is available.','p. 23'),
('ODG00','Disease management','Tree inspection','Inspect trees on delivery against the contracted specification, reject any that fall short, and sort the rest by size and shape before planting.','p. 29'),

-- Step 2: Prepare land for planting (pp. 26-28)
('ODG00','Perform Tillage','Old tree removal','Remove the old orchard and its root systems when soil conditions allow; every pass that follows brings more old roots to the surface, and the more that come out the better.','p. 27'),
('ODG00','Modify Landscape','Erosion control','On steep sites leave the soil rough until final preparation, and install interceptor drains, grade furrows or contour banks to hold the surface.','p. 27'),
('ODG00','Modify Landscape','Mounding','Hill up the tree rows, keeping drainage lines clear so grassed waterways can carry surface water off the block.','p. 28'),
('ODG00','Orchard floor management','Cover crop','Cultivate the inter-row lightly and sow a cover crop, preferably in autumn, to stabilise the soil over winter and firm the surface for planting.','p. 28'),
('ODG00','Orchard floor management','Cover crop choice','Choose the cover crop against the pests expected in the block and the shelter it gives beneficial species; white clover, for example, can build western flower thrips that later move into the crop.','p. 28'),
('ODG00','Perform Tillage','Final cultivation','Leave the final cultivation of the planting row to the day of planting.','p. 28'),

-- Step 3: Planting and establishment (pp. 29-33)
('ODG00','Disease management','Crown gall','Inoculate the roots against crown gall before the trees go in the ground.','p. 29'),
('ODG00','Disease management','Tree storage','If trees cannot be planted on arrival, heel them into moist sawdust or sand, or hold them cool and covered; never let the root systems dry out.','p. 29'),
('ODG00','Apply Material to Adjust Soil Condition','Planting hole','Keep fertiliser out of the planting hole. Placed wrongly it burns young roots and can kill the tree; nitrogen is better applied on the surface after planting.','p. 30'),
('ODG00','Modify Landscape','Planting depth','Set planting depth and graft-union height against soil type and budding height, mounding shallow soils to give enough depth.','p. 30'),
('ODG01','Pruning & Training','Tree support','Install the support system soon after planting, particularly on dwarfing rootstocks: wind rocks the tops and breaks the new roots.','p. 31'),
('ODG01','Environmental stress management','Tree guards','Fit tree guards against rabbits, hares and wallabies and to shield green stems from herbicide, but inspect them for sheltering slugs and snails, and do not bury them.','p. 32'),

-- Step 1: preparing equipment and monitoring for the season (pp. 21, 25)
('ODG02','IPDM','Sprayer calibration','Calibrate sprayers before the season so the right volume lands on the target, and keep enough well-maintained capacity to cover the orchard within three to four days of rain for black spot and powdery mildew.','p. 25'),
('ODG02','IPDM','Trap maintenance','Service and clean insect traps before each season, and calibrate weather stations and sensors so the data driving decisions can be trusted.','p. 25'),
('ODG02','IPDM','Netting inspection','Inspect exclusion netting regularly and repair damage promptly, or pests enter and the investment is wasted.','p. 25'),
('ODG02','IPDM','Season review','Assess damage from the previous season, review monitoring results and model outputs to find the gaps, and plan the coming season against them.','p. 23'),
('ODG02','IPDM','Biological control','Decide before the season whether biological control agents need to be bought in to re-introduce or top up populations.','p. 23'),
('ODG02','Pruning & Training','Canopy openness','Favour training systems that leave an open canopy: better air flow and shorter drying times mean less disease and fewer soft-bodied sap-sucking pests.','p. 24'),
('ODG02','Pruning & Training','Pruning wounds','Minimise the number of pruning cuts where possible; each one is an entry point for silver leaf and other wound pathogens.','p. 24'),
('ODG02','Environmental stress management','Sunburn','Watch for sunburn when opening the canopy in warmer regions; bark cracking and splitting follows, and predisposes the tree to fungal infection.','p. 24'),
('ODG02','Thinning','Pest and disease','Thin with pest and disease in mind as well as crop load: clusters shelter insects and hold moisture against the fruit.','p. 24');

-- 2. This manual also covers operations the portal already had -----------------
--    Add its page beside the existing citation.

CREATE TEMP TABLE ipdm_also(stage_code TEXT, subsection TEXT, page TEXT);

INSERT INTO ipdm_also VALUES
('ODG00','Pre-plant soil test','p. 22'),
('ODG00','Salinity and contamination','p. 22'),
('ODG00','Soil pH','p. 22'),
('ODG00','Subsoil','p. 27'),
('ODG00','Ploughing','p. 27'),
('ODG00','Contouring','p. 27'),
('ODG00','Pre-plant irrigation system setup','p. 31'),
('ODG00','Fumigate','p. 22'),
('ODG01','Weed control','p. 32'),
('ODG01','Defruiting','p. 33'),
('ODG01','Fruit load management','p. 33'),
('ODG01','Extreme weather and animal protection','p. 33'),
('ODG01','Fertilization','p. 24');

-- 3. Small wording improvements this manual supports ---------------------------

UPDATE operation SET description =
  'Sample and test the soil before planting for pH, nutrients, salinity, organic matter and soil biology, and test subsoils for acidity and sodicity where those are a local problem; set the pre-plant nutrition program from the result.'
WHERE subsection = 'Pre-plant soil test';

UPDATE operation SET description =
  'Rip the site in late summer while the soil is dry enough to shatter, to break hard pans, improve aeration and root penetration, and bring old roots to the surface. Perform subsoiling parallel and perpendicular to the tree rows.'
WHERE subsection = 'Subsoil';

-- Apply -----------------------------------------------------------------------

DELETE FROM guidereference WHERE operation_id IN (
    SELECT o.operation_id FROM operation o JOIN ipdm_new n ON n.description = o.description);
DELETE FROM operation o USING ipdm_new n WHERE n.description = o.description;

INSERT INTO operation (stage_id, reference_id, description, section, subsection, status)
SELECT s.stage_id,
       (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
       n.description, n.section, n.subsection, 'confirmed'
FROM ipdm_new n JOIN stage s ON s.stage_code = n.stage_code;

INSERT INTO guidereference (operation_id, third_party_database, link, page_number)
SELECT o.operation_id, '2020-21 IPDM Australia',
       'https://www.horticulture.com.au/growers/help-your-business-grow/research-reports-publications-fact-sheets-and-more/grower-resources/ap16007-assets/2020-21-australian-apple-and-pear-ipdm-manual/',
       n.page
FROM ipdm_new n
JOIN stage s ON s.stage_code = n.stage_code
JOIN operation o ON o.stage_id = s.stage_id AND o.description = n.description;

-- second source on an operation the portal already had
INSERT INTO guidereference (operation_id, third_party_database, link, page_number)
SELECT o.operation_id, '2020-21 IPDM Australia',
       'https://www.horticulture.com.au/growers/help-your-business-grow/research-reports-publications-fact-sheets-and-more/grower-resources/ap16007-assets/2020-21-australian-apple-and-pear-ipdm-manual/',
       a.page
FROM ipdm_also a
JOIN stage s ON s.stage_code = a.stage_code
JOIN operation o ON o.stage_id = s.stage_id AND o.subsection = a.subsection
WHERE NOT EXISTS (
    SELECT 1 FROM guidereference g
    WHERE g.operation_id = o.operation_id AND g.third_party_database = '2020-21 IPDM Australia');

DROP TABLE ipdm_new;
DROP TABLE ipdm_also;

-- ---------------------------------------------------------------------------
-- Housekeeping: the seed data carried a few citations twice, so [Details] listed
-- the same guide and page repeatedly. Keep the first of each identical set.
-- ---------------------------------------------------------------------------
DELETE FROM guidereference g
WHERE g.guidereference_id NOT IN (
    SELECT MIN(guidereference_id) FROM guidereference
    GROUP BY operation_id, third_party_database, link, COALESCE(page_number, ''));
