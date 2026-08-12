-- ---------------------------------------------------------------------------
-- Repairing dead [Details] links.
--
-- Five Hort Innovation resource PDFs return 404: that path was reorganised and
-- the files no longer sit there. Each is replaced by a live address for the same
-- publication, verified to return HTTP 200 before being written here.
--
-- Sites behind a WAF (NSW DPIRD, APAL, UMass) answer 403 to every automated
-- request, so they cannot be verified from here. They are left as they are rather
-- than replaced on a guess -- a 403 is not evidence of a dead page.
-- ---------------------------------------------------------------------------

-- Bird damage: the Hort Innovation copy is gone; this is the same 2007 Bureau of
-- Rural Sciences publication, mirrored and reachable.
UPDATE guidereference
SET link = 'https://library.sprep.org/sites/default/files/2021-05/managing-bird-damage-fruit-horticultural.pdf'
WHERE link = 'https://www.horticulture.com.au/globalassets/hort-innovation/resource-assets/managing-bird-damage-to-fruit-and-other-horticultural-crops.pdf';

-- Bushfire: the guide came out of Hort Innovation project AS19002, whose page is live.
UPDATE guidereference
SET link = 'https://www.horticulture.com.au/growers/help-your-business-grow/research-reports-publications-fact-sheets-and-more/as19002/'
WHERE link = 'https://www.horticulture.com.au/globalassets/hort-innovation/resource-assets/bushfires-in-orchards-preparedness-response-recovery.pdf';

-- The IPDM manual. The old globalassets PDF path 404s and the resource landing page
-- only links onward, so both now resolve to Hort Innovation's Sitecore CDN copy of
-- the PDF itself. That file was checked byte-for-byte against the corpus copy the
-- 46 citations were read from -- identical md5 (60d01d3b1ee517ecbae89902850ae61d),
-- 9,305,067 bytes, 314 pages -- so every cited page number, up to p. 266, resolves
-- against it.
UPDATE guidereference
SET link = 'https://edge.sitecorecloud.io/hortinnovat2fab-hortinnovat9661-production6d5f-0e78/media/Sub-pages/Information-hub/Project-reports/A/2020-21-australian-apple-and-pear-ipdm-manual.pdf'
WHERE link IN (
  'https://www.horticulture.com.au/globalassets/hort-innovation/resource-assets/2020-21-australian-apple-and-pear-ipdm-manual.pdf',
  'https://www.horticulture.com.au/growers/help-your-business-grow/research-reports-publications-fact-sheets-and-more/grower-resources/ap16007-assets/2020-21-australian-apple-and-pear-ipdm-manual/');

-- Drought and hail: no live replacement found for the Hort Innovation copies, so
-- point at the publisher's searchable hub rather than leave a hard 404.
UPDATE guidereference
SET link = 'https://www.horticulture.com.au/Information-Hub'
WHERE link IN (
  'https://www.horticulture.com.au/globalassets/hort-innovation/resource-assets/managing-horticultural-crops-in-drought.pdf',
  'https://www.horticulture.com.au/globalassets/hort-innovation/resource-assets/hail-damage-and-your-apple-orchard.pdf');

-- The Southeast guide's viewer URL times out; its canonical landing page does not.
UPDATE guidereference
SET link = 'https://content.ces.ncsu.edu/integrated-orchard-management-guide-for-commercial-apples-in-the-southeast'
WHERE link LIKE '%content.ces.ncsu.edu%';

-- ---------------------------------------------------------------------------
-- User-confirmed replacements (2026-08-12). Both hosts sit behind a WAF that
-- returns 403 to every automated request, so these were verified in a browser
-- rather than by the link audit; the audit will keep reporting them as 403.
-- ---------------------------------------------------------------------------

-- The guide's own PDF, rather than the section landing page it was pointing at.
-- The 2025 edition is the one held in the local corpus for verification.
UPDATE guidereference
SET link = 'https://www.dpird.nsw.gov.au/__data/assets/pdf_file/0007/1185154/Orchard-plant-protection-guide-2025.pdf'
WHERE link = 'https://www.dpird.nsw.gov.au/agriculture/horticulture/pests-diseases-hort/information-for-multiple-crops/orchard-plant-protection-guide';

-- Future Orchards: the library index, which is where the orchard walk notes and
-- tools actually live, rather than the programme's front page.
UPDATE guidereference
SET link = 'https://apal.org.au/programs/future-orchards/future-orchards-library/'
WHERE link = 'https://apal.org.au/programs/future-orchards/';

-- APAL Grower Resources: these seven citations each name their article in the
-- page_number field but pointed at the bare apal.org.au domain. The article URLs
-- below are the ones the corpus actually downloaded each page from, taken from
-- corpus/provenance.json (origin_url), so each is a verified deep link rather
-- than a reconstructed guess.
UPDATE guidereference SET link = CASE page_number
  WHEN 'Calcium to combat post-harvest disorders'
    THEN 'https://apal.org.au/calcium-combat-post-harvest-disorders'
  WHEN 'Apple crop load management: carbohydrate manipulation'
    THEN 'https://apal.org.au/apple-crop-load-management-can-effective-carbohydrate-manipulation-enhance-thinning-successes'
  WHEN 'Composts and mulches for young orchards'
    THEN 'https://apal.org.au/composts-and-mulches-for-young-orchards-do-they-stack-up'
  WHEN 'Improving bee performance'
    THEN 'https://apal.org.au/improving-bee-performance'
  WHEN 'Harvest timing key to consistent quality'
    THEN 'https://apal.org.au/harvest-timing-key-to-consistent-quality'
  WHEN 'Nutrient management for pome fruit'
    THEN 'https://apal.org.au/nutrient-management-for-pome-fruit'
  WHEN 'How healthy is your soil?'
    THEN 'https://apal.org.au/how-healthy-is-your-soil'
  ELSE link END
WHERE link IN ('https://apal.org.au/', 'https://apal.org.au')
  AND page_number IN (
    'Calcium to combat post-harvest disorders',
    'Apple crop load management: carbohydrate manipulation',
    'Composts and mulches for young orchards',
    'Improving bee performance',
    'Harvest timing key to consistent quality',
    'Nutrient management for pome fruit',
    'How healthy is your soil?');

-- NOT /grower/tools-and-templates/. That page was inferred from APAL's nav label as
-- the home of the Future Orchards calculators, and the saved copy of it disproves
-- that: it carries OrchardNet, a Hire Right checklist, the Aussie Apples guidelines
-- and Orchard Business Analysis, with no calculator on it at all. The tool citations
-- stay on the Future Orchards library URL until the calculators are actually located.
--
-- Also learned from that page's nav, and worth recording because the naming is
-- counter-intuitive:
--     /programs/future-orchards/future-orchards-library/  is labelled "Latest Materials"
--     /programs/future-orchards/archive-library/          is labelled "Future Orchards Library"
-- so the archive URL is the real library, and the older orchard walk notes and the
-- Improving Pomefruit Quality guide are most likely held there.
