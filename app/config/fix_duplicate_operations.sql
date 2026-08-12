-- Merges the seven near-duplicate operation pairs that fix_stage_timing.sql brought
-- together. Each pair is one pest or disease described twice at the same stage: the
-- entry that already lived there, and the entry that has just been moved in from the
-- stage it had been mis-filed under.
--
-- Both sides carry independently curated citations -- typically five to seven guides
-- each, overlapping but not identical -- so the merge keeps the union. The citations
-- unique to the discarded row are re-pointed onto the surviving row first; only the
-- ones that would be exact duplicates are dropped.
--
-- guidereference.operation_id is ON DELETE CASCADE, so the re-point MUST happen before
-- the DELETE or the unique citations would be destroyed with the row.
--
-- Which side survives: whichever description states the action and its timing more
-- precisely, regardless of which one was moved. Keyed on description text because
-- operation_id is SERIAL and is reassigned on every rebuild.

CREATE OR REPLACE FUNCTION merge_operations(p_keep TEXT, p_drop TEXT) RETURNS VOID AS $$
DECLARE
    v_keep INT;
    v_drop INT;
BEGIN
    SELECT operation_id INTO v_keep FROM operation WHERE description = p_keep;
    SELECT operation_id INTO v_drop FROM operation WHERE description = p_drop;
    IF v_keep IS NULL OR v_drop IS NULL OR v_keep = v_drop THEN
        RETURN;   -- already merged, or a description changed upstream
    END IF;

    -- Carry across only the citations the surviving row does not already have.
    UPDATE guidereference g
       SET operation_id = v_keep
     WHERE g.operation_id = v_drop
       AND NOT EXISTS (
           SELECT 1 FROM guidereference k
            WHERE k.operation_id = v_keep
              AND k.third_party_database IS NOT DISTINCT FROM g.third_party_database
              AND k.link                 IS NOT DISTINCT FROM g.link
              AND k.page_number          IS NOT DISTINCT FROM g.page_number);

    -- Whatever is left on the discarded row is an exact duplicate of a kept citation.
    DELETE FROM guidereference WHERE operation_id = v_drop;
    DELETE FROM operation      WHERE operation_id = v_drop;
END;
$$ LANGUAGE plpgsql;

-- Leaf Bud Swelling ---------------------------------------------------------
-- Keep the entry naming where the oil goes.
SELECT merge_operations(
  'Use dormant oil for effective egg suppression on branches.',
  'Apply dormant oil spray to suppress overwintering mite eggs.');

-- Keep the fungicide entry; the bud-removal half of mildew management is already
-- held separately at Dormancy ("Remove infected buds or shoots...").
SELECT merge_operations(
  'Use systemic fungicides to protect emerging buds and shoots.',
  'Manage powdery mildew through bud removal and fungicide at Bud Swell and blossom stage.');

-- Keep the entry that names the growth stage and the scouting step.
SELECT merge_operations(
  'Scout and apply insecticides at green tip before leaf curl.',
  'Apply systemic insecticides before leaf curling begins.');

-- Full Bloom ----------------------------------------------------------------
-- Keep the entry specifying protectant fungicides against primary infection.
SELECT merge_operations(
  'Apply protectant fungicides during bloom to control primary scab infections.',
  'Apply fungicides preventively at blossom and fruiting to prevent Apple scab.');

-- Shoot Growth Completed ----------------------------------------------------
SELECT merge_operations(
  'Apply rot-specific fungicides during warm, wet conditions.',
  'Apply fungicides targeting summer rot pathogens under warm, wet conditions.');

-- Keep the entry giving the actual decision rule.
SELECT merge_operations(
  'Treat if second or third generations exceed trap thresholds.',
  'Monitor and apply control measures through midseason generations.');

SELECT merge_operations(
  'Treat crawler stage during summer for effective suppression.',
  'Treat crawlers during summer for effective suppression.');

DROP FUNCTION merge_operations(TEXT, TEXT);
