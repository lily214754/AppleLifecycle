-- Restores the original key measurements on the natural-development stages.
--
-- protocol.sql seeds every Table S4B protocol onto every stage whose BBCH range it
-- covers. On the orchard and annual-cycle stages that is what we want. On the five
-- NDG stages it is not: those lists were curated by hand for the natural life cycle,
-- and the protocol pass added eighteen further measurements on top of them --
-- trunk cross-sectional area, leaf mass per area, epidermal cell counts and so on --
-- which belong to managed orchard trees rather than to this part of the life cycle.
--
-- The whitelist below is the original list for each stage, taken from the key
-- measurement column of the corresponding row in app/data/tablesData.json. Anything
-- on an NDG stage that is not on this list is removed.
--
-- Runs after protocol.sql, which is what creates the rows being removed.

DELETE FROM key_measurement k
 USING stage s
 WHERE s.stage_id = k.stage_id
   AND s.stage_code LIKE 'NDG%'
   AND (s.stage_code, k.measurement_name) NOT IN (

    -- NDG00  Seed Germination
    ('NDG00', 'Environmental condition'),
    ('NDG00', 'Soil pH'),
    ('NDG00', 'Soil moisture'),
    ('NDG00', 'Temperature'),

    -- NDG01  Juvenile Period
    ('NDG01', 'Leaf size, width, serrations, and cell size'),
    ('NDG01', 'Node number'),
    ('NDG01', 'Thorns existence'),
    ('NDG01', 'Adventitious root existence and the angle between side shoots and the main stem'),
    ('NDG01', 'Biochemical markers'),
    ('NDG01', 'Vegetative growth e.g., Trunk diameter, shoot length'),

    -- NDG02  Transition Period
    ('NDG02', 'Node number'),
    ('NDG02', 'Biochemical markers'),
    ('NDG02', 'Vegetative growth'),

    -- NDG03  Reproductive Phase
    ('NDG03', 'Node number'),
    ('NDG03', 'Biochemical markers'),

    -- NDG04  Aging
    ('NDG04', 'Growth rate'),
    ('NDG04', 'Terminal growing point')
);
