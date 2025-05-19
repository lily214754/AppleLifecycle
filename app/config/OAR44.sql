



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
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p.46');

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
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p.46');

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
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p.46');

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
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p.47');

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
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p.45');

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
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p.44');

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
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p.44');

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
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p.44');

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
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p.44');

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
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p.44');

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
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p.44');

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
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p.44');

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
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p.44');

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
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p.44');

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
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p.44');

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
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p.44');

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
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p.44');

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
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p.44');

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
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p.44');

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
 'https://extension.oregonstate.edu/sites/extd8/files/documents/donnelja/2024-pest-management-guide-tree-fruit.pdf', 'p.23');
