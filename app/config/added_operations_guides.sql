-- ---------------------------------------------------------------------------
-- Passes 5-9 of the corpus review, in one file:
--   IPM for Australian Apples & Pears (223 pp, offset +11)
--   New Jersey Commercial Tree Fruit Production Guide (306 pp, offset +2)
--   Midwest Fruit Pest Management Guide (292 pp, offset 0)
--   Southeast USA Apple Orchard Integrated Guide (109 pp, offset +3)
--   Spray Bulletin for Commercial Tree Fruit Growers (187 pp, offset +8)
--
-- These five are pest and disease guides and overlap heavily with what the portal
-- already carries, so most of this pass attaches each guide's own page to existing
-- operations. Every page below was found by locating the topic in that guide's text
-- and converting the PDF page to the printed page using the offset verified above.
--
-- Each guide's unique management content is added as new operations further down.
-- ---------------------------------------------------------------------------

CREATE TEMP TABLE guide_page(db TEXT, url TEXT, subsection TEXT, page TEXT);

INSERT INTO guide_page VALUES
('IPM for Australian Apples and Pears','https://extensionaus.com.au/ozapplepearipdm/home','Alternaria','p. 118'),
('IPM for Australian Apples and Pears','https://extensionaus.com.au/ozapplepearipdm/home','Alternaria leaf spot','p. 118'),
('IPM for Australian Apples and Pears','https://extensionaus.com.au/ozapplepearipdm/home','Aphids','p. 136'),
('IPM for Australian Apples and Pears','https://extensionaus.com.au/ozapplepearipdm/home','Apple dimpling bug','p. 36'),
('IPM for Australian Apples and Pears','https://extensionaus.com.au/ozapplepearipdm/home','Apple leafhopper','p. 141'),
('IPM for Australian Apples and Pears','https://extensionaus.com.au/ozapplepearipdm/home','Apple scab','p. 200'),
('IPM for Australian Apples and Pears','https://extensionaus.com.au/ozapplepearipdm/home','Beneficial insects','p. 180'),
('IPM for Australian Apples and Pears','https://extensionaus.com.au/ozapplepearipdm/home','Biofix','p. 59'),
('IPM for Australian Apples and Pears','https://extensionaus.com.au/ozapplepearipdm/home','Biological control','p. 77'),
('IPM for Australian Apples and Pears','https://extensionaus.com.au/ozapplepearipdm/home','Bitter pit','p. 146'),
('IPM for Australian Apples and Pears','https://extensionaus.com.au/ozapplepearipdm/home','Bitter rot','p. 53'),
('IPM for Australian Apples and Pears','https://extensionaus.com.au/ozapplepearipdm/home','Bitter rot (Glomerella)','p. 182'),
('IPM for Australian Apples and Pears','https://extensionaus.com.au/ozapplepearipdm/home','Bryobia mite','p. 86'),
('IPM for Australian Apples and Pears','https://extensionaus.com.au/ozapplepearipdm/home','Codling moth','p. 55'),
('IPM for Australian Apples and Pears','https://extensionaus.com.au/ozapplepearipdm/home','Crown gall','p. 5'),
('IPM for Australian Apples and Pears','https://extensionaus.com.au/ozapplepearipdm/home','Degree days','p. 59'),
('IPM for Australian Apples and Pears','https://extensionaus.com.au/ozapplepearipdm/home','European red mite','p. 83'),
('IPM for Australian Apples and Pears','https://extensionaus.com.au/ozapplepearipdm/home','European red mite eggs','p. 85'),
('IPM for Australian Apples and Pears','https://extensionaus.com.au/ozapplepearipdm/home','Helicoverpa and loopers','p. 71'),
('IPM for Australian Apples and Pears','https://extensionaus.com.au/ozapplepearipdm/home','Lightbrown apple moth (LBAM)','p. 73'),
('IPM for Australian Apples and Pears','https://extensionaus.com.au/ozapplepearipdm/home','Mealybugs','p. 81'),
('IPM for Australian Apples and Pears','https://extensionaus.com.au/ozapplepearipdm/home','Mediterranean fruit fly (Medfly)','p. 201'),
('IPM for Australian Apples and Pears','https://extensionaus.com.au/ozapplepearipdm/home','Nursery stock','p. 105'),
('IPM for Australian Apples and Pears','https://extensionaus.com.au/ozapplepearipdm/home','Orchard hygiene','p. 40'),
('IPM for Australian Apples and Pears','https://extensionaus.com.au/ozapplepearipdm/home','Oriental fruit moth','p. 24'),
('IPM for Australian Apples and Pears','https://extensionaus.com.au/ozapplepearipdm/home','Phytophthora','p. 105'),
('IPM for Australian Apples and Pears','https://extensionaus.com.au/ozapplepearipdm/home','Plague thrips','p. 123'),
('IPM for Australian Apples and Pears','https://extensionaus.com.au/ozapplepearipdm/home','Powdery mildew','p. 111'),
('IPM for Australian Apples and Pears','https://extensionaus.com.au/ozapplepearipdm/home','Queensland fruit fly','p. 62'),
('IPM for Australian Apples and Pears','https://extensionaus.com.au/ozapplepearipdm/home','Resistance management','p. 95'),
('IPM for Australian Apples and Pears','https://extensionaus.com.au/ozapplepearipdm/home','San José scale','p. 116'),
('IPM for Australian Apples and Pears','https://extensionaus.com.au/ozapplepearipdm/home','Season review','p. 16'),
('IPM for Australian Apples and Pears','https://extensionaus.com.au/ozapplepearipdm/home','Silver leaf','p. 150'),
('IPM for Australian Apples and Pears','https://extensionaus.com.au/ozapplepearipdm/home','Sooty blotch','p. 192'),
('IPM for Australian Apples and Pears','https://extensionaus.com.au/ozapplepearipdm/home','Two-spotted mite','p. 88'),
('IPM for Australian Apples and Pears','https://extensionaus.com.au/ozapplepearipdm/home','Western flower thrips','p. 123'),
('IPM for Australian Apples and Pears','https://extensionaus.com.au/ozapplepearipdm/home','Western flower thrips (WFT)','p. 123'),
('IPM for Australian Apples and Pears','https://extensionaus.com.au/ozapplepearipdm/home','Wingless grasshopper','p. 157'),
('IPM for Australian Apples and Pears','https://extensionaus.com.au/ozapplepearipdm/home','Woolly apple aphid','p. 205'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Alternaria','p. 124'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Aphids','p. 244'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Apple leafhopper','p. 134'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Apple scab','p. 112'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Beneficial insects','p. 75'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Biofix','p. 247'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Biological control','p. 130'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Bitter pit','p. 231'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Bitter rot','p. 128'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Bitter rot, White rot','p. 124'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Black and white rots','p. 252'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Black rot','p. 113'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Brown marmorated stink bug (BMSB)','p. 245'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Cedar apple rust','p. 113'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Codling moth','p. 246'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Crown gall','p. 151'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Degree days','p. 267'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Dogwood borer','p. 246'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','European apple sawfly','p. 131'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','European red mite','p. 132'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Fire blight','p. 229'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Fire blight suppression','p. 239'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Frogeye leaf spot','p. 119'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Fumigate','p. 109'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Fungicide resistance','p. 112'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Green apple aphid','p. 143'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Japanese beetle','p. 143'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Japanese beetles','p. 109'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Leafminers','p. 244'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Leafrollers','p. 244'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Mealybugs','p. 139'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Mite management','p. 140'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Nursery stock','p. 106'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Oriental fruit moth','p. 142'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Phytophthora','p. 106'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Plant bugs','p. 139'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Plum curculio','p. 139'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Potato leafhopper','p. 245'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Powdery mildew','p. 125'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Redbanded leafroller','p. 139'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Resistance management','p. 136'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Rosy apple aphid','p. 133'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Rot fungi','p. 126'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','San Jose scale','p. 134'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Scale insects','p. 140'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Sooty blotch','p. 120'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Sooty blotch and flyspeck','p. 115'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Spotted tentiform leafminer','p. 134'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Sprayer calibration','p. 46'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Tarnished plant bug','p. 142'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Two-spotted mite','p. 141'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Weather station','p. 69'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','White apple leafhopper','p. 134'),
('New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','Woolly apple aphid','p. 228'),
('Midwest Fruit Pest Management Guide','https://extension.illinois.edu/fruit/midwest-fruit-pest-management-guide','Alternaria','p. 193'),
('Midwest Fruit Pest Management Guide','https://extension.illinois.edu/fruit/midwest-fruit-pest-management-guide','American plum borer','p. 51'),
('Midwest Fruit Pest Management Guide','https://extension.illinois.edu/fruit/midwest-fruit-pest-management-guide','Apple leafhopper','p. 52'),
('Midwest Fruit Pest Management Guide','https://extension.illinois.edu/fruit/midwest-fruit-pest-management-guide','Apple maggot flies','p. 38'),
('Midwest Fruit Pest Management Guide','https://extension.illinois.edu/fruit/midwest-fruit-pest-management-guide','Apple scab','p. 51'),
('Midwest Fruit Pest Management Guide','https://extension.illinois.edu/fruit/midwest-fruit-pest-management-guide','Biofix','p. 34'),
('Midwest Fruit Pest Management Guide','https://extension.illinois.edu/fruit/midwest-fruit-pest-management-guide','Bitter pit','p. 49'),
('Midwest Fruit Pest Management Guide','https://extension.illinois.edu/fruit/midwest-fruit-pest-management-guide','Bitter rot','p. 179'),
('Midwest Fruit Pest Management Guide','https://extension.illinois.edu/fruit/midwest-fruit-pest-management-guide','Black rot','p. 179'),
('Midwest Fruit Pest Management Guide','https://extension.illinois.edu/fruit/midwest-fruit-pest-management-guide','Brown marmorated stink bug (BMSB)','p. 38'),
('Midwest Fruit Pest Management Guide','https://extension.illinois.edu/fruit/midwest-fruit-pest-management-guide','Cedar apple rust','p. 14'),
('Midwest Fruit Pest Management Guide','https://extension.illinois.edu/fruit/midwest-fruit-pest-management-guide','Codling moth','p. 26'),
('Midwest Fruit Pest Management Guide','https://extension.illinois.edu/fruit/midwest-fruit-pest-management-guide','Crown gall','p. 182'),
('Midwest Fruit Pest Management Guide','https://extension.illinois.edu/fruit/midwest-fruit-pest-management-guide','Degree days','p. 34'),
('Midwest Fruit Pest Management Guide','https://extension.illinois.edu/fruit/midwest-fruit-pest-management-guide','Dogwood borer','p. 13'),
('Midwest Fruit Pest Management Guide','https://extension.illinois.edu/fruit/midwest-fruit-pest-management-guide','European red mite','p. 17'),
('Midwest Fruit Pest Management Guide','https://extension.illinois.edu/fruit/midwest-fruit-pest-management-guide','European red mite eggs','p. 17'),
('Midwest Fruit Pest Management Guide','https://extension.illinois.edu/fruit/midwest-fruit-pest-management-guide','Fire blight','p. 23'),
('Midwest Fruit Pest Management Guide','https://extension.illinois.edu/fruit/midwest-fruit-pest-management-guide','Fungicide resistance','p. 50'),
('Midwest Fruit Pest Management Guide','https://extension.illinois.edu/fruit/midwest-fruit-pest-management-guide','Fungicide rotation','p. 230'),
('Midwest Fruit Pest Management Guide','https://extension.illinois.edu/fruit/midwest-fruit-pest-management-guide','Japanese beetle','p. 214'),
('Midwest Fruit Pest Management Guide','https://extension.illinois.edu/fruit/midwest-fruit-pest-management-guide','Japanese beetles','p. 38'),
('Midwest Fruit Pest Management Guide','https://extension.illinois.edu/fruit/midwest-fruit-pest-management-guide','Leafrollers','p. 13'),
('Midwest Fruit Pest Management Guide','https://extension.illinois.edu/fruit/midwest-fruit-pest-management-guide','Nursery stock','p. 236'),
('Midwest Fruit Pest Management Guide','https://extension.illinois.edu/fruit/midwest-fruit-pest-management-guide','Oriental fruit moth','p. 26'),
('Midwest Fruit Pest Management Guide','https://extension.illinois.edu/fruit/midwest-fruit-pest-management-guide','Phytophthora','p. 15'),
('Midwest Fruit Pest Management Guide','https://extension.illinois.edu/fruit/midwest-fruit-pest-management-guide','Plant bugs','p. 133'),
('Midwest Fruit Pest Management Guide','https://extension.illinois.edu/fruit/midwest-fruit-pest-management-guide','Plum curculio','p. 29'),
('Midwest Fruit Pest Management Guide','https://extension.illinois.edu/fruit/midwest-fruit-pest-management-guide','Potato leafhopper','p. 13'),
('Midwest Fruit Pest Management Guide','https://extension.illinois.edu/fruit/midwest-fruit-pest-management-guide','Powdery mildew','p. 157'),
('Midwest Fruit Pest Management Guide','https://extension.illinois.edu/fruit/midwest-fruit-pest-management-guide','Redbanded leafroller','p. 154'),
('Midwest Fruit Pest Management Guide','https://extension.illinois.edu/fruit/midwest-fruit-pest-management-guide','Resistance management','p. 19'),
('Midwest Fruit Pest Management Guide','https://extension.illinois.edu/fruit/midwest-fruit-pest-management-guide','Rosy apple aphid','p. 13'),
('Midwest Fruit Pest Management Guide','https://extension.illinois.edu/fruit/midwest-fruit-pest-management-guide','San Jose scale','p. 13'),
('Midwest Fruit Pest Management Guide','https://extension.illinois.edu/fruit/midwest-fruit-pest-management-guide','Scale insects','p. 137'),
('Midwest Fruit Pest Management Guide','https://extension.illinois.edu/fruit/midwest-fruit-pest-management-guide','Sooty blotch','p. 32'),
('Midwest Fruit Pest Management Guide','https://extension.illinois.edu/fruit/midwest-fruit-pest-management-guide','Sprayer calibration','p. 2'),
('Midwest Fruit Pest Management Guide','https://extension.illinois.edu/fruit/midwest-fruit-pest-management-guide','Tarnished plant bug','p. 82'),
('Midwest Fruit Pest Management Guide','https://extension.illinois.edu/fruit/midwest-fruit-pest-management-guide','White apple leafhopper','p. 52'),
('Midwest Fruit Pest Management Guide','https://extension.illinois.edu/fruit/midwest-fruit-pest-management-guide','Woolly apple aphid','p. 38'),
('Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','Alternaria','p. 67'),
('Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','Alternaria leaf spot','p. 67'),
('Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','Aphids','p. 69'),
('Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','Apple leafhopper','p. 73'),
('Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','Apple scab','p. 65'),
('Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','Biological control','p. 44'),
('Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','Bitter pit','p. 53'),
('Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','Bitter rot','p. 64'),
('Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','Bitter rot, White rot','p. 63'),
('Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','Black rot','p. 16'),
('Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','Brown marmorated stink bug (BMSB)','p. 39'),
('Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','Cedar apple rust','p. 65'),
('Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','Codling moth','p. 40'),
('Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','Colletotrichum','p. 16'),
('Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','Degree days','p. 71'),
('Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','Dogwood borer','p. 33'),
('Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','European red mite','p. 73'),
('Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','European red mite eggs','p. 75'),
('Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','Fire blight','p. 90'),
('Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','Frogeye leaf spot','p. 16'),
('Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','Japanese beetle','p. 57'),
('Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','Japanese beetles','p. 69'),
('Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','Leafminers','p. 70'),
('Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','Leafrollers','p. 74'),
('Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','Mealybugs','p. 73'),
('Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','Mite management','p. 29'),
('Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','Nursery stock','p. 65'),
('Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','Oriental fruit moth','p. 75'),
('Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','Pheromone trapping','p. 40'),
('Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','Phytophthora','p. 6'),
('Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','Plant bugs','p. 10'),
('Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','Plum curculio','p. 39'),
('Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','Potato leafhopper','p. 59'),
('Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','Powdery mildew','p. 65'),
('Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','Redbanded leafroller','p. 33'),
('Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','Resistance management','p. 45'),
('Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','Rosy apple aphid','p. 46'),
('Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','Rot fungi','p. 2'),
('Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','San Jose scale','p. 69'),
('Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','Sooty blotch','p. 64'),
('Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','Spotted tentiform leafminer','p. 71'),
('Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','Sprayer calibration','p. 38'),
('Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','Tarnished plant bug','p. 2'),
('Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','Weather station','p. 40'),
('Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','White apple leafhopper','p. 19'),
('Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','Woolly apple aphid','p. 33'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','Alternaria','p. 28'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','Alternaria leaf spot','p. 28'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','Aphids','p. 32'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','Apple leafhopper','p. 32'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','Apple scab','p. 26'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','Beneficial insects','p. 35'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','Biofix','p. 1'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','Biological control','p. 1'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','Bitter pit','p. 161'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','Bitter rot','p. 73'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','Black rot','p. 21'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','Brown marmorated stink bug (BMSB)','p. 72'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','Cedar apple rust','p. 26'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','Codling moth','p. 1'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','Degree days','p. 173'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','Dogwood borer','p. 38'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','European apple sawfly','p. 32'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','European red mite','p. 36'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','Fire blight','p. 94'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','Fire blight shoot blight','p. 149'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','Fire blight suppression','p. 21'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','Frogeye leaf spot','p. 25'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','Fumigate','p. 159'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','Fungicide resistance','p. 2'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','Green apple aphid','p. 32'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','Japanese beetle','p. 37'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','Japanese beetles','p. 77'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','Leafminers','p. 40'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','Leafrollers','p. 40'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','Mealybugs','p. 37'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','Mite management','p. 67'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','Nursery stock','p. 113'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','Obliquebanded leafroller','p. 53'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','Oriental fruit moth','p. 38'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','Phytophthora','p. 96'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','Plant bugs','p. 34'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','Plum curculio','p. 34'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','Potato leafhopper','p. 68'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','Powdery mildew','p. 27'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','Redbanded leafroller','p. 39'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','Resistance management','p. 41'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','Rosy apple aphid','p. 32'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','Rot fungi','p. 29'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','San Jose scale','p. 40'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','Sooty blotch','p. 30'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','Sooty blotch and flyspeck','p. 23'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','Spotted tentiform leafminer','p. 32'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','Tarnished plant bug','p. 36'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','Weather station','p. 142'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','Western flower thrips','p. 40'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','White apple leafhopper','p. 32'),
('Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','Woolly apple aphid','p. 32');

INSERT INTO guidereference (operation_id, third_party_database, link, page_number)
SELECT o.operation_id, p.db, p.url, p.page
FROM guide_page p
JOIN operation o ON o.subsection = p.subsection
WHERE NOT EXISTS (
    SELECT 1 FROM guidereference g
    WHERE g.operation_id = o.operation_id AND g.third_party_database = p.db);

DROP TABLE guide_page;
-- 231 topic/page pairs across 5 guides

-- ---------------------------------------------------------------------------
-- Management content these guides add that the portal did not have.
-- ---------------------------------------------------------------------------

CREATE TEMP TABLE g_new(stage_code TEXT, section TEXT, subsection TEXT, description TEXT, db TEXT, url TEXT, page TEXT);

INSERT INTO g_new VALUES
-- Southeast USA guide: spray volume, pesticide chemistry, floor, pollination, analysis
('ODG02','IPDM','Tree row volume','Set spray volume from tree row volume rather than a fixed rate per hectare, so the dose matches the canopy actually being sprayed.','Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','p. 37'),
('ODG02','IPDM','Spray water pH','Check the pH of the spray water: some products break down quickly in alkaline water and lose activity before they reach the target.','Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','p. 48'),
('ODG02','Nutrient management','Soil and plant analysis','Follow the regional soil and plant analysis guidelines for sampling depth, timing and interpretation, so results can be compared season to season.','Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','p. 52'),
('ODG02','Fertilization','Fertility program','Set the season''s fertility program from the published recommendations for apples, adjusted by the block''s own analysis results.','Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','p. 54'),
('OAR55','Pollination','Pesticides during bloom','Work through the pollination, honeybee and pesticide guidance together before spraying anything at bloom.','Southeast USA Apple Orchard Integrated Guide','https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast','p. 51'),

-- Spray Bulletin: calibration, predator toxicity, degree days
('ODG02','IPDM','Spray volume calculation','Calculate spray volume and calibrate the sprayer by the published method before the season, and re-check it when nozzles or speed change.','Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','p. 57'),
('ODG02','IPDM','Predator toxicity','Check a product''s toxicity to orchard predators before choosing it; the cheapest option is often the one that costs the most in lost biological control.','Spray Bulletin for Commercial Tree Fruit Growers','https://www.pubs.ext.vt.edu/456/456-419/456-419.html','p. 55'),

-- New Jersey guide: pesticide safety and record keeping
('ODG02','IPDM','Applicator certification','Keep applicator certification and licensing current for everyone who applies pesticides on the block.','New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','p. 10'),
('ODG02','IPDM','Reading the label','Read the label as the legal document it is: rates, timing, re-entry and withholding periods all sit there, and it overrides any guide.','New Jersey Commercial Tree Fruit Production Guide','https://njaes.rutgers.edu/pubs/publication.php?pid=E002','p. 12');

DELETE FROM guidereference WHERE operation_id IN (
    SELECT o.operation_id FROM operation o JOIN g_new n ON n.description = o.description);
DELETE FROM operation o USING g_new n WHERE n.description = o.description;

INSERT INTO operation (stage_id, reference_id, description, section, subsection, status)
SELECT s.stage_id,
       (SELECT id FROM reference_data WHERE bibtex_key = 'ferreeApplesBotanyProduction2003' LIMIT 1),
       n.description, n.section, n.subsection, 'confirmed'
FROM g_new n JOIN stage s ON s.stage_code = n.stage_code;

INSERT INTO guidereference (operation_id, third_party_database, link, page_number)
SELECT o.operation_id, n.db, n.url, n.page
FROM g_new n
JOIN stage s ON s.stage_code = n.stage_code
JOIN operation o ON o.stage_id = s.stage_id AND o.description = n.description;

DROP TABLE g_new;

DELETE FROM guidereference g
WHERE g.guidereference_id NOT IN (
    SELECT MIN(guidereference_id) FROM guidereference
    GROUP BY operation_id, third_party_database, link, COALESCE(page_number, ''));
