const guide = require('../data/southeastGuide.json');
const normalise = value => String(value || '').normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLowerCase().replace(/[^a-z0-9]/g, '');
const sourceKey = ref => `${ref.url || ref.link || ''}\0${ref.edition || ''}\0${ref.page_number || ''}`;

// One citation per source edition and page. Preserve both guides and all section locators.
function mergeReferences(existing = [], added = []) {
    const result = existing.map(ref => ({ ...ref }));
    for (const ref of added) {
        const match = result.find(item => sourceKey(item) === sourceKey(ref));
        if (!match) result.push({ ...ref });
        else {
            if (!match.pdf_url && ref.pdf_url) match.pdf_url = ref.pdf_url;
            const notes = new Set([...(match.note || '').split('; '), ...(ref.note || '').split('; ')].filter(Boolean));
            match.note = [...notes].join('; ');
        }
    }
    return result;
}
function mergeSoutheastOperations(stageCode, existing) {
    const result = existing.map(row => ({ ...row, references: [...(row.references || [])] }));
    for (const topic of guide.operations) {
        if (!topic.stage_codes.includes(stageCode)) continue;
        const names = [topic.subsection, ...topic.aliases].map(normalise);
        const candidates = result.filter(row => normalise(row.section) === normalise(topic.section) && names.includes(normalise(row.subsection)));
        // Prefer the canonical topic, then an explicitly reviewed synonym. Never add
        // a second operation just to show a new source or replace existing advice.
        const match = candidates.find(row => normalise(row.subsection) === normalise(topic.subsection)) || candidates[0];
        if (match) match.references = mergeReferences(match.references, topic.references);
        else result.push({ section: topic.section, subsection: topic.subsection,
            description: topic.description, status: topic.status, references: topic.references });
    }
    return result;
}
function enrichSoutheastProtocol(protocol) {
    if (!protocol) return protocol;
    const groups = guide.protocols.filter(item => item.protocol_id === Number(protocol.protocol_id));
    if (!groups.length) return protocol;
    const result = { ...protocol, references: [...(protocol.references || [])],
        guide_supplements: (protocol.guide_supplements || []).map(item => ({ ...item, references: [...item.references] })) };
    for (const group of groups) {
        const existing = result.guide_supplements.find(item => group.supplement_title && normalise(item.title) === normalise(group.supplement_title));
        if (existing) existing.references = mergeReferences(existing.references, group.references);
        else result.references = mergeReferences(result.references, group.references);
    }
    return result;
}
module.exports = { mergeSoutheastOperations, enrichSoutheastProtocol, mergeReferences };
