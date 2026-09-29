// Final placement and display layer for operation cards.
//
// Cards reach a stage from many sources (the operation table, the regional guides,
// the curated lifecycle and the discoverability overlay). Each card was reviewed one
// by one for the stage a grower would look in (2026-09-28 card review); the moves and
// the one-line summaries shown on the page live in cardPlacement.json, keyed by a hash
// of the card's section, subsection and description, so they apply whatever source
// the card came from.
const fs = require('fs');
const crypto = require('crypto');
const dataPath = require.resolve('../data/cardPlacement.json');
const outlinePath = require.resolve('../data/stageOutline.json');
const supplementPath = require.resolve('../data/supplementaryTables.json');
const pageSummaryPath = require.resolve('../data/pageSummaries.json');

// The table shows each section as a few general points; the cards a point covers
// are listed inside its Details. stageOutline.json: stage -> section -> points,
// each { label, text, members: [card keys] }.
let outlineCache;
function outline() {
    const mtime = fs.statSync(outlinePath).mtimeMs;
    if (!outlineCache || outlineCache.mtime !== mtime) {
        outlineCache = { mtime, data: JSON.parse(fs.readFileSync(outlinePath, 'utf8')),
            supplement: JSON.parse(fs.readFileSync(supplementPath, 'utf8')),
            pageSummaries: JSON.parse(fs.readFileSync(pageSummaryPath, 'utf8')) };
    }
    return outlineCache;
}

let cached;
function placement() {
    const mtime = fs.statSync(dataPath).mtimeMs;
    if (!cached || cached.mtime !== mtime) {
        const data = JSON.parse(fs.readFileSync(dataPath, 'utf8'));
        const out = new Map();
        const into = new Map();
        for (const move of data.moves || []) {
            out.set(`${move.from}|${move.key}`, move.to);
            if (!into.has(move.to)) into.set(move.to, []);
            into.get(move.to).push(move);
        }
        cached = { mtime, out, into, folds: data.folds || [], summaries: data.summaries || {} };
    }
    return cached;
}

const itemKey = item => crypto.createHash('sha1')
    .update(`${item.subsection}|${String(item.description || '').trim()}`).digest('hex').slice(0, 12);

const cardKey = op => crypto.createHash('sha1')
    .update(`${op.section}|${op.subsection}|${String(op.description || '').trim()}`)
    .digest('hex').slice(0, 12);

// stageCode: the stage being served; ops: its cards as the sources place them;
// rawOps(code): the same source-placed list for any other stage.
function mergeReferencesInto(target, card) {
    const seen = new Set((target.references || []).map(ref => JSON.stringify(ref)));
    target.references = [...(target.references || []),
        ...(card.references || []).filter(ref => !seen.has(JSON.stringify(ref)))];
}

async function applyCardPlacement(stageCode, ops, rawOps) {
    const p = placement();
    // The same card can reach one stage twice -- from two sources, or from two old
    // stage codes that now share a code. It shows once, with both sets of sources.
    const present = new Map();
    const kept = [];
    for (const op of ops) {
        const key = cardKey(op);
        if (p.out.has(`${stageCode}|${key}`)) continue;
        if (present.has(key)) { mergeReferencesInto(present.get(key), op); continue; }
        present.set(key, op);
        kept.push(op);
    }
    const bySource = new Map();
    for (const move of p.into.get(stageCode) || []) {
        if (!bySource.has(move.from)) bySource.set(move.from, await rawOps(move.from));
        const card = bySource.get(move.from).find(op => cardKey(op) === move.key);
        if (!card) continue;
        const same = present.get(move.key);
        if (same) {
            mergeReferencesInto(same, card);
        } else {
            const copy = { ...card };
            kept.push(copy);
            present.set(move.key, copy);
        }
    }
    // Source-only cards are not listed on their own: their sources move into the
    // Details of the card named by `into`, labelled with the folded card's topic.
    for (const fold of p.folds) {
        const host = present.get(fold.into);
        if (!host) continue;
        for (const key of fold.keys) {
            const card = present.get(key);
            if (!card || card === host) continue;
            const refs = (card.references || []).map(ref => fold.label
                ? { ...ref, page_number: [card.subsection, ref.page_number].filter(Boolean).join(' — ') }
                : ref);
            mergeReferencesInto(host, { references: refs });
            kept.splice(kept.indexOf(card), 1);
            present.delete(key);
        }
    }
    for (const op of kept) {
        const summary = p.summaries[cardKey(op)];
        if (summary) op.summary = summary;
    }
    return groupByOutline(stageCode, kept);
}

// Replace the cards a point covers with one general line, placed where the first
// of them stood. A card not named in the outline keeps its own line.
// Two texts say the same thing when their words mostly coincide (the PDF and a
// card often differ only by a word or two, e.g. "adding topsoil to flatter" /
// "adding topsoil to create flatter").
const words = text => new Set(String(text || '').toLowerCase().match(/[a-z0-9]+/g) || []);
function sameText(a, b) {
    const x = words(a), y = words(b);
    if (!x.size || !y.size) return false;
    let shared = 0;
    for (const w of x) if (y.has(w)) shared++;
    // One text contained in the other (the PDF often adds "as outlined in the
    // cited guide") counts as the same.
    return Math.min(x.size, y.size) >= 4 && shared / Math.min(x.size, y.size) >= 0.85;
}
function mergeRefs(a, b) {
    const seen = new Set((a || []).map(ref => JSON.stringify(ref)));
    return [...(a || []), ...(b || []).filter(ref => !seen.has(JSON.stringify(ref)))];
}

function groupByOutline(stageCode, ops) {
    const { data, supplement } = outline();
    const sections = data[stageCode];
    if (!sections) return ops;
    // The researcher's supplementary table for this stage: its lines ("pdf" points)
    // come first in each section, in the table's order, and some sections carry the
    // table's own heading (e.g. "Fumigate" for Disease management at ODG00).
    const table = (supplement.stages || {})[stageCode] || {};
    const headings = table.headings || {};
    const pdfSource = number => {
        const ref = (supplement.references || {})[number];
        return ref ? { third_party_database: ref.title, link: ref.url || '', page_number: '', bibtex_key: ref.bibtex_key } : null;
    };
    // A source is either one of the PDF's numbered references or a reference object.
    const sourcesOf = entry => [...(entry.refs || []).map(pdfSource), ...(entry.sources || [])].filter(Boolean);
    // Citations checked one by one against their sources (2026-09-29): a wrong page
    // or link is replaced; a source that does not hold the item is swapped for the
    // source that does, or dropped when the item has other sources.
    const refFixes = new Map((supplement.ref_fixes || []).map(f => [`${f.source}|${f.page}|${f.link}|${f.item}`, f]));
    const fixRefs = (refs, label) => {
        const out = [];
        for (const ref of refs || []) {
            const f = ref && (refFixes.get(`${ref.third_party_database || ''}|${ref.page_number || ''}|${(ref.link || '').split('#')[0]}|${label}`)
                || refFixes.get(`${ref.third_party_database || ''}|${ref.page_number || ''}||${label}`));
            if (!f) { out.push(ref); continue; }
            if (f.action === 'fix') out.push({ ...ref, page_number: f.new_page || ref.page_number, link: f.new_link || ref.link });
            else if (f.action === 'replace') out.push({ third_party_database: f.alt_source || ref.third_party_database,
                link: f.alt_link || ref.link, page_number: f.alt_page || '' });
            else if (f.action === 'drop') continue;
        }
        return (out.length ? out : refs).map(ref => newestEdition(ref, label));
    };
    // Each manual is cited in its newest edition only: an older edition's page is
    // replaced by the same information's page in the newest one, and the several
    // names a manual was cited under become one.
    const editionMap = new Map((supplement.editions || []).map(e => [`${e.source}|${e.page}|${e.item}`, e]));
    const renames = supplement.source_names || {};
    function newestEdition(ref, label) {
        if (!ref) return ref;
        const e = editionMap.get(`${ref.third_party_database || ''}|${ref.page_number || ''}|${label}`);
        let out = e ? { ...ref, third_party_database: e.new_source, link: e.new_link, page_number: e.new_page || ref.page_number } : ref;
        const r = renames[out.third_party_database || ''];
        if (r) out = { ...out, third_party_database: r.name, link: r.link || out.link };
        return out;
    }
    // A card that came without any source carries the one found for it.
    // (looked up by card, so a card moved to another stage keeps its source)
    const cardSources = Object.assign({}, ...Object.values(supplement.card_sources || {}),
        (supplement.card_sources || {})[stageCode] || {});
    const referencesOf = (op, section) => {
        const own = (op.references || []).filter(ref => ref && (ref.third_party_database || ref.link));
        const found = cardSources[cardKey({ ...op, section })];
        return fixRefs(own.length || !found ? (op.references || []) : sourcesOf(found), op.subsection);
    };
    const purposes = table.purposes || {};
    const additions = (supplement.detail_additions || []).filter(a => a.stage === stageCode);
    // Corrected wording for a card that carried a clear error (the card keeps its
    // identity; only what is shown changes).
    const cardText = (supplement.card_text || {})[stageCode] || {};
    const textOf = (op, section) => cardText[cardKey({ ...op, section })] || op.description || '';
    const byKey = new Map(ops.map(op => [`${op.section}|${cardKey(op)}`, op]));
    const covered = new Set();
    const out = [];
    for (const [section, points] of Object.entries(sections)) {
        for (const point of points) {
            const members = point.members.map(key => byKey.get(`${section}|${key}`)).filter(Boolean);
            if (!members.length && !point.pdf) continue;
            members.forEach(op => covered.add(op));
            const items = members.map(op => ({ subsection: op.subsection, summary: op.summary || '',
                description: textOf(op, section), status: op.status, references: referencesOf(op, section) }));
            // A PDF line opens its Details with its full wording and its source; lines
            // of the PDF printed under another stage but belonging here follow the cards.
            if (point.pdf) {
                const pdfItem = { subsection: point.label, summary: '', description: point.pdf_text || point.text,
                    status: 'confirmed', pdf: true, references: fixRefs(sourcesOf(point), point.label) };
                // A card that already says the same thing as the PDF line stands for it,
                // so the wording is not listed twice; the card keeps both sets of sources.
                const same = items.find(item => sameText(item.description, pdfItem.description));
                if (same) same.references = mergeRefs(same.references, pdfItem.references);
                else items.unshift(pdfItem);
            }
            // Knowledge added to an existing line's Details (the table line is unchanged).
            for (const add of additions.filter(a => a.section === section && a.line === point.label)) {
                items.push({ subsection: add.item, summary: add.summary || '', description: add.text,
                    status: 'confirmed', references: add.references });
            }
            for (const line of point.moved || []) {
                items.push({ subsection: line.label, summary: '', description: line.text,
                    status: 'confirmed', pdf: true, references: fixRefs(sourcesOf(line), line.label) });
            }
            const references = [];
            const seen = new Set();
            for (const ref of items.flatMap(item => item.references)) {
                const id = JSON.stringify(ref);
                if (!seen.has(id)) { seen.add(id); references.push(ref); }
            }
            out.push({
                section, section_heading: headings[section], section_purposes: purposes[section],
                subsection: point.label, summary: point.text,
                description: '', pdf: !!point.pdf,
                status: point.pdf || members.some(op => op.status !== 'proposed') ? 'confirmed' : 'proposed',
                references, items
            });
        }
    }
    // A table built on the supplementary PDF keeps the PDF's lines as they are;
    // what the portal adds to a section shows as one general line naming what is
    // inside, and its Details lists each added topic with its own cards.
    const extras = table.extras || {};
    const collapsed = [];
    for (const [section, extra] of Object.entries(extras)) {
        const added = out.filter(op => op.section === section && !op.pdf);
        if (added.length < 2) continue;
        // One to three lines per section, each standing for the added topics it
        // covers (an older single line covers them all).
        const lines = Array.isArray(extra) ? extra : [{ ...extra, covers: added.map(op => op.subsection) }];
        for (const line of lines) {
            const covered = added.filter(op => (line.covers || []).includes(op.subsection));
            if (!covered.length) continue;
            const references = [...new Map(covered.flatMap(op => op.references)
                .map(ref => [JSON.stringify(ref), ref])).values()];
            collapsed.push({ added: covered, line: {
                section, section_heading: headings[section], section_purposes: purposes[section],
                subsection: line.label, summary: line.text, description: '',
                status: covered.some(op => op.status !== 'proposed') ? 'confirmed' : 'proposed',
                references,
                items: covered.length === 1 ? covered[0].items
                    : covered.flatMap(op => op.items.map(item => ({ ...item, group: { label: op.subsection, text: op.summary } })))
            } });
        }
    }
    for (const { added, line } of collapsed) {
        out.splice(out.indexOf(added[0]), 0, line);
        for (const op of added) out.splice(out.indexOf(op), 1);
    }
    // A card the outline does not name keeps its own line, after the outlined ones.
    const result = [...out, ...ops.filter(op => !covered.has(op))];
    // What the cited page covers for an item, for sources that carry only a page number.
    const { pageSummaries } = outline();
    for (const op of result) {
        for (const item of op.items || []) {
            const summary = pageSummaries[itemKey(item)];
            if (summary) item.page_summary = summary;
        }
    }
    return result;
}

module.exports = { applyCardPlacement, cardKey };
