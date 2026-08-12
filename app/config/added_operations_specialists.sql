-- ---------------------------------------------------------------------------
-- Pass 10: the specialist documents that close out the corpus.
--
--   Apple and pear nutrition, NSW DPI Primefact 85 (12 pp)
--   Intensive apple orchard systems, NSW DPI Primefact 815 (5 pp)
--   Avoiding spray drift from air-blast sprayers, NSW DPI Primefact 20/872 (8 pp)
--   Managing bird damage to fruit and other horticultural crops (278 pp)
--   Ozone as a postharvest tool (20 pp)
--
-- Each is narrow enough that its whole subject is the operation. NSW DPIRD pages
-- answer 403 to automated requests but are live in a browser, so their links are
-- used as published; the bird damage guide points at a reachable mirror of the
-- same 2007 Bureau of Rural Sciences publication.
-- ---------------------------------------------------------------------------

CREATE TEMP TABLE sp_new(stage_code TEXT, section TEXT, subsection TEXT, description TEXT, db TEXT, url TEXT, page TEXT);

INSERT INTO sp_new VALUES
-- Apple and pear nutrition, Primefact 85
('ODG02','Nutrient management','Essential elements','Work from the full list of essential elements, not just the ones being applied: carbon, hydrogen and oxygen come from air and water, the rest from the soil.','NSW Apple and Pear Nutrition (Primefact 85)','https://www.dpi.nsw.gov.au/agriculture/horticulture/pomes/apples','p. 1'),
('OAR11','Nutrient management','Deficiency diagnosis','Read the leaf and fruit symptoms together: yellow and red leaf colouring, small early-maturing fruit and excessive growth each point to a different imbalance.','NSW Apple and Pear Nutrition (Primefact 85)','https://www.dpi.nsw.gov.au/agriculture/horticulture/pomes/apples','p. 2'),

-- Intensive apple orchard systems, Primefact 815
('ODG00','Modify Landscape','Intensive system planning','Decide the planting density and row width before anything is ordered; on flat ground 3 m rows are workable, and the whole system follows from that choice.','NSW Intensive Apple Orchard Systems (Primefact 815)','https://www.dpi.nsw.gov.au/agriculture/horticulture/pomes/apples','p. 1'),
('ODG00','Modify Landscape','Site suitability for density','Check the site factors that decide whether an intensive system will pay before committing to it; the advantages assume the site can support the density.','NSW Intensive Apple Orchard Systems (Primefact 815)','https://www.dpi.nsw.gov.au/agriculture/horticulture/pomes/apples','p. 2'),

-- Avoiding spray drift, Primefact 20/872
('ODG02','IPDM','Sprayer type','Match the sprayer to the canopy: axial air-blast, multi-head wrap-around, recycling and tower sprayers each place the spray differently, and the choice shows up in both coverage and drift.','NSW Avoiding Spray Drift (Primefact 20/872)','https://www.dpi.nsw.gov.au/agriculture/horticulture/pomes/apples','p. 1'),
('ODG02','IPDM','Drift management','Set up the sprayer to keep the spray in the canopy: air output, pressure and travel speed all move drift as much as nozzle choice does.','NSW Avoiding Spray Drift (Primefact 20/872)','https://www.dpi.nsw.gov.au/agriculture/horticulture/pomes/apples','p. 2'),

-- Managing bird damage
('ODG02','Environmental stress management','Bird damage strategy','Manage birds strategically rather than reactively: combine techniques, and cooperate with neighbours, since birds move across boundaries.','Managing Bird Damage to Fruit and Horticultural Crops','https://library.sprep.org/sites/default/files/2021-05/managing-bird-damage-fruit-horticultural.pdf','p. 1'),
('OAR82','Environmental stress management','Bird damage at harvest','Expect bird pressure to peak as fruit colours and sugars rise, and have the deterrents in place before that point, not after damage appears.','Managing Bird Damage to Fruit and Horticultural Crops','https://library.sprep.org/sites/default/files/2021-05/managing-bird-damage-fruit-horticultural.pdf','p. 1'),

-- Ozone as a postharvest tool
('OAR82','Post-harvest handling','Ozone treatment','Consider ozone in the store to suppress fungi and moulds and to hold ethylene down, which slows the ripening it would otherwise drive.','Ozone as a Postharvest Tool','https://www.horticulture.com.au/Information-Hub','p. 8'),
('OAR82','Post-harvest handling','Ethylene management','Keep ethylene from building up in the room; it accelerates ripening and shortens the storage life of everything held with it.','Ozone as a Postharvest Tool','https://www.horticulture.com.au/Information-Hub','p. 10');

DELETE FROM guidereference WHERE operation_id IN (
    SELECT o.operation_id FROM operation o JOIN sp_new n ON n.description = o.description);
DELETE FROM operation o USING sp_new n WHERE n.description = o.description;

INSERT INTO operation (stage_id, reference_id, description, section, subsection, status)
SELECT s.stage_id,
       (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
       n.description, n.section, n.subsection, 'confirmed'
FROM sp_new n JOIN stage s ON s.stage_code = n.stage_code;

INSERT INTO guidereference (operation_id, third_party_database, link, page_number)
SELECT o.operation_id, n.db, n.url, n.page
FROM sp_new n
JOIN stage s ON s.stage_code = n.stage_code
JOIN operation o ON o.stage_id = s.stage_id AND o.description = n.description;

DROP TABLE sp_new;

DELETE FROM guidereference g
WHERE g.guidereference_id NOT IN (
    SELECT MIN(guidereference_id) FROM guidereference
    GROUP BY operation_id, third_party_database, link, COALESCE(page_number, ''));
