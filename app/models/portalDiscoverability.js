const fs = require('fs');
const dataPath = require.resolve('../data/portalDiscoverability.json');
let cached;
function guide() {
    const mtime = fs.statSync(dataPath).mtimeMs;
    if (!cached || cached.mtime !== mtime) {
        cached = { mtime, data: JSON.parse(fs.readFileSync(dataPath, 'utf8')) };
    }
    return cached.data;
}
const { mergeReferences } = require('./southeastGuide');
const normalise = value => String(value || '').normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLowerCase().replace(/[^a-z0-9]/g, '');

const path = require('path');
const kbAssets = path.join(__dirname, '../data/kb/assets');
const assetSeen = new Map();
function localAssetAvailable(value) {
    const m = /^\/api\/kb\/assets\/([^#?]+)/.exec(String(value || ''));
    if (!m) return true;
    const rel = decodeURIComponent(m[1]);
    if (!assetSeen.has(rel)) assetSeen.set(rel, fs.existsSync(path.join(kbAssets, rel)));
    return assetSeen.get(rel);
}

// Add reviewed, source-backed topic summaries to the existing guide, keeping
// the same stage/topic identity and all previously available references.
function mergeDiscoverabilityOperations(stageCode, existing) {
    const data = guide();
    const result = existing.map(row => ({ ...row, references: mergeReferences([], (row.references || []).map(ref => {
        const replacement = (data.reference_replacements || []).find(item =>
            [ref.link, ref.url].some(url => url === item.old_url));
        return replacement ? { ...replacement.reference } : ref;
    })) }));
    for (const topic of data.operations) {
        if (!topic.stage_codes.includes(stageCode)) continue;
        const names = [topic.subsection, ...(topic.aliases || [])].map(normalise);
        const candidates = result.filter(row => normalise(row.section) === normalise(topic.section) && names.includes(normalise(row.subsection)));
        const match = candidates.find(row => normalise(row.subsection) === normalise(topic.subsection)) || candidates[0];
        if (match) {
            match.references = mergeReferences(match.references, topic.references);
            if (topic.description_addendum && !(match.description || '').includes(topic.description_addendum)) {
                match.description = [match.description, topic.description_addendum].filter(Boolean).join(' ');
            }
        } else {
            const description = topic.description_addendum && !(topic.description || '').includes(topic.description_addendum)
                ? [topic.description, topic.description_addendum].filter(Boolean).join(' ')
                : topic.description;
            result.push({ section: topic.section, subsection: topic.subsection,
                description, status: topic.status, references: mergeReferences([], topic.references) });
        }
    }
    // Display corrections: official source names for references imported with
    // URL-slug or file-name titles, and clearer names for renamed topics.
    const urlKey = value => String(value || '').split('#')[0].replace(/\/+$/, '');
    const names = new Map((data.reference_titles || []).map(item => [urlKey(item.url), item.name]));
    const renames = data.subsection_renames || {};
    // References that point at the portal's own copy of a PDF link to the
    // publisher's public page or file instead.
    const publicUrls = data.kb_asset_public_urls || {};
    const publicUrl = value => {
        const m = /^\/api\/kb\/assets\/pdf\/([0-9a-f]+)\/[^#]*(#page=\d+)?/.exec(String(value || ''));
        const url = m && publicUrls[m[1]];
        // A page anchor still applies when the public copy is the same PDF file.
        return url && m[2] && /\.pdf$/i.test(url) ? url + m[2] : url;
    };
    // A guide whose web page now shows a newer edition: cite the edition the page
    // numbers come from by name, and open that edition's PDF at the cited page.
    const editions = data.edition_sources || [];
    const citeEdition = ref => {
        const edition = editions.find(e => [ref.link, ref.url].some(u => e.urls.includes(urlKey(u))));
        if (!edition) return ref;
        const printed = /^\s*(?:pp?\.|pages?)\s*(\d+)/i.exec(String(ref.page_number || ''));
        const physical = /#page=(\d+)/.exec(String(ref.pdf_url || ref.link || ''));
        const page = printed ? Number(printed[1]) + edition.page_offset : physical && Number(physical[1]);
        const link = page ? `${edition.pdf}#page=${page}` : edition.pdf;
        return { ...ref, third_party_database: edition.name, title: edition.name, link, url: link };
    };
    for (const row of result) {
        if (renames[row.subsection]) row.subsection = renames[row.subsection];
        row.references = (row.references || []).map(ref => {
            const name = names.get(urlKey(ref.link || ref.url));
            const out = name ? { ...ref, third_party_database: name, title: name } : { ...ref };
            const link = publicUrl(out.link);
            if (link) out.link = link;
            const url = publicUrl(out.url);
            if (url) out.url = url;
            return citeEdition(out);
        // A link to the portal's own copy of a PDF only works where the KB files are
        // present; elsewhere (the Heroku deploy) it would be a dead link, so the
        // reference is left out and the card keeps its public sources.
        }).filter(ref => localAssetAvailable(ref.link) && localAssetAvailable(ref.url));
    }
    return result;
}
module.exports = { mergeDiscoverabilityOperations };
