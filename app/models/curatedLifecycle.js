const operations = require('../data/curatedLifecycleOperations.json');

// Only editorially reviewed summaries enter the original guide. Raw KB records
// are never expanded into operation rows by this adapter.
function mergeCuratedOperations(stageCode, existing) {
    const curated = operations.filter(row => row.stage_code === stageCode);
    const key = row => `${row.section}\u0000${row.subsection}`;
    const replacements = new Map(curated.map(row => [key(row), row]));
    const seen = new Set();
    const result = existing.flatMap(row => {
        const replacement = replacements.get(key(row));
        if (!replacement) return [row];
        if (seen.has(key(row))) return [];
        seen.add(key(row));
        return [replacement];
    });
    return result.concat(curated.filter(row => !seen.has(key(row))));
}

module.exports = { mergeCuratedOperations };
