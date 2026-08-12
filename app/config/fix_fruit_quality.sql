-- ---------------------------------------------------------------------------
-- "Fruit quality" was a dead end.
--
-- Fruit Development spells out what fruit quality actually is -- firmness, size,
-- soluble solids, titratable acidity, starch, dry matter, nutrients -- and each of
-- those carries a measurement protocol. Young Tree and Mature Tree simply said
-- "Fruit quality", which mapped to nothing, so it rendered as plain text with no
-- way through to a method.
--
-- It is expanded here into the same components Fruit Development uses, named the
-- same way, so the two stages behave alike and every entry leads to a protocol.
-- The protocols are also linked to these stages, so their "Applies to" list is
-- honest about where they are used.
-- ---------------------------------------------------------------------------

CREATE TEMP TABLE fq(stage_code TEXT, measurement_name TEXT, protocol_id INT);

INSERT INTO fq VALUES
('ODG01','Fruit firmness',    63),
('ODG01','Fruit size',        60),
('ODG01','Colour',            68),
('ODG01','Soluble solid',     64),
('ODG01','Titratable acidity',65),
('ODG01','Fruit dry matter',  67),
('ODG01','Fruit nutrient',    73),
('ODG02','Fruit firmness',    63),
('ODG02','Fruit size',        60),
('ODG02','Colour',            68),
('ODG02','Soluble solid',     64),
('ODG02','Titratable acidity',65),
('ODG02','Fruit dry matter',  67),
('ODG02','Fruit nutrient',    73);

-- Drop the composite that led nowhere, and any earlier run of this expansion.
DELETE FROM key_measurement k
USING stage s
WHERE k.stage_id = s.stage_id
  AND s.stage_code IN ('ODG01','ODG02')
  AND (k.measurement_name = 'Fruit quality'
       OR k.measurement_name IN (SELECT measurement_name FROM fq));

-- Insert the components where "Fruit quality" used to sit in the display order.
INSERT INTO key_measurement (stage_id, reference_id, measurement_name, display_order, origin, protocol_id)
SELECT s.stage_id, NULL, fq.measurement_name,
       (SELECT COALESCE(MAX(display_order), 0) FROM key_measurement k2 WHERE k2.stage_id = s.stage_id)
         + row_number() OVER (PARTITION BY s.stage_id ORDER BY fq.protocol_id),
       'site', fq.protocol_id
FROM fq JOIN stage s ON s.stage_code = fq.stage_code;

-- Those protocols really are used at these stages, so say so in "Applies to".
INSERT INTO protocol_stage (protocol_id, stage_id)
SELECT DISTINCT fq.protocol_id, s.stage_id
FROM fq JOIN stage s ON s.stage_code = fq.stage_code
ON CONFLICT DO NOTHING;

DROP TABLE fq;
