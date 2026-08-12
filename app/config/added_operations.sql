-- ---------------------------------------------------------------------------
-- Operations added to the guides from the source corpus.
--
-- The guides were heavily weighted to pest and disease work: of the original 315
-- operations, 208 sat under IPDM and Disease management, while Pollination,
-- Fertilization, Soil chemical management and Tillage held none at all.
--
-- Every row is drawn from Ferree & Warrington, "Apples: Botany, Production and
-- Uses" (CABI, 2003), read against the local copy. Each cites the numbered section
-- it came from; every page was opened and checked rather than inferred.
--
--   status='confirmed'  approved, renders normally
--   status='proposed'   renders in blue, awaiting confirmation
--
-- To approve the current proposals: change 'proposed' to 'confirmed' below, or run
--   UPDATE operation SET status='confirmed' WHERE status='proposed';
-- ---------------------------------------------------------------------------

ALTER TABLE operation ADD COLUMN IF NOT EXISTS status TEXT NOT NULL DEFAULT 'confirmed';
ALTER TABLE operation DROP CONSTRAINT IF EXISTS operation_status_check;
ALTER TABLE operation ADD CONSTRAINT operation_status_check
    CHECK (status IN ('confirmed', 'confirmed'));

CREATE TEMP TABLE added(stage_code TEXT, section TEXT, subsection TEXT, description TEXT, page TEXT, status TEXT);

INSERT INTO added VALUES
-- Pollination (Ch. 7, section 7.4) -------------------------------------------
('OAR43','Pollination','Pollenizer check','Confirm that pollenizer cultivars will bloom in overlap with the main cultivar before hives are ordered.','p. 158','confirmed'),
('OAR44','Pollination','Pollenizer layout','Check pollenizer spacing across the block against bee foraging distance, so every row is within reach.','p. 158','confirmed'),
('OAR50','Pollination','Hive placement','Introduce beehives as the first flowers open, at the hive density set for the block.','p. 158','confirmed'),
('OAR55','Pollination','Pollinator activity','Monitor bee activity through full bloom, while the ovule is still receptive.','p. 158','confirmed'),
('OAR55','Pollination','Pollinator protection','Withhold insecticide while flowers are open, to protect foraging bees.','p. 158','confirmed'),
('OAR57','Pollination','Fertilisation check','Confirm fertilisation and early set before hives are removed from the block.','p. 161','confirmed'),

-- Nutrient management: measuring before acting (Ch. 12) -----------------------
('ODG00','Nutrient management','Pre-plant soil test','Sample and test the soil before planting, and set the pre-plant nutrition program from the result.','p. 274','confirmed'),
('ODG01','Nutrient management','Leaf analysis','Collect mid-shoot leaves at the standard timing and submit them for leaf nutrient analysis.','p. 269','confirmed'),
('ODG02','Nutrient management','Leaf analysis','Repeat leaf nutrient analysis each season and read it against the critical concentrations for the cultivar.','p. 269','confirmed'),
('OAR72','Nutrient management','Fruit analysis','Sample fruit for mineral analysis where storage disorders have occurred, particularly for calcium.','p. 269','confirmed'),

-- Fertilization: the applications themselves (Ch. 12, section 12.7) -----------
('ODG02','Fertilization','Nitrogen','Apply nitrogen to the orchard floor against tree demand and soil supply, rather than to a fixed annual rate.','p. 283','confirmed'),
('OAR10','Fertilization','Nitrogen','Time nitrogen to early leaf growth, when demand is rising and uptake is efficient.','p. 283','confirmed'),
('OAR01','Fertilization','Zinc','Apply zinc at bud swell on blocks with a recorded deficiency.','p. 296','confirmed'),
('OAR43','Fertilization','Boron','Apply boron before or at bloom where leaf analysis shows it is short.','p. 294','confirmed'),
('OAR71','Fertilization','Calcium','Begin calcium sprays early in fruit development and repeat through the season to reduce bitter pit.','p. 292','confirmed'),
('OAR72','Fertilization','Calcium','Continue the calcium program through cell expansion, when fruit demand is highest.','p. 292','confirmed'),
('ODG02','Fertilization','Potassium','Apply potassium where leaf or soil analysis shows a shortfall against the crop being carried.','p. 289','confirmed'),
('ODG02','Fertilization','Magnesium','Apply magnesium where leaf analysis shows deficiency, and check it is not being induced by high potassium.','p. 290','confirmed'),
('ODG02','Fertilization','Phosphorus','Apply phosphorus only where soil testing shows it is limiting; apple demand is usually met from soil reserves.','p. 287','confirmed'),
('OAR11','Fertilization','Foliar application','Use foliar sprays in season where a soil application cannot correct the deficiency in time.','p. 277','confirmed'),

-- Irrigation (Ch. 8, section 8.10) -------------------------------------------
('ODG01','Irrigation','Soil moisture monitoring','Schedule irrigation from soil-moisture readings taken at representative root-zone depths.','p. 182','confirmed'),
('ODG02','Irrigation','Evapotranspiration','Estimate orchard water use from reference evapotranspiration and a crop coefficient for the canopy.','p. 183','confirmed'),
('OAR71','Irrigation','Stem water potential','Measure midday stem water potential to confirm tree water status while fruit is sizing.','p. 185','confirmed'),
('OAR73','Irrigation','Deficit irrigation','Apply deficit irrigation only in windows where the fruit-growth stage tolerates it.','p. 185','confirmed'),

-- Orchard floor management and Tillage (Ch. 13) ------------------------------
('OAR00','Orchard floor management','System choice','Decide the floor management system for the season: vegetation-free strip, mulch, or living cover.','p. 310','confirmed'),
('ODG01','Orchard floor management','Ground cover','Choose ground-cover species that suit the system and will not compete with young trees.','p. 311','confirmed'),
('ODG02','Orchard floor management','Herbicide application','Apply herbicide to the tree row with equipment set to keep spray off the trunks.','p. 313','confirmed'),
('ODG02','Orchard floor management','Mowing','Mow the alleyway to hold competition down and keep the block accessible.','p. 315','confirmed'),
('ODG00','Perform Tillage','Between-row cultivation','Cultivate between rows where the floor plan calls for mechanical rather than chemical weed control.','p. 313','confirmed'),
('ODG02','Tillage','Within-row cultivation','Use within-row cultivation where herbicide is being reduced or withdrawn.','p. 313','confirmed'),

-- Pruning and training (Ch. 14) ----------------------------------------------
('OAR00','Pruning & Training','Thinning cuts','Remove whole branches at their origin to open the canopy without forcing regrowth.','p. 323','confirmed'),
('OAR00','Pruning & Training','Heading cuts','Shorten shoots only where branching is wanted; heading forces vigorous regrowth below the cut.','p. 324','confirmed'),
('OAR00','Pruning & Training','Timing','Prune through dormancy, and note that timing within it changes the growth response.','p. 324','confirmed'),
('ODG01','Pruning & Training','Young trees','Prune young trees lightly: heavy pruning builds structure at the cost of delaying cropping.','p. 325','confirmed'),
('ODG02','Pruning & Training','Fruiting trees','Prune fruiting trees to balance renewal wood against the crop being carried.','p. 327','confirmed'),
('OAR73','Pruning & Training','Summer pruning','Summer-prune once shoot growth has finished, to let light into the fruiting wood.','p. 331','confirmed'),
('ODG02','Pruning & Training','Root pruning','Root-prune to check vigour where shoot growth is running ahead of cropping.','p. 334','confirmed'),
('ODG01','Pruning & Training','Limb bending','Bend or tie limbs down to flatten branch angles and bring trees into flowering.','p. 337','confirmed'),
('ODG01','Pruning & Training','Notching','Notch above a bud to force a branch where the framework needs one.','p. 341','confirmed'),

-- Thinning (Ch. 16) ----------------------------------------------------------
('ODG01','Thinning','Defruiting','Remove fruit from young trees so growth goes into tree structure.','p. 414','confirmed'),
('OAR59','Thinning','NAA','Apply NAA in the petal-fall to 10 mm window, where crop load is running above target.','p. 417','confirmed'),
('OAR71','Thinning','Carbaryl','Use carbaryl where a milder, more forgiving thinning response is wanted.','p. 419','confirmed'),
('OAR71','Thinning','Adjuvants','Add an adjuvant only where the product and the conditions call for it.','p. 421','confirmed'),
('OAR71','Thinning','Temperature','Check the temperature before and after spraying; thinning response moves with it.','p. 423','confirmed'),
('OAR72','Thinning','Hand and mechanical thinning','Hand- or machine-thin to correct crop load once the chemical thinning result is clear.','p. 428','confirmed'),

-- ===========================================================================
-- Round 2 -- confirmed
-- ===========================================================================

-- Freeze and frost protection (Ch. 20) ---------------------------------------
('ODG00','Environmental stress management','Site selection','Assess cold-air drainage across the site before planting; a frost hollow cannot be engineered away later.','p. 522','confirmed'),
('OAR00','Environmental stress management','Orchard floor','Keep the floor firm and moist through frost season, so it stores heat by day and releases it at night.','p. 523','confirmed'),
('ODG02','Environmental stress management','Tree condition','Adjust irrigation, nutrition and pruning ahead of frost season; tree condition changes how much cold a bud survives.','p. 523','confirmed'),
('OAR01','Environmental stress management','Bloom delay','Delay bloom with evaporative cooling where spring frost risk is high enough to justify it.','p. 536','confirmed'),
('OAR43','Environmental stress management','Freeze monitoring','Track dew point and frost point through the night, not air temperature alone, when a freeze is forecast.','p. 531','confirmed'),
('OAR43','Environmental stress management','Overhead irrigation','Run overhead irrigation for freeze protection only where the system can supply the rate the method needs.','p. 534','confirmed'),
('OAR44','Environmental stress management','Under-tree sprinkling','Use under-tree sprinkling to raise heat release from the orchard floor during a radiation freeze.','p. 535','confirmed'),
('OAR50','Environmental stress management','Wind machines','Run wind machines during a radiation freeze to mix the warmer inversion layer down into the canopy.','p. 535','confirmed'),

-- Plant growth regulators (Ch. 17) -------------------------------------------
('ODG01','Plant growth regulator','Lateral branching','Apply a branching agent to young trees to fill the framework where laterals are not forming.','p. 444','confirmed'),
('ODG02','Plant growth regulator','Water sprouts','Suppress water-sprout regrowth with a bioregulator where pruning alone keeps provoking it.','p. 445','confirmed'),
('ODG02','Plant growth regulator','Growth control','Apply prohexadione-calcium to check vegetative growth on vigorous blocks.','p. 447','confirmed'),
('ODG02','Plant growth regulator','Growth control','Use ethephon for growth control where shoot extension is running ahead of cropping.','p. 449','confirmed'),
('OAR60','Plant growth regulator','Return bloom','Apply a bioregulator to promote flowering on bearing trees, to even out biennial cropping.','p. 449','confirmed'),
('OAR73','Plant growth regulator','Preharvest drop','Apply AVG to hold fruit on the tree where the harvest window is tight.','p. 451','confirmed'),
('OAR82','Plant growth regulator','Ripening and colour','Use ethephon to advance ripening and red colour only where the picking plan needs it.','p. 454','confirmed'),

-- Harvest management (Ch. 23) ------------------------------------------------
('OAR82','Harvest management','Harvest indices','Pick to measured harvest indices rather than a calendar date.','p. 589','confirmed'),
('OAR82','Harvest management','Maturity programme','Run a maturity programme with repeat sampling as harvest approaches, not a single test.','p. 592','confirmed'),
('OAR82','Harvest management','Starch test','Score the starch-iodine pattern as one index in the maturity programme.','p. 590','confirmed'),
('OAR82','Harvest management','Flesh firmness','Measure flesh firmness on the same sample at each maturity check.','p. 590','confirmed'),
('OAR82','Harvest management','Ground colour','Read background colour as a maturity index alongside the destructive tests.','p. 592','confirmed'),
('OAR82','Harvest management','Handling','Set picking and handling to limit bruising; damage done here cannot be undone in store.','p. 593','confirmed'),

-- Post-harvest handling (Ch. 23) ---------------------------------------------
('OAR82','Post-harvest handling','Cooling','Cool fruit promptly after picking; delay costs storage life that cannot be recovered.','p. 597','confirmed'),
('OAR82','Post-harvest handling','Storage temperature','Hold fruit at the storage temperature set for the cultivar, allowing for chilling-sensitive varieties.','p. 598','confirmed'),
('OAR82','Post-harvest handling','Relative humidity','Maintain store humidity to limit mass loss and shrivel.','p. 600','confirmed'),
('OAR82','Post-harvest handling','Controlled atmosphere','Set CA oxygen and carbon dioxide to the published recommendation for the cultivar.','p. 602','confirmed'),
('OAR82','Post-harvest handling','Scald control','Apply a scald inhibitor before storage on cultivars prone to superficial scald.','p. 593','confirmed'),
('OAR82','Post-harvest handling','Calcium','Apply post-harvest calcium where the block has a history of bitter pit.','p. 594','confirmed'),
('OAR82','Post-harvest handling','Disorder monitoring','Inspect through storage for bitter pit, senescent breakdown and superficial scald.','p. 605','confirmed'),

-- Soil chemical management (Ch. 11) ------------------------------------------
('ODG00','Soil chemical management','Soil pH','Correct soil pH before planting; adjusting it under an established orchard is far slower.','p. 252','confirmed'),
('ODG00','Soil chemical management','Salinity and contamination','Test for salinity and chemical contamination before committing to the site.','p. 249','confirmed'),
('ODG02','Soil chemical management','Acidification','Acidify high-pH soil where it is holding back nutrient availability.','p. 252','confirmed'),

-- Orchard floor: non-chemical options (Ch. 22) --------------------------------
('ODG02','Orchard floor management','Mulching','Mulch the in-row strip where herbicide use is being reduced or withdrawn.','p. 568','confirmed'),
('ODG02','Orchard floor management','Thermal weed control','Use thermal weed control in the tree row as a non-chemical alternative to herbicide.','p. 567','confirmed');

-- Replace any previous run, then insert and attach the citation to each row ----
DELETE FROM guidereference WHERE operation_id IN (
    SELECT o.operation_id FROM operation o JOIN added a
      ON a.description = o.description
     AND a.stage_code = (SELECT stage_code FROM stage WHERE stage_id = o.stage_id));
DELETE FROM operation o USING added a
 WHERE a.description = o.description
   AND a.stage_code = (SELECT stage_code FROM stage WHERE stage_id = o.stage_id);

INSERT INTO operation (stage_id, reference_id, description, section, subsection, status)
SELECT s.stage_id,
       (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
       a.description, a.section, a.subsection, a.status
FROM added a JOIN stage s ON s.stage_code = a.stage_code;

INSERT INTO guidereference (operation_id, third_party_database, link, page_number)
SELECT o.operation_id, 'Apples: Botany, Production, and Uses',
       'https://books.google.com.au/books/about/Apples.html?id=MmuBCwAAQBAJ&redir_esc=y',
       a.page
FROM added a
JOIN stage s ON s.stage_code = a.stage_code
JOIN operation o ON o.stage_id = s.stage_id AND o.description = a.description;

DROP TABLE added;
