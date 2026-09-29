const replacement = require('../data/oregonEditionReplacement.json');
const { mergeReferences } = require('./southeastGuide');
const oldSource = r => [r.link, r.url].some(url => String(url || '').split('#')[0].split('?')[0] === replacement.old_url);
function replaceOregonEditionOperations(rows) {
    return rows.map(row => {
        if (!(row.references || []).some(oldSource)) return row;
        const references = row.references.filter(r => !oldSource(r));
        return { ...row, references: mergeReferences(references, replacement.topics[row.subsection] || []) };
    });
}
function replaceOregonBibliography(ref) {
    if (!ref || !oldSource(ref)) return ref;
    // A whole-publication reference has no content-specific page claim.
    const out = { ...ref, title: replacement.title, third_party_database: replacement.title,
        url: replacement.new_url, link: replacement.new_url, year: 2026,
        edition: replacement.edition, page_number: null, note: null };
    if ('bibtex_entry' in out) out.bibtex_entry = null;
    if ('pdf_url' in out) delete out.pdf_url;
    return out;
}
function replaceOregonEditionProtocol(protocol) {
    if (!protocol) return protocol;
    return { ...protocol, references: (protocol.references || []).map(replaceOregonBibliography),
        guide_supplements: (protocol.guide_supplements || []).map(item => ({ ...item,
            references: item.references.map(replaceOregonBibliography) })) };
}
module.exports = { replaceOregonEditionOperations, replaceOregonEditionProtocol, replaceOregonBibliography };
