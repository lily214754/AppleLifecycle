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
    const res = await pool.query(`
        SELECT k.*, r.bibtex_key
        FROM key_measurement k
        JOIN stage s ON s.stage_id = k.stage_id
        JOIN reference_data r ON r.id = k.reference_id
        WHERE s.stage_code = $1
    `, [stage_code]);
    return res.rows;
};

const getAllOperationByStageCode = async (stage_code) => {
    const result = await pool.query(`
      SELECT 
        o.section,
        o.subsection,
        o.description,
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
      GROUP BY o.operation_id, o.section, o.subsection, o.description
      ORDER BY o.section, o.subsection
    `, [stage_code]);
  
    return result.rows;
  };
  


  const getAllGeneralOperationByStageCode = async (stage_code) => {
    const result = await pool.query(`
      SELECT *
      FROM general_operation o
      JOIN stage s ON o.general_operation_id = s.stage_id
      JOIN reference_data r ON o.id = k.reference_id
      WHERE s.stage_code = $1
    `, [stage_code]);
  
    return result.rows;
  };
  








const getOrInsertStage = async (stage_code) => {
    const existing = await db.oneOrNone('SELECT stage_id FROM stage WHERE stage_code = $1', [stage_code]);
    if (existing) return existing;

    return await db.one('INSERT INTO stage(stage_code) VALUES($1) RETURNING stage_id', [stage_code]);
};

const insertTiming = async (data) => {
    await db.none(
        `INSERT INTO timing (stage_id, reference_id, timing_type, description, reference_timing, reference_timing_distance)
         VALUES ($1, $2, $3, $4, $5, $6)`,
        [data.stage_id, data.reference_id, data.timing_type, data.description, data.reference_timing, data.reference_distance]
    );
};

const insertObservation = async (data) => {
    await db.none(
        `INSERT INTO observation (stage_id, reference_id, description, item, value)
         VALUES ($1, $2, $3, $4, $5)`,
        [data.stage_id, data.reference_id, data.description, data.item, data.value]
    );
};

const insertMeasurement = async (data) => {
    await db.none(
        `INSERT INTO key_measurement (stage_id, reference_id, measurement_name, unit, value_range, calculation_method)
         VALUES ($1, $2, $3, $4, $5, $6)`,
        [data.stage_id, data.reference_id, data.measurement_name, data.unit, data.value_range, data.calculation_method]
    );
};



module.exports = {
    getAllTimingByStageCode,
    getAllObservationsByStageCode,
    getAllKeyMeasurementsByStageCode,
    getAllOperationByStageCode,
    getAllGeneralOperationByStageCode,
    getAllTiming,
    getOrInsertStage,
    insertTiming,
    insertObservation,
    insertMeasurement
};