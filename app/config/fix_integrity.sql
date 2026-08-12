-- ---------------------------------------------------------------------------
-- Seed-data repairs found while cross-checking the corpus.
--
--  * Two citations were attached to no operation at all: their INSERT looked the
--    operation up by description and the description did not match, so they landed
--    with a NULL operation_id and have never been visible anywhere.
--  * Three ODG02 operations ended up with no citation, because the lookup that
--    should have found them matched their ODG01 twin first. They now share the
--    twin's sources.
--  * One spelling error in a description.
-- ---------------------------------------------------------------------------

DELETE FROM guidereference WHERE operation_id IS NULL;

-- Give the uncited ODG02 rows the citations their identically-worded ODG01 twins carry.
INSERT INTO guidereference (operation_id, third_party_database, link, page_number)
SELECT dst.operation_id, g.third_party_database, g.link, g.page_number
FROM operation dst
JOIN operation src ON src.description = dst.description AND src.operation_id <> dst.operation_id
JOIN guidereference g ON g.operation_id = src.operation_id
WHERE NOT EXISTS (SELECT 1 FROM guidereference x WHERE x.operation_id = dst.operation_id);

UPDATE operation
SET description = replace(description, 'appropirate', 'appropriate')
WHERE description LIKE '%appropirate%';

DELETE FROM guidereference g
WHERE g.guidereference_id NOT IN (
    SELECT MIN(guidereference_id) FROM guidereference
    GROUP BY operation_id, third_party_database, link, COALESCE(page_number, ''));
