-- Operations sourced from peer-reviewed literature rather than extension guides.
--
-- Every other source in this database is an extension, government or industry guide.
-- These seventeen operations are the first drawn from journal papers, and they were
-- added because three areas had gaps that the grower guides do not cover: what to do
-- with a block at the end of its productive life, how netting and sunburn mitigation
-- actually perform, and what the pollination evidence says about relying on hives.
--
-- Each citation carries the article's own page range and its DOI as the link. All
-- eleven DOIs were resolved against the Crossref API, and the journal, volume, issue
-- and pages recorded below are Crossref's, not transcribed from the PDF.
--
-- Sources:
--   Winkelmann, T. et al. (2019) Apple Replant Disease: Causes and Mitigation
--     Strategies. Curr. Issues Mol. Biol. 30: 89-106.
--   Sharma, N.C. et al. (2020) Causes and Control Measures of Apple Replant Problem.
--     Int. J. Bio-resource and Stress Management 11(3): 246-257.
--   Tilston, E.L. et al. (2018) Candidate Causal Organisms for Apple Replant Disease
--     in the United Kingdom. Phytobiomes Journal 2(4): 261-274.
--   Leinfelder, M.M. & Merwin, I.A. (2006) Rootstock Selection, Preplant Soil
--     Treatments, and Tree Planting Positions as Factors in Managing Apple Replant
--     Disease. HortScience 41(2): 394-401.
--   Kanfra, X. et al. (2021) Alleviation of Nematode-Mediated Apple Replant Disease by
--     Pre-Cultivation of Tagetes. Horticulturae 7(11): 433.
--   Reig, G., Donahue, D.J. & Jentsch, P. (2020) The Efficacy of Four Sunburn
--     Mitigation Strategies. Int. J. Fruit Science 20(3): 541-561.
--   Bastias, R.M. & Boini, A. (2023) Apple Production under Protective Netting Systems.
--     In: Apple Cultivation - Recent Advances. IntechOpen.
--   Eeraerts, M. et al. (2025) Global synthesis of apple pollination research.
--     J. Applied Ecology 62(10): 2487-2501.
--   Tierney, S.M. et al. (2023) Bee pollination services and the burden of
--     biogeography. Proc. R. Soc. B 290(2000): 20230747.
--   Garratt, M.P.D. et al. (2016) Apple Pollination: Demand Depends on Variety and
--     Supply Depends on Pollinator Identity. PLoS ONE 11(5): e0153889.
--   Kawhena, T.G., Fawole, O.A. & Opara, U.L. (2021) Application of Dynamic Controlled
--     Atmosphere Technologies. Agriculture 11(6): 491.

CREATE OR REPLACE FUNCTION add_paper_op(p_stage TEXT, p_section TEXT, p_sub TEXT, p_desc TEXT)
RETURNS VOID AS $$
BEGIN
    INSERT INTO operation (stage_id, section, subsection, description, status)
    SELECT s.stage_id, p_section, p_sub, p_desc, 'confirmed'
      FROM stage s
     WHERE s.stage_code = p_stage
       AND NOT EXISTS (SELECT 1 FROM operation o WHERE o.description = p_desc);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_paper_cite(p_desc TEXT, p_src TEXT, p_link TEXT, p_page TEXT)
RETURNS VOID AS $$
BEGIN
    INSERT INTO guidereference (operation_id, third_party_database, link, page_number)
    SELECT o.operation_id, p_src, p_link, p_page
      FROM operation o
     WHERE o.description = p_desc
       AND NOT EXISTS (
           SELECT 1 FROM guidereference g
            WHERE g.operation_id = o.operation_id
              AND g.third_party_database = p_src
              AND g.link = p_link
              AND g.page_number IS NOT DISTINCT FROM p_page);
END;
$$ LANGUAGE plpgsql;

-- ===========================================================================
-- ODG03  End of Productive Life
-- The stage held 24 key measurements and no operations at all. The literature
-- frames this stage as the replant transition: deciding a block is finished, and
-- preparing the site for its successor.
-- ===========================================================================

SELECT add_paper_op('ODG03', 'Modify Landscape', 'Replant interval',
 'Plan block replacement on a shorter cycle than a traditional orchard. Dwarfing rootstocks at high planting density bring a block to the end of its economic life sooner, so replanting comes round more often.');
SELECT add_paper_cite('Plan block replacement on a shorter cycle than a traditional orchard. Dwarfing rootstocks at high planting density bring a block to the end of its economic life sooner, so replanting comes round more often.',
 'Winkelmann et al. 2019, Curr. Issues Mol. Biol.', 'https://doi.org/10.21775/cimb.030.089', 'pp. 89-106');

SELECT add_paper_op('ODG03', 'Disease management', 'Replant risk',
 'Assume the site is replant-affected and budget for it. Apple replant disease has been recorded on 25 to 70 per cent of replanted sites, and on affected soils it has been estimated to halve the profitability of the orchard that follows.');
SELECT add_paper_cite('Assume the site is replant-affected and budget for it. Apple replant disease has been recorded on 25 to 70 per cent of replanted sites, and on affected soils it has been estimated to halve the profitability of the orchard that follows.',
 'Sharma et al. 2020, Int. J. Bio-resource and Stress Management', 'https://doi.org/10.23910/1.2020.2090', 'pp. 246-257');
SELECT add_paper_cite('Assume the site is replant-affected and budget for it. Apple replant disease has been recorded on 25 to 70 per cent of replanted sites, and on affected soils it has been estimated to halve the profitability of the orchard that follows.',
 'Winkelmann et al. 2019, Curr. Issues Mol. Biol.', 'https://doi.org/10.21775/cimb.030.089', 'pp. 89-106');

SELECT add_paper_op('ODG03', 'Disease management', 'Replant site diagnosis',
 'Diagnose the individual site before choosing a treatment. The organisms associated with replant disease differ from site to site, so a programme that worked on a neighbouring block may not transfer to this one.');
SELECT add_paper_cite('Diagnose the individual site before choosing a treatment. The organisms associated with replant disease differ from site to site, so a programme that worked on a neighbouring block may not transfer to this one.',
 'Tilston et al. 2018, Phytobiomes Journal', 'https://doi.org/10.1094/PBIOMES-11-18-0050-R', 'pp. 261-274');

SELECT add_paper_op('ODG03', 'Disease management', 'Rootstock for the replant',
 'Choose a replant-tolerant rootstock. Over four years on a site cropped to apple for more than eighty years, rootstock was the single most important factor in overcoming replant disease, outweighing every preplant soil treatment tested.');
SELECT add_paper_cite('Choose a replant-tolerant rootstock. Over four years on a site cropped to apple for more than eighty years, rootstock was the single most important factor in overcoming replant disease, outweighing every preplant soil treatment tested.',
 'Leinfelder & Merwin 2006, HortScience', 'https://doi.org/10.21273/HORTSCI.41.2.394', 'pp. 394-401');

SELECT add_paper_op('ODG03', 'Modify Landscape', 'Row repositioning',
 'Set the new rows in the old grass lanes rather than on the old tree lines. Trees replanted off the previous row grew better, and the gain comes from separating new roots from old root-zone soil rather than from diluting it.');
SELECT add_paper_cite('Set the new rows in the old grass lanes rather than on the old tree lines. Trees replanted off the previous row grew better, and the gain comes from separating new roots from old root-zone soil rather than from diluting it.',
 'Leinfelder & Merwin 2006, HortScience', 'https://doi.org/10.21273/HORTSCI.41.2.394', 'pp. 394-401');
SELECT add_paper_cite('Set the new rows in the old grass lanes rather than on the old tree lines. Trees replanted off the previous row grew better, and the gain comes from separating new roots from old root-zone soil rather than from diluting it.',
 'Winkelmann et al. 2019, Curr. Issues Mol. Biol.', 'https://doi.org/10.21775/cimb.030.089', 'pp. 89-106');

SELECT add_paper_op('ODG03', 'Orchard floor management', 'Pre-crop before replanting',
 'Grow Tagetes on the site before replanting where nematodes are implicated. Apple planted after Tagetes gained significantly more shoot base diameter than apple planted after grass, through a shift in the soil nematode community.');
SELECT add_paper_cite('Grow Tagetes on the site before replanting where nematodes are implicated. Apple planted after Tagetes gained significantly more shoot base diameter than apple planted after grass, through a shift in the soil nematode community.',
 'Kanfra et al. 2021, Horticulturae', 'https://doi.org/10.3390/horticulturae7110433', '7(11): 433');

SELECT add_paper_op('ODG03', 'Disease management', 'Soil biology over disinfection',
 'Build soil microbial and faunal diversity rather than relying on disinfection. Fumigants are being withdrawn in many countries, steam disinfection costs three to four times as much as chemical treatment, and preplant fumigation and compost gave little benefit over four years in trial.');
SELECT add_paper_cite('Build soil microbial and faunal diversity rather than relying on disinfection. Fumigants are being withdrawn in many countries, steam disinfection costs three to four times as much as chemical treatment, and preplant fumigation and compost gave little benefit over four years in trial.',
 'Winkelmann et al. 2019, Curr. Issues Mol. Biol.', 'https://doi.org/10.21775/cimb.030.089', 'pp. 89-106');
SELECT add_paper_cite('Build soil microbial and faunal diversity rather than relying on disinfection. Fumigants are being withdrawn in many countries, steam disinfection costs three to four times as much as chemical treatment, and preplant fumigation and compost gave little benefit over four years in trial.',
 'Leinfelder & Merwin 2006, HortScience', 'https://doi.org/10.21273/HORTSCI.41.2.394', 'pp. 394-401');

-- ===========================================================================
-- Climate control and netting
-- ===========================================================================

SELECT add_paper_op('ODG02', 'Environmental stress management', 'Sunburn losses',
 'Treat sunburn as a primary economic loss rather than a cosmetic one. Reported losses of apple fruit to sunburn range from 10 per cent to as much as 50 per cent of the crop.');
SELECT add_paper_cite('Treat sunburn as a primary economic loss rather than a cosmetic one. Reported losses of apple fruit to sunburn range from 10 per cent to as much as 50 per cent of the crop.',
 'Reig et al. 2020, Int. J. Fruit Science', 'https://doi.org/10.1080/15538362.2019.1605558', 'pp. 541-561');

SELECT add_paper_op('ODG02', 'Environmental stress management', 'Sunburn mitigation ranking',
 'Rank sunburn mitigation by measured efficacy. Across two seasons netting gave the greatest reduction in sunburn damage, followed by sunscreen sprays and then particle films, and none of the treatments affected yield or fruit quality.');
SELECT add_paper_cite('Rank sunburn mitigation by measured efficacy. Across two seasons netting gave the greatest reduction in sunburn damage, followed by sunscreen sprays and then particle films, and none of the treatments affected yield or fruit quality.',
 'Reig et al. 2020, Int. J. Fruit Science', 'https://doi.org/10.1080/15538362.2019.1605558', 'pp. 541-561');

SELECT add_paper_op('ODG02', 'Environmental stress management', 'Sunburn mitigation economics',
 'Expect sunburn mitigation to protect fruit without necessarily paying for itself. Differences between mitigation treatments did not translate into higher net returns to the grower.');
SELECT add_paper_cite('Expect sunburn mitigation to protect fruit without necessarily paying for itself. Differences between mitigation treatments did not translate into higher net returns to the grower.',
 'Reig et al. 2020, Int. J. Fruit Science', 'https://doi.org/10.1080/15538362.2019.1605558', 'pp. 541-561');

SELECT add_paper_op('ODG02', 'Environmental stress management', 'Net choice as microclimate',
 'Choose net specification as a microclimate decision, not only a hail decision. Nets cut incoming solar radiation and wind speed and alter the orchard heat balance, which can improve leaf gas exchange and water relations where radiation and temperature are extreme, provided the shading does not cost yield or quality.');
SELECT add_paper_cite('Choose net specification as a microclimate decision, not only a hail decision. Nets cut incoming solar radiation and wind speed and alter the orchard heat balance, which can improve leaf gas exchange and water relations where radiation and temperature are extreme, provided the shading does not cost yield or quality.',
 'Bastias & Boini 2023, Apple Cultivation - Recent Advances', 'https://doi.org/10.5772/intechopen.109429', 'Ch. 4');

SELECT add_paper_op('OAR73', 'Environmental stress management', 'Evaporative cooling for heat',
 'Use evaporative cooling against summer heat and sunburn, separately from its use before bloom for frost protection and bloom delay.');
SELECT add_paper_cite('Use evaporative cooling against summer heat and sunburn, separately from its use before bloom for frost protection and bloom delay.',
 'Reig et al. 2020, Int. J. Fruit Science', 'https://doi.org/10.1080/15538362.2019.1605558', 'pp. 541-561');

-- ===========================================================================
-- Pollination
-- ===========================================================================

SELECT add_paper_op('OAR50', 'Pollination', 'Pollen limitation',
 'Manage pollination as an active constraint on yield rather than assuming it is adequate. A meta-analysis of field studies across 532 orchard replicates found strong evidence of pollen limitation for both fruit set and seed set.');
SELECT add_paper_cite('Manage pollination as an active constraint on yield rather than assuming it is adequate. A meta-analysis of field studies across 532 orchard replicates found strong evidence of pollen limitation for both fruit set and seed set.',
 'Eeraerts et al. 2025, Journal of Applied Ecology', 'https://doi.org/10.1111/1365-2664.70155', 'pp. 2487-2501');

SELECT add_paper_op('OAR55', 'Pollination', 'Wild bee contribution',
 'Do not treat hive numbers as the whole of pollination. Honeybees made 71.9 per cent of flower visits but contributed less than their share of visitation once efficiency was accounted for, while wild bee visitation had a small but clear positive effect on fruit weight and seed set.');
SELECT add_paper_cite('Do not treat hive numbers as the whole of pollination. Honeybees made 71.9 per cent of flower visits but contributed less than their share of visitation once efficiency was accounted for, while wild bee visitation had a small but clear positive effect on fruit weight and seed set.',
 'Eeraerts et al. 2025, Journal of Applied Ecology', 'https://doi.org/10.1111/1365-2664.70155', 'pp. 2487-2501');

SELECT add_paper_op('OAR50', 'Pollination', 'Native bee service in Australia',
 'Do not plan on native bees substituting for managed hives in most Australian districts. Stingless bees only provide pollination service above 22 degrees Celsius, their visits fall away with distance from native forest, and their subtropical distribution excludes most apple-producing regions.');
SELECT add_paper_cite('Do not plan on native bees substituting for managed hives in most Australian districts. Stingless bees only provide pollination service above 22 degrees Celsius, their visits fall away with distance from native forest, and their subtropical distribution excludes most apple-producing regions.',
 'Tierney et al. 2023, Proc. R. Soc. B', 'https://doi.org/10.1098/rspb.2023.0747', '290(2000): 20230747');

SELECT add_paper_op('OAR50', 'Pollination', 'Variety pollination demand',
 'Set pollination inputs per variety. Pollinator dependence differs between varieties, and pollinator guilds differ in how effectively they pollinate apple flowers.');
SELECT add_paper_cite('Set pollination inputs per variety. Pollinator dependence differs between varieties, and pollinator guilds differ in how effectively they pollinate apple flowers.',
 'Garratt et al. 2016, PLoS ONE', 'https://doi.org/10.1371/journal.pone.0153889', '11(5): e0153889');

-- ===========================================================================
-- Post-harvest
-- ===========================================================================

SELECT add_paper_op('OAR82', 'Post-harvest handling', 'Dynamic controlled atmosphere',
 'Consider dynamic controlled atmosphere as an alternative to a chemical scald inhibitor. Dynamic CA guided by chlorophyll fluorescence, and repeated low-oxygen stress followed by ultra-low oxygen, suppressed superficial scald for ten months of storage plus seven days of shelf life, and held higher flesh firmness and soluble solids.');
SELECT add_paper_cite('Consider dynamic controlled atmosphere as an alternative to a chemical scald inhibitor. Dynamic CA guided by chlorophyll fluorescence, and repeated low-oxygen stress followed by ultra-low oxygen, suppressed superficial scald for ten months of storage plus seven days of shelf life, and held higher flesh firmness and soluble solids.',
 'Kawhena et al. 2021, Agriculture', 'https://doi.org/10.3390/agriculture11060491', '11(6): 491');

DROP FUNCTION add_paper_op(TEXT, TEXT, TEXT, TEXT);
DROP FUNCTION add_paper_cite(TEXT, TEXT, TEXT, TEXT);
