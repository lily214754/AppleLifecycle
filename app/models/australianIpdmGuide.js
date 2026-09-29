const guide = require('../data/australianIpdmGuide.json');
const { mergeReferences } = require('./southeastGuide');
const normalise = value => String(value || '').normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLowerCase().replace(/[^a-z0-9]/g, '');

function mergeAustralianIpdmOperations(stageCode, existing) {
    const result = existing.map(row => ({ ...row, references: [...(row.references || [])] }));
    for (const topic of guide.operations) {
        if (!topic.stage_codes.includes(stageCode)) continue;
        const names = [topic.subsection, ...topic.aliases].map(normalise);
        const candidates = result.filter(row => normalise(row.section) === normalise(topic.section) && names.includes(normalise(row.subsection)));
        const match = candidates.find(row => normalise(row.subsection) === normalise(topic.subsection)) || candidates[0];
        if (match) match.references = mergeReferences(match.references, topic.references);
        else result.push({ section: topic.section, subsection: topic.subsection,
            description: topic.description, status: topic.status, references: topic.references });
    }
    return result;
}

function enrichAustralianIpdmProtocol(protocol) {
    if (!protocol) return protocol;
    const groups = guide.protocols.filter(item => item.protocol_id === Number(protocol.protocol_id));
    if (!groups.length) return protocol;
    const result = { ...protocol, references: [...(protocol.references || [])],
        guide_supplements: (protocol.guide_supplements || []).map(item => ({ ...item, references: [...item.references] })) };
    for (const group of groups) {
        const match = result.guide_supplements.find(item => group.supplement_title && normalise(item.title) === normalise(group.supplement_title));
        if (match) match.references = mergeReferences(match.references, group.references);
        else result.references = mergeReferences(result.references, group.references);
    }
    return result;
}
module.exports = { mergeAustralianIpdmOperations, enrichAustralianIpdmProtocol };
