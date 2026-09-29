// Keyword search over what the portal itself shows: every stage's management cards
// and key measurements, as the stage endpoints serve them (regional guides, overlay
// and card placement already applied). It needs nothing beyond the portal's own
// tables and data files, so it works wherever the portal runs.
const pool = require('../config/db');
const { getAllOperationByStageCode, getAllKeyMeasurements } = require('./naturalModel');

const TTL_MS = 10 * 60 * 1000;
const MAX_RESULTS = 60;
let cached = null;

const norm = text => String(text || '').toLowerCase().replace(/[^\p{L}\p{N}]+/gu, ' ').trim();

async function buildIndex() {
    // On a deploy the SQL sequence is still rebuilding the tables when the server
    // starts taking requests; indexing before it finishes would cache half a portal.
    await pool.ready;
    const stages = (await pool.query('SELECT stage_code, stage_name FROM stage ORDER BY stage_id')).rows;
    const stageName = Object.fromEntries(stages.map(s => [s.stage_code, s.stage_name]));
    const entries = [];

    for (const { stage_code } of stages) {
        let ops;
        try {
            ops = await getAllOperationByStageCode(stage_code);
        } catch (error) {
            console.warn(`Search index: skipped ${stage_code}:`, error.message);
            continue;
        }
        for (const op of ops) {
            const title = (op.subsection && op.subsection.toLowerCase() !== 'general') ? op.subsection : op.section;
            entries.push({
                kind: 'operation',
                stage_code,
                stage_name: stageName[stage_code],
                section: op.section,
                title,
                summary: op.summary || '',
                titleText: norm(title),
                // A general point carries the cards it covers, so each stays searchable.
                text: norm([op.section, op.subsection, op.summary, op.description,
                    ...(op.items || []).map(item => [item.subsection, item.summary, item.description].join(' '))].join(' '))
            });
        }
    }

    const byStage = await getAllKeyMeasurements();
    for (const [stage_code, rows] of Object.entries(byStage)) {
        for (const m of rows) {
            entries.push({
                kind: 'measurement',
                stage_code,
                stage_name: stageName[stage_code] || m.stage_name,
                section: m.category_label || 'Key measurement',
                title: m.measurement_name,
                summary: '',
                protocol_id: m.protocol_id || null,
                titleText: norm(m.measurement_name),
                text: norm([m.measurement_name, m.category_full].join(' '))
            });
        }
    }
    return { at: Date.now(), entries };
}

async function index() {
    if (!cached || Date.now() - cached.at > TTL_MS) {
        cached = buildIndex().catch(error => { cached = null; throw error; });
    }
    return (await cached).entries;
}

// Every word of the query has to appear. Title matches rank first, then the
// whole phrase anywhere, then the rest; stage order breaks ties.
async function searchPortal(query) {
    const q = norm(query);
    if (q.length < 2) return { total: 0, results: [] };
    const words = q.split(' ');
    const hits = [];
    (await index()).forEach((entry, order) => {
        if (!words.every(word => entry.text.includes(word))) return;
        const score = (entry.titleText.includes(q) ? 0 : words.every(w => entry.titleText.includes(w)) ? 1 : entry.text.includes(q) ? 2 : 3);
        hits.push({ entry, score, order });
    });
    hits.sort((a, b) => a.score - b.score || a.order - b.order);
    return {
        total: hits.length,
        results: hits.slice(0, MAX_RESULTS).map(({ entry }) => {
            const { titleText, text, ...shown } = entry;
            return shown;
        })
    };
}

// Build once in the background so the first visitor does not wait for it.
function warmSearchIndex() {
    index().catch(error => console.warn('Search index not built yet:', error.message));
}

module.exports = { searchPortal, warmSearchIndex };
