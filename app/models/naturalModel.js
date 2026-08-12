const pool = require('../config/db');


const getAllTiming = async () => {
    const res = await pool.query('SELECT * FROM timing');
    return res.rows;
};

const getAllTimingByStageCode = async (stage_code) => {
    const res = await pool.query(`
        SELECT t.*, r.bibtex_key
        FROM timing t
        JOIN stage s ON s.stage_id = t.stage_id
        JOIN reference_data r ON r.id = t.reference_id
        WHERE s.stage_code = $1
    `, [stage_code]);
    return res.rows;
};

const getAllObservationsByStageCode = async (stage_code) => {
    const res = await pool.query(`
        SELECT o.*, r.bibtex_key
        FROM observation o
        JOIN stage s ON s.stage_id = o.stage_id
        JOIN reference_data r ON r.id = o.reference_id
        WHERE s.stage_code = $1
    `, [stage_code]);
    return res.rows;
};

const getAllKeyMeasurementsByStageCode = async (stage_code) => {
    // LEFT JOIN: most measurements carry no single citation of their own -- their
    // provenance lives on the linked measurement protocol instead.
    const res = await pool.query(`
        SELECT k.*, r.bibtex_key
        FROM key_measurement k
        JOIN stage s ON s.stage_id = k.stage_id
        LEFT JOIN reference_data r ON r.id = k.reference_id
        WHERE s.stage_code = $1
        ORDER BY k.display_order, k.measurement_id
    `, [stage_code]);
    return res.rows;
};

// Every stage's measurements in one round trip, keyed by stage_code. The lifecycle
// table renders up to 11 stages at once, so fetching per stage would mean 11 requests.
const getAllKeyMeasurements = async () => {
    // Measurements with no protocol (Image, Fruit quality) fall back to the 'other'
    // category so every row can be grouped, and rows come back already sorted by
    // category display order -- the cell and the drawer group without re-sorting.
    const res = await pool.query(`
        SELECT s.stage_code,
               s.stage_name,
               k.measurement_id,
               k.measurement_name,
               k.unit,
               k.value_range,
               k.display_order,
               k.origin,
               k.protocol_id,
               COALESCE(c.category_key, 'other')                     AS category_key,
               COALESCE(c.short_label, 'Other')                      AS category_label,
               COALESCE(c.full_name, 'Not covered by a Table S4B protocol') AS category_full,
               COALESCE(c.display_order, 99)                         AS category_order
        FROM key_measurement k
        JOIN stage s ON s.stage_id = k.stage_id
        LEFT JOIN measurement_protocol p ON p.protocol_id = k.protocol_id
        LEFT JOIN measurement_category c ON c.category_id = p.category_id
        ORDER BY s.stage_code, COALESCE(c.display_order, 99), k.display_order, k.measurement_id
    `);

    const byStage = {};
    for (const row of res.rows) {
        (byStage[row.stage_code] = byStage[row.stage_code] || []).push(row);
    }
    return byStage;
};

const getProtocolById = async (protocol_id) => {
    const res = await pool.query(`
        SELECT p.*,
          c.category_key,
          c.short_label AS category_label,
          c.full_name   AS category_full,
          COALESCE((
            SELECT json_agg(json_build_object(
                     'bibtex_key', r.bibtex_key, 'title', r.title, 'author', r.author,
                     'year', r.year, 'publisher', r.publisher, 'url', r.url,
                     'source_type', r.source_type) ORDER BY r.year NULLS LAST)
            FROM protocol_reference pr
            JOIN reference_data r ON r.id = pr.reference_id
            WHERE pr.protocol_id = p.protocol_id
          ), '[]'::json) AS references,
          COALESCE((
            SELECT json_agg(json_build_object(
                     'stage_code', s.stage_code, 'stage_name', s.stage_name)
                   ORDER BY s.stage_id)
            FROM protocol_stage ps
            JOIN stage s ON s.stage_id = ps.stage_id
            WHERE ps.protocol_id = p.protocol_id
          ), '[]'::json) AS stages
        FROM measurement_protocol p
        LEFT JOIN measurement_category c ON c.category_id = p.category_id
        WHERE p.protocol_id = $1
    `, [protocol_id]);
    return res.rows[0] || null;
};

// The protocol a given key measurement points at, resolved in one hop so the UI can
// link from a measurement without knowing its protocol id up front.
const getProtocolByMeasurementId = async (measurement_id) => {
    const res = await pool.query(
        'SELECT protocol_id FROM key_measurement WHERE measurement_id = $1', [measurement_id]);
    if (!res.rows[0] || !res.rows[0].protocol_id) return null;
    return getProtocolById(res.rows[0].protocol_id);
};

const getAllOperationByStageCode = async (stage_code) => {
    const result = await pool.query(`
      SELECT
        o.section,
        o.subsection,
        o.description,
        o.status,
        json_agg(
          json_build_object(
            'third_party_database', g.third_party_database,
            'link', g.link,
            'page_number', g.page_number
          )
        ) AS references
      FROM operation o
      JOIN stage s ON o.stage_id = s.stage_id
      LEFT JOIN guidereference g ON g.operation_id = o.operation_id
      WHERE s.stage_code = $1
      GROUP BY o.operation_id, o.section, o.subsection, o.description, o.status
      -- confirmed rows first within a subsection, so proposed additions read as
      -- additions rather than replacements
      ORDER BY o.section, o.subsection, o.status DESC, o.operation_id
    `, [stage_code]);
  
    return result.rows;
  };
  


  const getAllGeneralOperationByStageCode = async (stage_code) => {
    const result = await pool.query(`
      SELECT o.*, r.bibtex_key
      FROM general_operation o
      JOIN stage s ON s.stage_id = o.stage_id
      LEFT JOIN reference_data r ON r.id = o.reference_id
      WHERE s.stage_code = $1
    `, [stage_code]);

    return result.rows;
  };
  








// These four used a `db` object that was never defined and a pg-promise API this
// project does not use, so every POST returned 500. Rewritten against the pg pool.
const getOrInsertStage = async (stage_code) => {
    const existing = await pool.query(
        'SELECT stage_id FROM stage WHERE stage_code = $1', [stage_code]);
    if (existing.rows[0]) return existing.rows[0];

    const inserted = await pool.query(
        'INSERT INTO stage(stage_code) VALUES($1) RETURNING stage_id', [stage_code]);
    return inserted.rows[0];
};

const insertTiming = async (data) => {
    await pool.query(
        `INSERT INTO timing (stage_id, reference_id, timing_type, description, reference_timing, reference_timing_distance)
         VALUES ($1, $2, $3, $4, $5, $6)`,
        [data.stage_id, data.reference_id, data.timing_type, data.description, data.reference_timing, data.reference_distance]
    );
};

const insertObservation = async (data) => {
    await pool.query(
        `INSERT INTO observation (stage_id, reference_id, description, item, value)
         VALUES ($1, $2, $3, $4, $5)`,
        [data.stage_id, data.reference_id, data.description, data.item, data.value]
    );
};

const insertMeasurement = async (data) => {
    await pool.query(
        `INSERT INTO key_measurement (stage_id, reference_id, measurement_name, unit, value_range, calculation_method)
         VALUES ($1, $2, $3, $4, $5, $6)`,
        [data.stage_id, data.reference_id, data.measurement_name, data.unit, data.value_range, data.calculation_method]
    );
};



module.exports = {
    getAllTimingByStageCode,
    getAllObservationsByStageCode,
    getAllKeyMeasurementsByStageCode,
    getAllKeyMeasurements,
    getProtocolById,
    getProtocolByMeasurementId,
    getAllOperationByStageCode,
    getAllGeneralOperationByStageCode,
    getAllTiming,
    getOrInsertStage,
    insertTiming,
    insertObservation,
    insertMeasurement
};