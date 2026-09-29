const guide = require('../data/pennStateGuide.json');
const normalise = value => String(value || '').normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLowerCase().replace(/[^a-z0-9]/g, '');
const referenceKey = ref => `${ref.link || ref.url}\0${ref.page_number || ''}\0${ref.note || ''}`;
function mergeReferences(existing = [], added = []) {
    const seen = new Set();
    return [...existing, ...added].filter(ref => {
        const key = referenceKey(ref);
        if (seen.has(key)) return false;
        seen.add(key); return true;
    });
}
function mergePennStateOperations(stageCode, existing) {
    let result = existing.map(row => ({ ...row, references: [...(row.references || [])] }));
    for (const topic of guide.operations) {
        const names = [topic.subsection, ...topic.aliases].map(normalise);
        const matches = result.filter(row => normalise(row.section) === normalise(topic.section) && names.includes(normalise(row.subsection)));
        // Named topics already present at this stage retain their wording and receive the source.
        // New topics appear only in the explicitly reviewed stage list.
        if (matches.length) {
            for (const row of matches) row.references = mergeReferences(row.references, topic.references);
        } else if (topic.stage_codes.includes(stageCode)) {
            result.push({ section: topic.section, subsection: topic.subsection,
                description: topic.description, status: topic.status, references: topic.references });
        }
    }
    return result;
}
function enrichPennStateProtocol(protocol) {
    if (!protocol) return protocol;
    const supplements = guide.protocols.filter(item => item.protocol_id === Number(protocol.protocol_id));
    if (!supplements.length) return protocol;
    const stages = [...(protocol.stages || [])];
    for (const item of measurements.filter(item => item.protocol_id === Number(protocol.protocol_id))) {
        for (const code of item.stages) if (!stages.some(stage => stage.stage_code === code)) {
            stages.push({ stage_code: code, stage_name: code === 'OAR90' ? 'Shoot growth completed' : 'Fruit maturity and preharvest assessment' });
        }
    }
    return { ...protocol, stages, guide_supplements: supplements };
}
const measurements = [
    { protocol_id: 19, measurement_name: 'Shoot length', unit: 'cm', category_key: 'tree-vigour-trunk-and-shoot-growth', category_label: 'Tree vigour & growth', category_order: 50, stages: ['OAR80', 'OAR81', 'OAR82', 'OAR90'] },
    { protocol_id: 73, measurement_name: 'Fruit-peel N/Ca ratio', unit: 'ratio', category_key: 'fruit-internal-chemical-traits-and-matur', category_label: 'Fruit chemistry & maturity', category_order: 140, stages: ['OAR80', 'OAR81', 'OAR82'] }
];
function mergePennStateMeasurements(stageCode, existing) {
    const result = [...existing];
    for (const item of measurements) {
        if (!item.stages.includes(stageCode)) continue;
        if (result.some(row => normalise(row.measurement_name) === normalise(item.measurement_name))) continue;
        const { stages, ...fields } = item;
        result.push({ ...fields, stage_code: stageCode, measurement_id: -(100000 + item.protocol_id * 100 + Number(stageCode.slice(3))), display_order: 900 + item.protocol_id, origin: 'Penn State guide', category_full: item.category_label });
    }
    return result;
}
function pennStateMeasurementProtocol(measurementId) {
    for (const item of measurements) for (const stage of item.stages) {
        if (Number(measurementId) === -(100000 + item.protocol_id * 100 + Number(stage.slice(3)))) return item.protocol_id;
    }
    return null;
}
module.exports = { mergePennStateOperations, enrichPennStateProtocol, mergePennStateMeasurements, pennStateMeasurementProtocol };
