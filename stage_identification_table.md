# Portal stage identification — 2026-09-29

## Notes

1. **Code order is not always time order.** Stage codes follow BBCH numbering, and BBCH numbers group stages by organ, not by calendar. Sorting the codes therefore does not always give the order in which stages happen in the season, even inside the first level (OAR).
   - **OAR90** (shoot growth completed, BBCH91) comes **before** OAR80. Terminal buds set 40–90 days after full bloom, so OAR90 falls after fruit development (OAR70–79) and before the start of fruit maturity (OAR80). OAR91–94 do follow in code order: OAR92 (beginning of leaf fall) comes after OAR91 (leaves begin to discolour).
   - **OAR95** (harvested product) comes right after picking (OAR83), not after leaf fall.
   - Some stages **run at the same time** as others:
     - OAR(30–39) shoot development overlaps inflorescence emergence, flowering and early fruit development.
     - OAR(60–62) flower bud formation starts during flowering and continues through fruit development.

How to recognise each portal stage in the tree. The table uses the latest portal codes (`app/config/fix_oar_bbch_mapping.sql`).

This table does not list transitions. Each row describes **the stage itself**:
- what you see in the tree during that stage;
- which OAR substage matches which BBCH code;
- which number, if any, pins it down.

Thresholds come from `analysis/gen_stage_thresholds.py`. References are BibTeX keys from `mybibliography.bib`.

## Natural developmental cycle (NDG) — seedling tree

| Stage | How to identify it | Quantitative threshold | Reference |
|---|---|---|---|
| **NDG00** Seed germination | Seed germinates in spring. Cotyledons emerge and the seedling starts growing. | No clearly definable quantitative threshold. | ferreeApplesBotanyProduction2003 |
| **NDG01** Juvenile period | Tree grows but **cannot flower**. Shoots carry thorns and root easily. | 4–8 years from germination (up to 12). Up to ~77 main-stem nodes. | visserJuvenilePhaseGrowth1964; zhangPotentialPolyphenolMarkers2007 |
| **NDG02** Transition period | **First flower buds appear**, while juvenile traits (thorns, rooting) are still present. | ~77–122 main-stem nodes. Phlorizin present in buds. | zhangPotentialPolyphenolMarkers2007 |
| **NDG03** Reproductive phase | Tree **flowers every year** without artificial stimulation. | >122 main-stem nodes. Myricitrin absent from bark. | zhangPotentialPolyphenolMarkers2007; kotodaFloweringJuvenilityApple2021 |
| **NDG04** Aging | Growth rate slows and terminal growing points multiply. Vigour and flowering decline. | No clearly definable quantitative threshold. | greenwoodMaturationDevelopmentalProcess1993 |

## Orchard developmental cycle (ODG) — orchard tree

| Stage | How to identify it | Quantitative threshold | Reference |
|---|---|---|---|
| **ODG00** Planting tree | Site preparation, planting and establishment of the block. | Event-defined (ends when planting is complete). Graft union 15 cm above ground (M.9: 25–35 cm). 1000–6000 trees/ha. | ferreeApplesBotanyProduction2003 |
| **ODG01** Young tree | Canopy is **still growing into its allotted space**. First flowering and early crops. | ~5–7 years after planting. Canopy area and light interception rise every year. | ferreeApplesBotanyProduction2003; lordanLongtermEffectsTree2018 |
| **ODG02** Mature tree | Canopy **fills its space**. Regular annual flowering and stable yield. | From about year 6. Light interception 53–72 % (system and density). LAI 1.5–2.8. | lordanLongtermEffectsTree2018; middletonProductivityPerformanceApple2002 |
| **ODG03** End of productive life | **Sustained decline** in yield, vigour or tree health leads to reworking or replacement. | No clearly definable quantitative threshold. | ferreeApplesBotanyProduction2003 |

## Annual reproductive cycle (OAR) — one season

| Stage | How to identify it | OAR–BBCH mapping | Quantitative threshold | Reference |
|---|---|---|---|---|
| **OAR00** Dormancy | Leaf and flower buds **closed**, covered by dark-brown scales. No visible growth. | OAR00 = BBCH00. Substages OAR00-00 para-, OAR00-01 endo-, OAR00-02 eco-dormancy (no BBCH). | ~800–1200 chill units to release endo-dormancy (cultivar-dependent). | meierGrowthStagesMonoand1997; parkesChillingRequirementsApple2020; gonzaleznoguerAppleMalusDomestica2023 |
| **OAR(01–04)** Bud development | Leaf buds **swell** and scales lighten, then **green leaf tips** appear. | OAR01 = BBCH01 · OAR02 = BBCH03 · OAR03 = BBCH07 · OAR04 = BBCH09 | Green tips ~5 mm above bud scales (BBCH09). ~24 days. | meierGrowthStagesMonoand1997; martinezPhenologicalGrowthStages2019 |
| **OAR(10–13)** Leaf development | Leaves **separate, unfold and expand** to full size. | OAR10 = BBCH10 · OAR11 = BBCH11 · OAR12 = BBCH15 · OAR13 = BBCH19 | Leaf tips ~10 mm above scales at OAR10. ~45 days to 2 months. | meierGrowthStagesMonoand1997; wunscheRelationshipLeafArea2000 |
| **OAR(30–39)** Shoot development | Current-season **shoots elongate**. | OAR30 = BBCH31. Progression runs through BBCH32–39. | BBCH35 ~50 %, BBCH39 ~90 % of final shoot length. | meierGrowthStagesMonoand1997 |
| **OAR(40–47)** Inflorescence emergence | **Flower buds** swell, burst and separate, from green cluster to pink to hollow ball. | OAR40 = BBCH51 · OAR41 = BBCH52 · OAR42 = BBCH53 · OAR43 = BBCH54 · OAR44 = BBCH55 · OAR45 = BBCH56 · OAR46 = BBCH57 · OAR47 = BBCH59 | No clearly definable quantitative threshold. ~28 days. | meierGrowthStagesMonoand1997; martinezPhenologicalGrowthStages2019 |
| **OAR(50–59)** Flowering | **Flowers open**, then petals fall. Pollination, fertilisation and fruit set take place (OAR50-00/-01/-02). | OAR50 = BBCH60 · OAR51 = BBCH61 · OAR55 = BBCH65 · OAR57 = BBCH67 · OAR59 = BBCH69 | BBCH61 ~10 % of flowers open. BBCH65 ≥50 % open. ~3 weeks. | meierGrowthStagesMonoand1997; losadaInfluenceProgamicPhase2013 |
| **OAR(60–62)** Flower bud formation for next season | Next year's flower buds are **induced, initiated and differentiated** inside current buds. Nothing is visible outside; bud dissection or histology is needed. | OAR60 induction · OAR61 initiation · OAR62 differentiation. No BBCH equivalent. | Apex doming ~40–50 DAFB. ~16–20 appendages before initiation. Plastochron ≥7 d. Complete 15–22 weeks after full bloom. | fosterMorphologicalQuantitativeCharacterization2003; mcartneySeasonalVariationOnset2001 |
| **OAR(70–79)** Fruit development | **Fruitlets grow** through first fruit fall, June drop and the T-stage. Includes cell division (OAR70-00) and cell enlargement (OAR70-01). | OAR70 = beginning (no BBCH) · OAR71 = BBCH71 · OAR72 = BBCH72 · OAR73 = BBCH73 · OAR74 = BBCH74 | Fruit ≤10 mm (BBCH71), ≤20 mm (BBCH72), ≤40 mm (BBCH74). Stage ends at ~90 % of final size. Can exceed 160 days. | meierGrowthStagesMonoand1997; martinezPhenologicalGrowthStages2019 |
| **OAR(80–84)** Maturity of fruit and seed | **Cultivar colour appears** and intensifies. Fruit becomes ripe for picking, then ripe for eating. | OAR80 = beginning (no BBCH) · OAR81 = BBCH81 · OAR82 = BBCH85 · OAR83 = BBCH87 · OAR84 = BBCH89 | No single numerical boundary. Picking maturity uses cultivar-specific firmness, starch, SSC and acidity limits. ~40 days. | meierGrowthStagesMonoand1997; vielmaOptimalHarvestTime2008 |
| **OAR(90–95)** Senescence | **Terminal buds set** and shoot growth stops, then leaves discolour and fall. | OAR90 = BBCH91 · OAR91 = BBCH92 · OAR92 = BBCH93 · OAR93 = BBCH95 · OAR94 = BBCH97 · OAR95 = BBCH99 (harvested product) | Shoot growth ends 40–90 DAFB. BBCH95 ~50 % leaves discoloured. BBCH97 all leaves fallen. ~118 days including winter rest. | meierGrowthStagesMonoand1997; forsheyRelationshipVegetativeGrowth1989 |

**Notes**
- **DAFB** = days after full bloom. **SSC** = soluble solids content. **LAI** = leaf area index.
- **Changes from the old Table S4A:**
  - Shoot-growth completion is now **OAR90 = BBCH91**, not OAR79.
  - Maturity now runs **OAR80–84**, with OAR83 = BBCH87 (ripe for picking) and OAR84 = BBCH89 (ripe for eating).
  - Senescence now starts at **OAR90 = BBCH91**, not OAR90 = BBCH92.
