-- Corrects operations whose described timing does not match the BBCH stage they were
-- seeded under. All of these come from the original natural.sql pest/disease block,
-- which catalogued each pest once and filed it under whichever stage it was first
-- listed against, regardless of when the described action is actually carried out.
--
-- Every move below is grounded in the corpus guides already used elsewhere in this
-- project -- the NSW Orchard Plant Protection Guide 2025 and the Australian Apple and
-- Pear IPDM Manual 2020-21 -- quoted in the comment above each block.
--
-- Keyed on description text rather than operation_id: the ids are SERIAL and are
-- reassigned whenever natural.sql rebuilds, so text is the stable handle. Each UPDATE
-- is idempotent -- re-running it after the row has moved matches nothing.

-- Helper: move one operation to a different stage by its description.
CREATE OR REPLACE FUNCTION restage(p_desc TEXT, p_from TEXT, p_to TEXT) RETURNS VOID AS $$
BEGIN
    UPDATE operation o
       SET stage_id = (SELECT stage_id FROM stage WHERE stage_code = p_to)
      FROM stage s
     WHERE s.stage_id = o.stage_id
       AND s.stage_code = p_from
       AND o.description = p_desc;
END;
$$ LANGUAGE plpgsql;

-- ---------------------------------------------------------------------------
-- Out of Dormancy (OAR00)
-- ---------------------------------------------------------------------------

-- NSW guide: scab fungicides run "between spur burst and petal fall"; scab occurs
-- "from green tip until leaf drop". A blossom-and-fruiting spray is not a dormancy
-- operation. OAR00 keeps its correct dormant-inoculum entry.
SELECT restage('Apply fungicides preventively at blossom and fruiting to prevent Apple scab.',
               'OAR00', 'OAR55');

-- IPDM manual: "Monitor for bryobia mites fortnightly from late spring to the end of
-- summer." The description already says Midseason to End of Harvest.
SELECT restage('Apply miticides during Midseason to End of Harvest to control Bryobia mite.',
               'OAR00', 'OAR73');

-- Bud swell is the first action in this entry; OAR00 retains the dormant-season
-- half of mildew management (removal of infected buds and shoots).
SELECT restage('Manage powdery mildew through bud removal and fungicide at Bud Swell and blossom stage.',
               'OAR00', 'OAR01');

-- ---------------------------------------------------------------------------
-- Into Dormancy (OAR00) -- dormant applications filed one stage late
-- ---------------------------------------------------------------------------

SELECT restage('Apply dormant fungicides and avoid trunk injury near soil line.',
               'OAR01', 'OAR00');

-- ---------------------------------------------------------------------------
-- Dormant / delayed-dormant oil filed under leaf development or pink bud.
-- IPDM manual: "Dormant application of lime sulphur in combination with oil sprays
-- will help to control San Jose scale." Oil at pink bud is both too late for the
-- target and a phytotoxicity risk.
-- ---------------------------------------------------------------------------

SELECT restage('Apply dormant oil or miticide if overwintering eggs are present.',
               'OAR10', 'OAR01');
SELECT restage('Scout and apply insecticides at green tip before leaf curl.',
               'OAR10', 'OAR01');
SELECT restage('Use dormant oil or early insecticides to suppress scale crawlers.',
               'OAR10', 'OAR01');
SELECT restage('Apply dormant oil spray to suppress overwintering mite eggs.',
               'OAR43', 'OAR01');

-- ---------------------------------------------------------------------------
-- Summer / midseason actions filed under leaf development (OAR11) and end of
-- flowering (OAR59). IPDM manual: bitter rot "is most likely to become a problem in
-- areas with hot, humid summers" and is "usually seen ... after November".
-- OAR73 (Shoot Growth Completed) is this project's midsummer stage.
-- ---------------------------------------------------------------------------

SELECT restage('Apply fungicides targeting summer rot pathogens under warm, wet conditions.',
               'OAR11', 'OAR73');
SELECT restage('Target summer generation larvae feeding on fruit and leaves.',
               'OAR11', 'OAR73');
SELECT restage('Monitor and apply control measures through midseason generations.',
               'OAR11', 'OAR73');
SELECT restage('Treat crawlers during summer for effective suppression.',
               'OAR11', 'OAR73');
SELECT restage('Apply fungicides to control summer rots as conditions become favorable.',
               'OAR59', 'OAR73');

-- Rutherglen bug is a late-season migrant into ripening fruit.
SELECT restage('Apply border sprays if high populations are found near harvest.',
               'OAR11', 'OAR82');

-- ---------------------------------------------------------------------------
-- Post-harvest orchard-floor and overwintering treatments filed under Harvest.
-- IPDM manual: "application of urea to trees or ground at leaf fall to promote
-- [breakdown of] overwintering inoculum"; "Ground and foliar applications of urea
-- well after harvest will help leaves to break down more [quickly]".
-- These belong at Beginning of Leaf Fall (OAR91), not at Fruit Harvest.
-- OAR82 keeps the operations that act on the fruit itself at harvest.
-- ---------------------------------------------------------------------------

SELECT restage('Apply urea postharvest to reduce overwintering scab inoculum.',
               'OAR82', 'OAR91');
SELECT restage('apply postharvest sprays if high-pressure seasons or known carryover risk.',
               'OAR82', 'OAR91');
SELECT restage('postharvest treatment to target overwintering scale and crawler suppression.',
               'OAR82', 'OAR91');
SELECT restage('apply chlorpyrifos or endosulfan after harvest to manage root colonies.',
               'OAR82', 'OAR91');

DROP FUNCTION restage(TEXT, TEXT, TEXT);
