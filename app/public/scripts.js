// scripts.js
// Reference and Table Popup System
// ===============================================

// Reference link functionality.
//
// These used to be bound per element, and rebound after every navigation because
// initializeCiteReferences() replaced document.body.innerHTML and destroyed them.
// One delegated listener on the document handles links that do not exist yet,
// including links inside popups and the protocol drawer, and never needs rebinding.
document.addEventListener('click', function (event) {
    const referenceLink = event.target.closest && event.target.closest('.reference-link');
    if (referenceLink) {
        event.preventDefault();
        const bibtexKeys = referenceLink.dataset.bibtexKey.split(',');
        fetchReferenceDetails(bibtexKeys, showReferencePopup, referenceLink);
        return;
    }

    const tableLink = event.target.closest && event.target.closest('.table-ref-link');
    if (tableLink) {
        event.preventDefault();
        openTablePopup(tableLink.dataset.table);
        return;
    }

    const measurementLink = event.target.closest && event.target.closest('.measurement-link');
    if (measurementLink) {
        event.preventDefault();
        event.stopPropagation();
        openProtocolDrawer(measurementLink.dataset.protocolId, {
            stageCode: measurementLink.dataset.stageCode,
            measurementId: measurementLink.dataset.measurementId,
            categoryKey: measurementLink.dataset.categoryKey
        });
        return;
    }

    const categoryButton = event.target.closest && event.target.closest('.measurement-category-btn');
    if (categoryButton) {
        event.preventDefault();
        event.stopPropagation();
        openCategoryDrawer(categoryButton.dataset.stageCode, categoryButton.dataset.categoryKey);
    }
});

// Kept because openTablePopup and the templates still call it. Binding now happens
// once, above, so this is intentionally a no-op.
function addReferenceLinkListeners() {}

function fetchReferenceDetails(bibtexKeys, callback, referenceLink) {
    if (!Array.isArray(bibtexKeys)) {
        bibtexKeys = [bibtexKeys];
    }
    
    Promise.all(bibtexKeys.map(bibtexKey => 
        fetch(`/api/reference/${bibtexKey.trim()}`)
            .then(response => {
                if (!response.ok) throw new Error('Network response was not ok');
                return response.json();
            })
    ))
    .then(data => callback(data, referenceLink))
    .catch(error => console.error('Error fetching reference details:', error));
}





function replaceReferences(text) {
    const referenceMap = {};
    let index = 0;

    return text
        .replace(/cite{([^}]+)}/g, (_, bibtexKeys) => {
            const keys = bibtexKeys.split(',').map(k => k.trim());
            return keys.map(key => {
                referenceMap[key] = referenceMap[key] || ++index;
                return `<a href="#" class="reference-link" 
                          data-bibtex-key="${key}">[${referenceMap[key]}]</a>`;
            }).join(' ');
        })
        .replace(/ref{([^}]+)}/g, (_, tableKey) => {
            const cleanKey = tableKey.replace(/\s+/g, '');
            return `<a href="#" class="table-ref-link" 
                      data-table="operation-content${cleanKey}.html">${tableKey}</a>`;
        });
}

// Rewrite cite{...} / ref{...} markers in place.
//
// This used to be `document.body.innerHTML = replaceReferences(document.body.innerHTML)`,
// which reparsed and rebuilt the entire page -- sidebar, search box, breadcrumb and all --
// on every navigation, and it runs several times per navigation. Walking the text nodes
// touches only the text that actually contains a marker, so the rest of the DOM (and every
// listener on it) survives untouched.
function initializeCiteReferences(root) {
    const scope = root || document.getElementById('dataTable') || document.body;
    const referenceMap = {};
    let index = 0;

    function markerToHtml(text) {
        return text
            .replace(/cite\{([^}]+)\}/g, (_, bibtexKeys) =>
                bibtexKeys.split(',').map(key => {
                    key = key.trim();
                    referenceMap[key] = referenceMap[key] || ++index;
                    return `<a href="#" class="reference-link" data-bibtex-key="${key}">[${referenceMap[key]}]</a>`;
                }).join(' '))
            .replace(/ref\{([^}]+)\}/g, (_, tableKey) => {
                const cleanKey = tableKey.replace(/\s+/g, '');
                return `<a href="#" class="table-ref-link" data-table="operation-content${cleanKey}.html">${tableKey}</a>`;
            });
    }

    const walker = document.createTreeWalker(scope, NodeFilter.SHOW_TEXT, {
        acceptNode: node => /(cite|ref)\{/.test(node.nodeValue)
            ? NodeFilter.FILTER_ACCEPT
            : NodeFilter.FILTER_REJECT
    });

    const pending = [];
    while (walker.nextNode()) pending.push(walker.currentNode);

    for (const node of pending) {
        const html = markerToHtml(node.nodeValue);
        if (html === node.nodeValue) continue;
        const fragment = document.createRange().createContextualFragment(html);
        node.parentNode.replaceChild(fragment, node);
    }
}


// Objectives for sections the ODG guides had no row for, written to match the
// wording already used in the guides.
const SECTION_OBJECTIVES = {
  'Fertilization':
    '- Replace the nutrients removed by the crop each season<br>' +
    '- Correct the deficiencies identified by leaf and soil analysis',
  'Nutrient management':
    '- Establish the nutrient status of the soil and the tree before deciding what to apply<br>' +
    '- Track leaf and fruit analysis against the critical concentrations for the cultivar',
  'Soil chemical management':
    '- Bring soil pH into the range the trees need, before planting where possible<br>' +
    '- Identify salinity or chemical contamination before it limits tree growth',
  'Tillage':
    '- Control weeds mechanically where herbicide use is being reduced<br>' +
    '- Maintain soil structure and water movement in the tree row and alleyway',
  'Perform Tillage':
    '- Prepare the soil profile before planting<br>' +
    '- Control weeds mechanically between the rows',
  'Environmental stress management':
    '- Protect buds, flowers and fruit from frost, heat and wind<br>' +
    '- Prepare the block ahead of the season of risk',
  'Pollination':
    '- Ensure enough viable pollen reaches the flowers during the receptive period<br>' +
    '- Protect the pollinators doing the work',
  'Harvest management':
    '- Pick each block at the right maturity for its market and storage plan<br>' +
    '- Handle fruit so it reaches the shed without damage',
  'Post-harvest handling':
    '- Preserve fruit quality and extend storage life<br>' +
    '- Prevent the storage disorders each cultivar is prone to',
  'Irrigation':
    '- Optimal usage of water resources to supply adequate water<br>' +
    '- Maintain suitable soil moisture through the season',
  'Thinning':
    '- Increase fruit size and quality<br>- Control crop load<br>' +
    '- Reduce the incidence of biennial bearing',
  'Pruning & Training':
    '- Prevent the canopy growing out of its allotted space<br>' +
    '- Control canopy density for light interception and spray penetration',
  'Orchard floor management':
    '- Control weeds and alleviate competition between the trees and other plants<br>' +
    '- Prevent soil erosion',
  'Plant growth regulator':
    '- Modify tree growth and fruit characteristics'
};

// Table Popup System
// ===============================================







// The operation guide opens as a centred window on top of the page, and its
// [Details] opens a second window on top of that -- so the guide stays visible
// behind the source you just opened. Only the measurement protocol uses the side
// panel; citations use a card anchored to the link.
function openTablePopup(tableUrl) {
  closeTablePopup();

  function extractStageCode(url) {
      const match = url.match(/operation-content(OAR[^.]+)\.html/);
      return match ? match[1] : null;
  }

  let stageCode = extractStageCode(tableUrl);
  if (tableUrl.includes("operation-contentODG00.html")) stageCode = "ODG00";
  else if (tableUrl.includes("operation-contentODG01.html")) stageCode = "ODG01";
  else if (tableUrl.includes("operation-contentODG02.html")) stageCode = "ODG02";
  // ODG03 has no page of its own and is served the shared shell, so its code has to
  // be recovered here too or the popup opens empty.
  else if (tableUrl.includes("operation-contentODG03.html")) stageCode = "ODG03";

  if (tableUrl.includes("operation-contentOAR")) tableUrl = "operation-contentOAR.html";

  const observationTable = /operation-content(\d+\.\d+\.\d+)\.html/;
  if (observationTable.test(tableUrl)) {
      tableUrl = tableUrl.replace(observationTable, 'table-content$1.html');
  }

  const popup = document.createElement('div');
  popup.className = 'centre-window table-popup';
  popup.innerHTML =
      '<div class="centre-window-card table-content-container">' +
      '<button type="button" class="centre-window-close" aria-label="Close">&times;</button>' +
      '<div class="centre-window-body protocol-table-content">' +
      '<p class="protocol-loading"><span class="loading"></span> Loading table content...</p>' +
      '</div></div>';
  document.body.appendChild(popup);

  const body = popup.querySelector('.centre-window-body');
  popup.querySelector('.centre-window-close').addEventListener('click', closeTablePopup);
  // Clicking the dimmed backdrop closes it, same as the x.
  popup.addEventListener('click', event => { if (event.target === popup) closeTablePopup(); });

  if (stageCode) updateURLWithOpParam(stageCode);
  else updateURLWithObsParam(tableUrl);

  fetch(tableUrl)
      .then(response => {
          if (!response.ok) throw new Error(`Failed to load: ${response.status}`);
          return response.text();
      })
      .then(html => {
          body.innerHTML = replaceReferences(html);
          if (stageCode) {
              // loadOperationsByStage fills the data-section cells that the written
              // ODG00-ODG02 pages provide. ODG03 has no page of its own and is served
              // the shared shell, which has no such cells, so it uses the generic
              // renderer that builds its rows from nothing.
              if (stageCode.startsWith('OAR') || stageCode === 'ODG03') loadOAROperationsByStage(stageCode);
              else if (stageCode.startsWith('ODG')) loadOperationsByStage(stageCode);
          }
      })
      .catch(error => {
          console.error('Table load error:', error);
          body.innerHTML = `<p class="protocol-empty">Error loading table: ${escapeHtml(error.message)}</p>`;
      });
}

function closeTablePopup() {
  const popup = document.querySelector('.table-popup');
  if (!popup) return;
  closeDetailWindow();
  popup.remove();
  removeOpParamFromURL();
  removeObsParamFromURL();
}

// JSON for an inline, single-quoted onclick attribute: escape what the HTML parser
// would otherwise read as the end of the attribute or as an entity.
function attrJson(value) {
    return JSON.stringify(value).replace(/&/g, '&amp;').replace(/'/g, '&#39;');
}

// Generic summaries the regional guides attach to many different topics. They repeat
// across cards, so the page shows the topic and its Details link, and the summary
// opens inside the Details window instead.
const GUIDE_SUMMARIES = new Set([
    "Recognise orchard natural enemies and conserve their contribution to pest and mite regulation.",
    "Match training and pruning to the tree age, production system and desired balance between growth, light and cropping.",
    "Use soil, plant and weather information to plan irrigation amount, timing and automated control.",
    "Use tissue analysis and deficiency or toxicity symptoms to guide a balanced orchard nutrition programme.",
    "Assess maturity and fruit condition, then use careful handling and suitable storage to preserve quality.",
    "Review disease and insect monitoring at this crop stage and select management for the risks present.",
    "Recognise orchard injury and review the conditions and practices that caused it.",
    "Use monitoring, biological options and resistance management within the orchard IPM programme.",
    "Identify apple decay symptoms and reduce infection through orchard sanitation, careful harvest handling and storage hygiene.",
    "Provide compatible pollen, effective bee activity and suitable orchard habitat during bloom.",
    "Use the relevant crop-specific reference table when planning orchard treatments and work intervals.",
    "Manage tree rows and row middles according to orchard age, weeds, soil and traffic needs.",
    "Monitor animal damage and combine habitat management, protection and exclusion suited to the orchard.",
    "Plan the orchard site, layout and planting material together before establishment.",
    "Choose rootstock, spacing, support and planting depth as parts of the orchard system.",
    "Manage water, equipment, worker hygiene, transport and traceability to reduce contamination of apples and apple products.",
    "Check water quality, equipment calibration and canopy coverage before orchard spraying."
]);

// The guide sources behind one operation, stacked above the guide itself. A general
// point on the page lists the specific items it covers here, above its sources.
function showOperationReferences(refs, summary, items) {
  if ((!refs || !refs.length) && !(items && items.length)) return;
  closeDetailWindow();

  // Details reads source by source: each source once, then the pages cited from it,
  // each with what that page says. An item's full text is given under its first
  // source; under any further source its page shows the short note of what it covers.
  // One page style everywhere: "p. 44", "p. 43–44" (not "page", "pages", "pp.").
  const cleanPage = ref => {
      const page = (ref.page_number || '').trim();
      if (!page || page.toUpperCase() === 'N/A') return '';
      return page.replace(/^(pages?|pp?\.?)\s*(?=\d)/i, 'p. ');
  };
  const pageNumbers = page => page.replace(/^p\.\s*/, '');
  const firstNumber = page => parseFloat((pageNumbers(page).match(/\d+/) || ['1e9'])[0]);
  const coverNote = (ref, item) => {
      const note = String(ref.note || '').split(' — ').slice(1).join(' — ').trim();
      const page = cleanPage(ref);
      const descriptive = /[a-z]{4,}/i.test(page.replace(/^(p\.|pp\.|page)\s*/i, ''));
      return note || (descriptive ? '' : (item && item.page_summary) || '');
  };
  const sourceTitle = ref => {
      const name = escapeHtml(stripArchived(ref.third_party_database) || 'Source not recorded');
      const link = (ref.link || '').split('#')[0];
      // A source in the portal's bibliography opens the same reference window as the
      // citations in the table; any other source opens its web page.
      if (ref.bibtex_key) return `<a href="#" class="reference-link" data-bibtex-key="${escapeHtml(ref.bibtex_key)}">${name}</a>`;
      return link ? `<a href="${escapeHtml(link)}" target="_blank" rel="noopener noreferrer">${name}</a>` : name;
  };
  // A card whose text is only a guide's generic sentence shows its own summary.
  const detailText = item => {
      const text = (item.description || '').trim();
      return (GUIDE_SUMMARIES.has(text) && item.summary) ? item.summary : (text || item.summary || '');
  };
  const bySource = list => {
      const sources = [];
      const shownText = new Set();
      for (const item of list) {
          const itemRefs = (item.references || []).filter(ref => ref && (ref.third_party_database || ref.link));
          for (const ref of itemRefs) {
              const id = (ref.link || '').split('#')[0] || stripArchived(ref.third_party_database) || '';
              let source = sources.find(s => s.id === id);
              if (!source) { source = { id, ref, pages: [] }; sources.push(source); }
              if (!source.ref.bibtex_key && ref.bibtex_key) source.ref = ref;
              const page = cleanPage(ref);
              const key = `${page}|${item.subsection}`;
              if (source.pages.some(p => p.key === key)) continue;
              const first = !shownText.has(item);
              shownText.add(item);
              source.pages.push({ key, page, anchor: (ref.link || '').includes('#') ? ref.link : '',
                  label: item.subsection, note: coverNote(ref, item),
                  text: first ? detailText(item) : '' });
          }
      }
      // Pages of one source that say the same thing are one entry ("p. 39, p. 41").
      for (const source of sources) {
          const merged = [];
          for (const p of source.pages) {
              const same = merged.find(m => m.label === p.label && m.note === p.note && (!m.text || !p.text || m.text === p.text));
              if (same && p.page) {
                  if (!same.pages.includes(p.page)) same.pages.push(p.page);
                  if (!same.text) same.text = p.text;
              } else merged.push({ ...p, pages: p.page ? [p.page] : [] });
          }
          source.pages = merged.map(m => ({ ...m, page: m.pages.join(', '), anchor: m.pages.length > 1 ? '' : m.anchor }));
      }
      // Under a source, each item is named once with its text, then its pages, each
      // with what that page covers.
      const pageLine = p => `<li class="guide-page-where">${p.page
          ? (p.anchor ? `<a href="${escapeHtml(p.anchor)}" target="_blank" rel="noopener noreferrer">${escapeHtml(p.page)}</a>` : escapeHtml(p.page))
          : 'Web page'}${p.note ? ` <span class="guide-page-note">· ${escapeHtml(p.note)}</span>` : ''}</li>`;
      return sources.map(source => {
          const byItem = [];
          for (const p of source.pages) {
              const entry = byItem.find(e => e.label === p.label);
              if (entry) { entry.pages.push(p); if (!entry.text) entry.text = p.text; }
              else byItem.push({ label: p.label, text: p.text, pages: [p] });
          }
          // Pages of an item that give the same information are one line, numbers in
          // order: "p. 42, 43–44, 137 · bud union height ...".
          for (const e of byItem) {
              const lines = [];
              for (const p of e.pages) {
                  const parts = p.page.split(/,\s*/).filter(Boolean);
                  const numeric = parts.length && parts.every(x => /^p\.\s*\d/.test(x));
                  const same = numeric && lines.find(l => l.numeric && l.note === p.note);
                  if (same) {
                      for (const x of parts) if (!same.parts.includes(x)) same.parts.push(x);
                  } else lines.push({ ...p, parts, numeric });
              }
              for (const l of lines) {
                  if (!l.numeric) continue;
                  l.parts.sort((a, b) => firstNumber(a) - firstNumber(b));
                  l.page = 'p. ' + l.parts.map(pageNumbers).join(', ');
                  if (l.parts.length > 1) l.anchor = '';
              }
              e.pages = lines;
          }
          return `<section class="guide-source-block">
          <div class="guide-source-name">${sourceTitle(source.ref)}</div>
          <ul class="guide-page-list">${byItem.map(e => `<li class="guide-page">
              ${e.label ? `<div class="guide-page-detail"><strong>${escapeHtml(e.label)}</strong>${e.text ? `: ${escapeHtml(e.text)}` : ''}</div>` : ''}
              <ul class="guide-page-refs">${e.pages.map(pageLine).join('')}</ul>
          </li>`).join('')}</ul></section>`;
      }).join('');
  };
  // A general line that stands for several topics keeps each topic's heading, with
  // that topic's sources under it.
  const topics = list => {
      if (!list.some(item => item.group)) return bySource(list);
      const groups = [];
      for (const item of list) {
          const last = groups[groups.length - 1];
          if (last && last.group.label === item.group?.label) last.items.push(item);
          else groups.push({ group: item.group || { label: '', text: '' }, items: [item] });
      }
      return groups.map(g => `<section class="guide-group"><h4 class="guide-group-title">${escapeHtml(g.group.label)}${
          g.group.text ? `<span>: ${escapeHtml(g.group.text)}</span>` : ''}</h4>${bySource(g.items)}</section>`).join('');
  };
  const body = items && items.length ? topics(items)
      : bySource([{ subsection: '', description: '', references: refs }]);

  const win = document.createElement('div');
  win.className = 'centre-window detail-window';
  win.innerHTML =
      '<div class="centre-window-card centre-window-card--narrow">' +
      '<button type="button" class="centre-window-close" aria-label="Close">&times;</button>' +
      `<h3 class="centre-window-title">Details</h3>` +
      '<div class="centre-window-body detail-window-body">' +
      (summary ? `<p class="guide-source-summary">${escapeHtml(summary)}</p>` : '') +
      body +
      '</div></div>';
  document.body.appendChild(win);

  win.querySelector('.centre-window-close').addEventListener('click', closeDetailWindow);
  win.addEventListener('click', event => { if (event.target === win) closeDetailWindow(); });
}

function closeDetailWindow() {
  const win = document.querySelector('.detail-window');
  if (!win) return;
  win.remove();
  removeOpDetailParam();
}


function updateURLWithOpDetailParam(thirdPartyId) {
  const url = new URL(window.location);
  url.searchParams.set('op_detail', thirdPartyId);
  window.history.pushState({}, '', url);
}

function updateURLWithOpParam(opId) {
  const url = new URL(window.location);
  url.searchParams.set('op', opId);
  window.history.pushState({}, '', url);
}

function updateURLWithObsParam(obsId) {
  const url = new URL(window.location);
  url.searchParams.set('obs_detail', obsId);
  window.history.pushState({}, '', url);
}

function removeObsParamFromURL() {
  const url = new URL(window.location);
  url.searchParams.delete('obs_detail');
  window.history.pushState({}, '', url);
}

function removeOpParamFromURL() {
  const url = new URL(window.location);
  url.searchParams.delete('op');
  window.history.pushState({}, '', url);
}

function removeOpDetailParam() {
  const url = new URL(window.location);
  url.searchParams.delete('op_detail');
  window.history.pushState({}, '', url);
}

  async function loadOAROperationsByStage(stageCode) {
    try {
      const response = await fetch(`/api/stage/${stageCode}/operation`);
      const data = await response.json();

      const sectionMap = {};
      data.forEach(op => {
        const section = op.section?.trim();
        const subsection = op.subsection?.trim() || 'General';
        if (!sectionMap[section]) sectionMap[section] = {};
        if (!sectionMap[section][subsection]) sectionMap[section][subsection] = [];
        sectionMap[section][subsection].push(op);
      });

      const tbody = document.getElementById('operation-table-body');
      tbody.innerHTML = '';
      showProposedNote(data);

      Object.entries(sectionMap).forEach(([section, subsectionGroup]) => {
        const row = document.createElement('tr');
        const td = document.createElement('td');
        td.setAttribute('data-section', section);

        // A section can carry the supplementary table's own heading (e.g. "Fumigate").
        const heading = Object.values(subsectionGroup).flat().find(op => op.section_heading)?.section_heading;
        let html = `<b>${heading || section}</b><br>`;
        Object.entries(subsectionGroup).forEach(([subsection, ops]) => {
          ops.forEach(op => {
            // The page carries a one-line summary; the full text opens in Details.
            const fullText = (op.description || '').trim();
            const pageText = op.summary || (GUIDE_SUMMARIES.has(fullText) ? '' : fullText);
            const subsectionPrefix = (subsection && subsection.toLowerCase() !== 'general') ? `<strong>${subsection}</strong>${pageText ? ': ' : ''}` : '';
            const refs = op.references || [{
              third_party_database: op.third_party_database,
              link: op.link,
              page_number: op.page_number
            }];
            const proposed = op.status === 'proposed';
            html += `
              <div class="operation-item${proposed ? ' operation-item--proposed' : ''}">
                ${proposed ? '<span class="operation-proposed-tag">proposed</span>' : ''}
                ${subsectionPrefix}${pageText}
                ${(op.items || []).length || (refs || []).some(r => r && (r.third_party_database || r.link)) ? `<a class="details-link" onclick='showDetailMulti(${attrJson(op.items ? [] : refs)}, ${fullText && fullText !== pageText ? attrJson(fullText) : 'null'}${op.items ? `, ${attrJson(op.items)}` : ''})'>Details</a>` : ''}
              </div>
            `;
          });
        });
        
        td.innerHTML = replaceReferences(html);
        row.appendChild(td);
        tbody.appendChild(row);
      });
      const url = new URL(window.location);
      url.searchParams.set("op", stageCode);
      window.history.pushState({}, '', url);

      updateopTableTitleFromURL();
      applyKeywordHighlight();


    } catch (error) {
      console.error('❌ Failed to fetch operations:', error);
    }
  }


  // Explains the blue entries, and only appears where there are some.
  function showProposedNote(operations) {
      const existing = document.querySelector('.operation-proposed-note');
      if (existing) existing.remove();

      const count = (operations || []).filter(op => op.status === 'proposed').length;
      if (!count) return;

      // The OAR guide has a heading with an id; the ODG guides only have an <h2>,
      // and some fragments have neither -- fall back to sitting above the table.
      const container = document.querySelector('.centre-window-body') || document.body;
      const anchor = container.querySelector('#operation-heading, h2');

      const note = document.createElement('p');
      note.className = 'operation-proposed-note';
      note.textContent = `${count} proposed ${count === 1 ? 'operation is' : 'operations are'} shown in blue below, ` +
          `drawn from Apples: Botany, Production and Uses. They are waiting on your confirmation.`;

      if (anchor) anchor.insertAdjacentElement('afterend', note);
      else container.insertAdjacentElement('afterbegin', note);
  }

  // Opens the sources window over the guide, so the guide stays readable behind it.
  function showDetailMulti(refs, summary, items) {
    showOperationReferences(refs, summary, items);
    if (refs && refs.length) updateURLWithOpDetailParam(JSON.stringify(refs));
  }

  function autoLoadDetailMulti(opDetailParam){
    try {
      showOperationReferences(JSON.parse(opDetailParam));
    } catch (error) {
      console.warn('Could not restore operation references from the URL:', error.message);
    }
  }

  // The [Details] dialog is gone; the fragments still call closeModal() from their
  // inline markup, so keep it pointed at the drawer.
  function closeModal() {
    closeProtocolDrawer();
    removeOpDetailParam();
  }

  


  function updateopTableTitleFromURL() {
    // Titles follow the supplementary PDF (Table S1-S30); a stage the PDF has no
    // table for is titled without a table number.
    const stageCodeToTableName = {
      "ODG00": "Table S1: Commercial orchard field preparation.",
      "ODG01": "Table S2: Orchard management strategies for young apple trees.",
      "ODG02": "Table S3: Orchard management strategies for mature apple trees.",
      "OAR00": "Table S6: Suggested operation guide during dormancy (OAR00).",
      "OAR01": "Table S7: Suggested operation guide for bud development (OAR01).",
      "OAR10": "Table S9: Suggested operation guide for green tip to half-inch green stage (OAR10).",
      "OAR11": "Table S10: Suggested operation guide for half-inch green stage (OAR11).",
      "OAR12": "Table S11: Suggested operation guide for leaf development stage (OAR12).",
      "OAR43": "Suggested operation guide for mouse-ear stage (OAR43).",
      "OAR44": "Suggested operation guide for flower buds visible stage (OAR44).",
      "OAR50": "Table S15: Suggested operation guide for early through full bloom stage (OAR50).",
      "OAR55": "Table S16: Suggested operation guide for full bloom stage (OAR55).",
      "OAR57": "Table S17: Suggested operation guide for petal fall stage (OAR57).",
      "OAR59": "Table S18: Suggested operation guide for postbloom stage (OAR59).",
      "OAR60": "Table S20: Suggested operation guide for return bloom stage (OAR60).",
      "OAR71": "Table S25: Suggested operation guide for first cover spray stage (OAR71).",
      "OAR72": "Table S26: Suggested operation guide for second cover stage (OAR72).",
      "OAR73": "Table S27: Suggested operation guide for late fruit development stage (OAR73).",
      "OAR82": "Table S30: Suggested operation guide for harvest stage (OAR82).",
      "OAR02": "Suggested operation guide for end of Leaf Bud Swelling (OAR02).",
      "OAR03": "Suggested operation guide for beginning of Bud Break (OAR03).",
      "OAR04": "Suggested operation guide for green Leaf Tips About 5 mm Above Bud Scales (OAR04).",
      "OAR13": "Suggested operation guide for first Leaves Fully Expanded (OAR13).",
      "OAR30": "Suggested operation guide for beginning of Shoot Growth (OAR30).",
      "OAR40": "Suggested operation guide for inflorescence Bud Swelling (OAR40).",
      "OAR42": "Suggested operation guide for bud Burst (OAR42).",
      "OAR45": "Table S12: Suggested operation guide for tight cluster (green bud) stage (OAR45).",
      "OAR46": "Table S13: Suggested operation guide for pink bud stage (OAR46).",
      "OAR47": "Suggested operation guide for hollow Ball Stage (OAR47).",
      "OAR51": "Suggested operation guide for beginning of Flowering (OAR51).",
      "OAR(70-79)": "Suggested operation guide for fruit Development (OAR(70-79)).",
      "OAR70": "Suggested operation guide for beginning of Fruit Development (OAR70).",
      "OAR74": "Suggested operation guide for fruit Diameter Up to 40 mm; T-stage (OAR74).",
      "OAR80": "Suggested operation guide for beginning of Ripening (OAR80).",
      "OAR81": "Suggested operation guide for advanced Ripening (OAR81).",
      "OAR82-postharvest": "Suggested operation guide for post-harvest and Storage (OAR82-postharvest).",
      "OAR90": "Suggested operation guide for shoot Growth Completed; Terminal Bud Developed (OAR90).",
      "OAR91": "Suggested operation guide for leaves Begin to Discolour (OAR91).",
      "OAR92": "Suggested operation guide for beginning of Leaf Fall (OAR92).",
      "ODG03": "Suggested operation guide for end of Productive Life (ODG03)."
    };
  
    const params = new URLSearchParams(window.location.search);
    const opParam = params.get('op'); // Changed from 'stage'
    const titleElement = document.getElementById("operation-heading");
  
    if (titleElement && opParam) {
      titleElement.textContent = stageCodeToTableName[opParam] || 'Operation guide';
    }
  }

  async function loadOperationsByStage(stageCode) {
    try {
      const stageCodeToTableName = {
        'OAR82': 'S34',
        'OAR00': 'S01',
        'OAR10': 'S02',
        // Add all necessary mappings here
      };
      const tableName = stageCodeToTableName[stageCode] || stageCode;
      const response = await fetch(`/api/stage/${stageCode}/operation`);
      const data = await response.json();

      const sectionMap = {};
      data.forEach(op => {
        const section = op.section?.trim();
        const subsection = op.subsection?.trim() || 'General';
        if (!sectionMap[section]) sectionMap[section] = {};
        if (!sectionMap[section][subsection]) sectionMap[section][subsection] = [];
        sectionMap[section][subsection].push(op);
      });

      showProposedNote(data);

      // The ODG guides are laid out as fixed Objective / Suggested Operations rows,
      // so a section with no cell of its own would silently disappear. Give each
      // uncovered section a row of its own, with an objective written the same way
      // as the ones already in the guides.
      const covered = new Set(
        [...document.querySelectorAll('td[data-section]')].map(c => c.dataset.section?.trim())
      );
      const table = document.querySelector('td[data-section]')?.closest('table');
      Object.keys(sectionMap).forEach(section => {
        if (!section || covered.has(section) || !table) return;
        const row = table.querySelector('tbody')?.insertRow(-1);
        if (!row) return;
        const objective = row.insertCell(0);
        const own = Object.values(sectionMap[section]).flat().find(op => op.section_purposes)?.section_purposes;
        objective.innerHTML = own && own.length ? own.map(escapeHtml).join('<br>') : (SECTION_OBJECTIVES[section] || `- ${section}`);
        objective.dataset.purposeSet = '1';
        const cell = row.insertCell(1);
        cell.setAttribute('data-section', section);
      });

      document.querySelectorAll('td[data-section]').forEach(cell => {
        const sectionLabel = cell.dataset.section?.trim();
        const sectionData = sectionMap[sectionLabel];

        // Purposes for what the portal adds to a row of the PDF table follow the
        // PDF's own purpose text in that row.
        const added = sectionData && Object.values(sectionData).flat().find(op => op.section_purposes)?.section_purposes;
        const purposeCell = cell.previousElementSibling;
        if (added && added.length && purposeCell && !purposeCell.dataset.purposeSet) {
            purposeCell.innerHTML += '<br>' + added.map(escapeHtml).join('<br>');
            purposeCell.dataset.purposeSet = '1';
        }

        if (sectionData) {
          const heading = Object.values(sectionData).flat().find(op => op.section_heading)?.section_heading;
          let html = `<b>${heading || sectionLabel}</b><br>`;
          Object.entries(sectionData).forEach(([subsection, ops]) => {
            ops.forEach(op => {
              // The page carries a one-line summary; the full text opens in Details.
              const fullText = (op.description || '').trim();
              const pageText = op.summary || (GUIDE_SUMMARIES.has(fullText) ? '' : fullText);
              const subsectionPrefix = (subsection && subsection.toLowerCase() !== 'general') ? `<strong>${subsection}</strong>${pageText ? ': ' : ''}` : '';
              const refs = op.references || [];
              const proposed = op.status === 'proposed';
              html += `
                <div class="operation-item${proposed ? ' operation-item--proposed' : ''}">
                  ${proposed ? '<span class="operation-proposed-tag">proposed</span>' : ''}
                  ${subsectionPrefix}${pageText}
                  ${(op.items || []).length || (refs || []).some(r => r && (r.third_party_database || r.link)) ? `<a class="details-link" onclick='showDetailMulti(${attrJson(op.items ? [] : refs)}, ${fullText && fullText !== pageText ? attrJson(fullText) : 'null'}${op.items ? `, ${attrJson(op.items)}` : ''})'>Details</a>` : ''}
                </div>
              `;
            });
          });
          cell.innerHTML = replaceReferences(html);
          // updateURLWithOpDetailParam(subsection)
        //   if (typeof initializeCiteReferences === 'function') {
        //     initializeCiteReferences();
        //   }
        } else {
          cell.innerHTML = `<b>${sectionLabel}</b><br><em>No data available.</em>`;
        }
      });

      document.title = `Operations for ${stageCode} (${tableName})`;
      console.log(`Loaded operations for ${stageCode}`);
      console.log(`Loaded operations for ${tableName}`);
      updateopTableTitleFromURL();
      applyKeywordHighlight();
  
    } catch (error) {
      console.error('❌ Failed to fetch operations:', error);
    }
  };


  function autoLoadOperationTable(stageCode) {


       let tableUrl = "";

        if (stageCode === "ODG00") {
          tableUrl = "operation-contentODG00.html";
        } else if (stageCode === "ODG01") {
          tableUrl = "operation-contentODG01.html";
        } else if (stageCode === "ODG02") {
          tableUrl = "operation-contentODG02.html";
        } else {
          tableUrl = `operation-content${stageCode}.html`;
        } 

        openTablePopup(tableUrl)
   }

   function autoLoadObsDetail(obsDetailParam) {
    openTablePopup(obsDetailParam)
   }


$(document).ready(function () {
  
    initializeCiteReferences();

    const stageParam = urlParams.get("stage");
    const opParam = urlParams.get("op");
    const opDetailParam = urlParams.get("op_detail");
    const obsDetailParam = urlParams.get("obs_detail");
    const protocolParam = urlParams.get("protocol");
    const categoryParam = urlParams.get("category");
    const categoryStageParam = urlParams.get("cat_stage");

    if (protocolParam) {
        openProtocolDrawer(protocolParam);
    } else if (categoryParam && categoryStageParam) {
        openCategoryDrawer(categoryStageParam, categoryParam);
    }

    if (stageParam) {
        $("#menuSearch").val(stageParam);
        searchStage(); // ⬅️ handles highlighting & scrolling
    }

    if (obsDetailParam) {
      setTimeout(function() {
          autoLoadObsDetail(obsDetailParam);
      }, 300); // slight delay after table popup
  }




    if (opParam) {
      setTimeout(function() {
          autoLoadOperationTable(opParam);

          // After a small delay (because openTablePopup needs to finish)
          if (opDetailParam) {
              setTimeout(function() {
                  autoLoadDetailMulti(opDetailParam);
              }, 300); // slight delay after table popup
          }

      }, 300); // delay for loading table
  }
    

  });

  document.addEventListener('keydown', function(e) {
    if (e.key !== 'Escape') return;

    // Innermost first: the sources window sits on top of the guide window, which
    // sits on top of the page; the side panel is the outermost of the three.
    if (document.querySelector('.detail-window')) { closeDetailWindow(); return; }
    if (document.querySelector('.table-popup'))   { closeTablePopup();   return; }
    closeProtocolDrawer();
});


// ===============================================
// Measurement Protocol System
// ===============================================
//
// The Key Measurements column is rendered from the database (key_measurement, seeded
// from the portal's own wording plus the Table S4B indicators that apply to each
// stage). Each measurement that has a protocol becomes a link; clicking it slides the
// measurement protocol in from the right.

let keyMeasurementsPromise = null;

// Curated stage notes complement, rather than replace, the general measurement
// protocol. Each note is source-checked and deliberately limited to its recorded
// stage and regional scope.
const CURATED_MEASUREMENT_EVIDENCE = {
    'ODG02:71': {
        text: 'Australian orchard systems with approximately 60% midseason daily light interception had consistently high productivity in the cited study.',
        source: 'APAL Future Orchards (Middleton, 2007) - fo-ow-0207-light-interception-productivity.pdf, PDF page 3',
        url: 'https://apal.org.au/wp-content/uploads/2019/09/fo-ow-0207-light-interception-productivity.pdf#page=3'
    },
    'ODG02:72': {
        text: 'For the Australian orchard systems reported, productivity was consistently high at leaf area index close to 2.0. The source reports reduced productivity below 1.5 and gradual declines in fruit size and colour when leaf area index rose substantially above 2.0.',
        source: 'APAL Future Orchards (Middleton, 2007) - fo-ow-0207-light-interception-productivity.pdf, PDF page 3',
        url: 'https://apal.org.au/wp-content/uploads/2019/09/fo-ow-0207-light-interception-productivity.pdf#page=3'
    },
    'ODG02:74': {
        text: 'For Australian apple orchards, the cited guide places tree height between 0.8 and 1.0 times the between-row spacing when maximising marketable yield.',
        source: 'APAL Future Orchards (Middleton, 2007) - fo-ow-0207-light-interception-productivity.pdf, PDF page 5',
        url: 'https://apal.org.au/wp-content/uploads/2019/09/fo-ow-0207-light-interception-productivity.pdf#page=5'
    }
};

// Some protocol sources point at local PDF copies (/api/kb/assets/...) that the
// portal does not serve; their names are shown as plain text instead.
function unlinkMissingKbAssets(root) {
    root.querySelectorAll('a[href^="/api/kb/assets/"]').forEach(link => {
        link.replaceWith(document.createTextNode(link.textContent));
    });
}

function curatedMeasurementEvidence(context) {
    if (!context || !context.stageCode || !context.measurementId) return '';
    const note = CURATED_MEASUREMENT_EVIDENCE[`${context.stageCode}:${context.measurementId}`];
    if (!note) return '';
    return `
        <h3 class="protocol-heading">Stage-specific evidence</h3>
        <p class="protocol-text">${escapeHtml(note.text)}</p>
        <p class="protocol-scope"><a href="${escapeHtml(note.url)}" target="_blank" rel="noopener noreferrer">${escapeHtml(note.source)}</a></p>`;
}

// One request for every stage, reused for the rest of the session. The lifecycle
// table can show eleven stages at once, so per-stage fetching would mean eleven
// round trips on every navigation.
function loadKeyMeasurements() {
    if (!keyMeasurementsPromise) {
        keyMeasurementsPromise = fetch('/api/keymeasurements')
            .then(response => {
                if (!response.ok) throw new Error(`HTTP ${response.status}`);
                return response.json();
            })
            .catch(error => {
                console.warn('Key measurements unavailable, keeping static text:', error.message);
                return null;
            });
    }
    return keyMeasurementsPromise;
}

// "(archived 1998)" and similar archive-date tags are not part of a source's name.
function stripArchived(text) {
    return String(text || '').replace(/\s*\((?:archived|archive copy|web archive)[^)]*\)/gi, '').trim();
}

function escapeHtml(text) {
    return String(text).replace(/[&<>"']/g, ch => ({
        '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;'
    }[ch]));
}

// Below this many measurements a stage just lists them all -- grouping three items
// under two category headings helps nobody. Above it, the cell shows the portal's own
// items and folds everything into category rows that drill down in the drawer.
const CATEGORY_THRESHOLD = 8;

// categoryKey overrides the measurement's own category when the item is rendered
// inside a category listing, so the protocol's back link returns to the list the
// user actually came from, rather than the category the measurement itself belongs to.
function measurementItemHtml(measurement, stageCode, categoryKey) {
    const name = escapeHtml(measurement.measurement_name);
    if (!measurement.protocol_id) {
        return `<li class="measurement-item measurement-item--plain"` +
               ` title="No measurement protocol recorded for this item">${name}</li>`;
    }
    return `<li class="measurement-item"><a href="#" class="measurement-link"` +
           ` data-protocol-id="${measurement.protocol_id}"` +
           ` data-measurement-id="${measurement.measurement_id}"` +
           ` data-stage-code="${escapeHtml(stageCode)}"` +
           ` data-category-key="${escapeHtml(categoryKey || measurement.category_key)}"` +
           ` title="Show the measurement protocol">${name}</a></li>`;
}

// Group a stage's measurements by category, preserving the order the API returned
// (category display_order, then the measurement's own display order).
function groupByCategory(measurements) {
    const groups = [];
    const index = {};

    for (const measurement of measurements) {
        const key = measurement.category_key;
        if (!index[key]) {
            index[key] = {
                key,
                label: measurement.category_label,
                full: measurement.category_full,
                items: []
            };
            groups.push(index[key]);
        }
        index[key].items.push(measurement);
    }
    return groups;
}

function renderMeasurementCells(root) {
    const scope = root || document.getElementById('dataTable');
    if (!scope) return;

    loadKeyMeasurements().then(byStage => {
        if (!byStage) return; // API down: leave the original static text in place

        scope.querySelectorAll('tr').forEach(row => {
            const cells = row.querySelectorAll('td');
            if (cells.length < 4) return;

            const codeLabel = cells[0].querySelector('b');
            if (!codeLabel) return;
            const stageCode = codeLabel.textContent.trim();
            const measurements = byStage[stageCode];
            if (!measurements || !measurements.length) return;

            const cell = cells[3];
            if (cell.dataset.measurementsRendered === stageCode) return;
            cell.dataset.measurementsRendered = stageCode;

            if (measurements.length <= CATEGORY_THRESHOLD) {
                cell.innerHTML = `<ul class="measurement-list">` +
                    measurements.map(m => measurementItemHtml(m, stageCode)).join('') +
                    `</ul>`;
                return;
            }

            // Measurements with no protocol behind them (Image, Fruit quality) have
            // nothing to drill into, so they sit in the cell as plain text rather
            // than behind an "Other" row that opens a one-item list.
            const plain = measurements.filter(m => !m.protocol_id);
            const groups = groupByCategory(measurements.filter(m => m.protocol_id));

            cell.innerHTML =
                (plain.length
                    ? `<ul class="measurement-list">` +
                      plain.map(m => measurementItemHtml(m, stageCode)).join('') +
                      `</ul>`
                    : '') +
                `<div class="measurement-categories">` +
                groups.map(group =>
                    `<button type="button" class="measurement-category-btn"` +
                    ` data-stage-code="${escapeHtml(stageCode)}"` +
                    ` data-category-key="${escapeHtml(group.key)}"` +
                    ` title="${escapeHtml(group.full)}">` +
                    `<span class="measurement-category-name">${escapeHtml(group.label)}</span>` +
                    `<span class="measurement-category-count">${group.items.length}</span>` +
                    `</button>`).join('') +
                `</div>`;
        });
    });
}


function getProtocolDrawer() {
    let drawer = document.getElementById('protocolDrawer');
    if (drawer) return drawer;

    // Built on demand so the templates that do not declare it still get the feature.
    drawer = document.createElement('aside');
    drawer.id = 'protocolDrawer';
    drawer.className = 'protocol-drawer';
    drawer.setAttribute('aria-hidden', 'true');
    drawer.setAttribute('aria-label', 'Measurement protocol');
    drawer.innerHTML =
        '<button type="button" class="protocol-drawer-close" aria-label="Close">&times;</button>' +
        '<div id="protocolDrawerBody"></div>';
    document.body.appendChild(drawer);
    return drawer;
}

// Bibliography fields come straight out of BibTeX, so titles and author names still
// carry LaTeX escapes -- "Estadios de Las Plantas Mono-y Dicotiled\'oneas" and the like.
// Resolve the accents to real characters and drop the remaining markup.
const LATEX_ACCENTS = {
    "'a": 'á', "'e": 'é', "'i': ": 'í', "'i": 'í', "'o": 'ó', "'u": 'ú', "'y": 'ý',
    "'c": 'ć', "'n": 'ń', "'s": 'ś', "'z": 'ź',
    '"a': 'ä', '"e': 'ë', '"i': 'ï', '"o': 'ö', '"u': 'ü', '"y': 'ÿ',
    '`a': 'à', '`e': 'è', '`i': 'ì', '`o': 'ò', '`u': 'ù',
    '^a': 'â', '^e': 'ê', '^i': 'î', '^o': 'ô', '^u': 'û',
    '~a': 'ã', '~n': 'ñ', '~o': 'õ',
    '.z': 'ż', '=a': 'ā', '=e': 'ē', '=o': 'ō', '=u': 'ū'
};
const LATEX_LETTERS = {
    o: 'ø', O: 'Ø', aa: 'å', AA: 'Å', ae: 'æ', AE: 'Æ',
    oe: 'œ', OE: 'Œ', ss: 'ß', l: 'ł', L: 'Ł', i: 'i', j: 'j'
};

function cleanLatexText(text) {
    let out = String(text);

    // Accents in every brace arrangement BibTeX uses: {\'o}, \'{o}, \'o
    out = out.replace(/\{?\\([`'"^~.=])\s*\{?([A-Za-z])\}?\}?/g,
        (whole, mark, letter) => {
            const mapped = LATEX_ACCENTS[mark + letter.toLowerCase()];
            if (!mapped) return letter;
            return letter === letter.toUpperCase() ? mapped.toUpperCase() : mapped;
        });

    // Cedilla and caron/breve take a letter argument: {\c s}, {\v c}, {\u a}.
    // Case has to be carried through, or {\c C}akmak comes out as çakmak.
    const accentedCase = (letter, table) => {
        const mapped = table[letter.toLowerCase()];
        if (!mapped) return letter;
        return letter === letter.toUpperCase() ? mapped.toUpperCase() : mapped;
    };
    out = out.replace(/\{?\\c\s*\{?([A-Za-z])\}?\}?/g,
        (w, l) => accentedCase(l, { c: 'ç', s: 'ş', t: 'ţ' }));
    out = out.replace(/\{?\\[vu]\s*\{?([A-Za-z])\}?\}?/g,
        (w, l) => accentedCase(l, { c: 'č', s: 'š', z: 'ž', r: 'ř', e: 'ě', a: 'ă', g: 'ğ' }));

    // Standalone letter commands: {\o}, {\ss}, {\ae}
    out = out.replace(/\{?\\([A-Za-z]{1,2})\}/g, (w, name) => LATEX_LETTERS[name] || w);

    out = out
        .replace(/\\relax\s*/g, '')
        .replace(/\\textregistered\b/g, '®')
        .replace(/\\textemdash\b/g, '—')
        .replace(/\\textendash\b/g, '–')
        .replace(/\\textbar\b/g, '|')
        .replace(/\\&/g, '&')
        .replace(/\\%/g, '%')
        .replace(/\\_/g, '_')
        .replace(/\\\$/g, '$')
        .replace(/``([^`']*)''/g, '“$1”')  // TeX double quotes
        .replace(/`([^`']*)'/g, '‘$1’')    // TeX single quotes
        .replace(/``|''/g, '"')            // any unpaired leftovers
        .replace(/\\[a-zA-Z]+\s?/g, '')    // any command left over
        .replace(/[{}]/g, '')
        .replace(/\s{2,}/g, ' ')
        .replace(/\s+([,.;:])/g, '$1')
        .trim();

    return out;
}

function protocolReferenceHtml(reference) {
    const clean = value => cleanLatexText(value || '');
    const title = escapeHtml(stripArchived(clean(reference.title)));
    const author = reference.author ? escapeHtml(clean(reference.author)) : '';
    const year = reference.year ? ` (${reference.year})` : '';
    const publisher = reference.publisher ? escapeHtml(clean(reference.publisher)) : '';

    // Institutional protocol sources (WMO, WSU Tree Fruit, LI-COR, UC IPM ...) carry a
    // URL and are the actual protocol documents, so link straight out to them.
    const heading = reference.url
        ? `<a href="${escapeHtml(reference.url)}" target="_blank" rel="noopener noreferrer">${title}</a>`
        : title;

    return `<li class="protocol-reference">
        <div class="protocol-reference-title">${heading}${year}</div>
        ${author ? `<div class="protocol-reference-author">${author}</div>` : ''}
        ${publisher ? `<div class="protocol-reference-publisher">${publisher}</div>` : ''}
        ${reference.page_number ? `<div class="protocol-reference-page">${escapeHtml(reference.page_number)}</div>` : ''}
    </li>`;
}


function renderProtocol(protocol, context) {
    const references = (protocol.references || []).map(protocolReferenceHtml).join('');

    return `
        ${protocol.category ? `<div class="protocol-category">${escapeHtml(protocol.category)}</div>` : ''}
        <h2 class="protocol-title">${escapeHtml(protocol.indicator)}</h2>

        <h3 class="protocol-heading">Measurement protocol</h3>
        <p class="protocol-text">${escapeHtml(protocol.protocol_text)}</p>

        ${(protocol.guide_supplements || []).map(item => `
        <details class="protocol-guide-supplement">
            <summary>${escapeHtml(item.title)}</summary>
            <p class="protocol-text">${escapeHtml(item.text)}</p>
            <ul class="protocol-references">${item.references.map(protocolReferenceHtml).join('')}</ul>
        </details>`).join('')}

        ${protocol.formula_latex ? `
        <h3 class="protocol-heading">Formula</h3>
        <p class="protocol-formula">${escapeHtml(protocol.formula_latex)}</p>` : ''}

        ${protocol.instruments ? `
        <h3 class="protocol-heading">Instruments and methods</h3>
        <p class="protocol-instruments">${escapeHtml(protocol.instruments)}</p>` : ''}

        ${curatedMeasurementEvidence(context)}

        <h3 class="protocol-heading">References</h3>
        <ul class="protocol-references">${references || '<li><em>No reference recorded</em></li>'}</ul>
    `;
}


// --- the drawer stack -------------------------------------------------------
//
// Every kind of detail the portal shows -- a category listing, a measurement
// protocol, a citation -- renders in this one right-hand panel. Views are kept on a
// stack so each one can offer a way back to whatever opened it.

const drawerStack = [];

function showDrawer() {
    const drawer = getProtocolDrawer();
    drawer.classList.add('open');
    drawer.setAttribute('aria-hidden', 'false');
    return drawer;
}

function drawerBody(loadingText) {
    const drawer = showDrawer();
    const body = drawer.querySelector('#protocolDrawerBody');
    body.innerHTML = `<p class="protocol-loading"><span class="loading"></span> ${loadingText}</p>`;
    return { drawer, body };
}

// A short label for the view directly beneath the current one, used on the back button.
function drawerBackHtml() {
    if (drawerStack.length < 2) return '';
    const previous = drawerStack[drawerStack.length - 2];
    return `<button type="button" class="protocol-drawer-back">&larr; ${escapeHtml(previous.label)}</button>`;
}

// Push a view and render it; `replace` swaps the top of the stack instead, which is
// what a sibling navigation (one category to another) wants.
function pushDrawerView(view, replace) {
    if (replace || drawerStack.length === 0) drawerStack.length = Math.max(0, drawerStack.length - (replace ? 1 : 0));
    // Re-entering a view already on the stack unwinds to it rather than stacking a loop.
    const existing = drawerStack.findIndex(v => v.id === view.id);
    if (existing !== -1) drawerStack.length = existing;
    drawerStack.push(view);
    view.render();
}

document.addEventListener('click', function (event) {
    if (!(event.target.closest && event.target.closest('.protocol-drawer-back'))) return;
    event.preventDefault();
    drawerStack.pop();
    const previous = drawerStack[drawerStack.length - 1];
    if (previous) previous.render();
    else closeProtocolDrawer();
});


// --- view: one category's measurements for one stage ----------------------
//
// Built entirely from the cached /api/keymeasurements payload the page already holds,
// so drilling in costs no round trip.
function openCategoryDrawer(stageCode, categoryKey) {
    if (!stageCode || !categoryKey) return;

    pushDrawerView({
        id: `category:${stageCode}:${categoryKey}`,
        label: categoryKey,
        render() {
            const { drawer, body } = drawerBody('Loading measurements...');
            updateURLWithCategoryParams(stageCode, categoryKey);

            loadKeyMeasurements().then(byStage => {
                const all = (byStage && byStage[stageCode]) || [];
                const items = all.filter(m => m.category_key === categoryKey);
                if (!items.length) {
                    body.innerHTML = '<p class="protocol-empty">No measurements found for this category.</p>';
                    return;
                }

                const first = items[0];
                const label = first.category_label;
                const full = first.category_full;
                this.label = label;

                body.innerHTML = drawerBackHtml() + `
                    <div class="protocol-category">${escapeHtml(first.stage_name || stageCode)} &middot; ${escapeHtml(stageCode)}</div>
                    <h2 class="protocol-title">${escapeHtml(label)}</h2>
                    <div class="protocol-scope">${escapeHtml(full)}</div>

                    <h3 class="protocol-heading">${items.length} measurement${items.length === 1 ? '' : 's'}</h3>
                    <ul class="measurement-list protocol-measurement-list">
                        ${items.map(m => measurementItemHtml(m, stageCode, categoryKey)).join('')}
                    </ul>
                `;
                drawer.scrollTop = 0;
            });
        }
    });
}


// --- view: the measurement protocol ---------------------------------------
function openProtocolDrawer(protocolId, context) {
    if (!protocolId) return;

    // Opened straight from a table cell rather than from a category listing: seed the
    // stack with that category so the protocol still has somewhere to go back to.
    if (context && context.stageCode && context.categoryKey && !drawerStack.length) {
        drawerStack.push({
            id: `category:${context.stageCode}:${context.categoryKey}`,
            label: context.categoryKey,
            render: () => openCategoryDrawerReplace(context.stageCode, context.categoryKey)
        });
    }

    pushDrawerView({
        id: `protocol:${protocolId}`,
        label: 'Protocol',
        render() {
            const { drawer, body } = drawerBody('Loading measurement protocol...');
            updateURLWithProtocolParam(protocolId);

            fetch(`/api/protocol/${encodeURIComponent(protocolId)}`)
                .then(response => {
                    if (!response.ok) throw new Error(`HTTP ${response.status}`);
                    return response.json();
                })
                .then(protocol => {
                    this.label = protocol.indicator;
                    body.innerHTML = drawerBackHtml() + renderProtocol(protocol, context);
                    unlinkMissingKbAssets(body);
                    drawer.scrollTop = 0;
                })
                .catch(error => {
                    console.error('Failed to load measurement protocol:', error);
                    body.innerHTML = `<p class="protocol-empty">Could not load this measurement protocol (${escapeHtml(error.message)}).</p>`;
                });
        }
    });
}

// Re-render a category view already sitting on the stack, without pushing again.
function openCategoryDrawerReplace(stageCode, categoryKey) {
    drawerStack.length = 0;
    openCategoryDrawer(stageCode, categoryKey);
}


// --- view: citations -------------------------------------------------------
// Citations stay where the reader is looking: a small card anchored beside the
// [1] they clicked, not a panel on the far side of the screen.
function showReferencePopup(references, referenceLink) {
    if (!references || references.length === 0) return;
    closeReferencePopup();

    const clean = text => cleanLatexText(text || '');
    const popup = document.createElement('div');
    popup.className = 'reference-popup';
    popup.innerHTML = `
        <button type="button" class="reference-popup-close" aria-label="Close">&times;</button>
        <ul class="reference-popup-list">
            ${references.map(ref => {
                const title = escapeHtml(stripArchived(clean(ref.title)));
                const heading = ref.url
                    ? `<a href="${escapeHtml(ref.url)}" target="_blank" rel="noopener noreferrer">${title}</a>`
                    : title;
                return `<li class="reference-popup-item">
                    <div class="reference-popup-title">${heading}${ref.year ? ` <span class="reference-popup-year">(${ref.year})</span>` : ''}</div>
                    ${ref.author ? `<div class="reference-popup-author">${escapeHtml(clean(ref.author))}</div>` : ''}
                    ${ref.publisher ? `<div class="reference-popup-publisher">${escapeHtml(clean(ref.publisher))}</div>` : ''}
                </li>`;
            }).join('')}
        </ul>`;

    document.body.appendChild(popup);
    anchorReferencePopup(popup, referenceLink);
}

function closeReferencePopup() {
    const popup = document.querySelector('.reference-popup');
    if (popup && typeof popup.teardown === 'function') popup.teardown();
    else if (popup) popup.remove();
}

// Place the card under the link, flipping above when there is no room below and
// clamping to the viewport. Every close path goes through teardown(), so the scroll
// and resize handlers can never outlive the popup.
function anchorReferencePopup(popup, link) {
    function place() {
        const rect = link.getBoundingClientRect();
        const height = popup.offsetHeight;
        const width = popup.offsetWidth;
        const spaceBelow = window.innerHeight - rect.bottom;

        let top = rect.bottom + 8;
        let above = false;
        if (spaceBelow < height + 16 && rect.top > height + 16) {
            top = rect.top - height - 8;
            above = true;
        } else if (spaceBelow < height + 16) {
            top = Math.max(8, window.innerHeight - height - 8);
        }

        let left = Math.min(rect.left, window.innerWidth - width - 12);
        left = Math.max(12, left);

        popup.style.top = `${top}px`;
        popup.style.left = `${left}px`;
        popup.classList.toggle('reference-popup--above', above);
        // Point the caret at the link even when the card was clamped sideways.
        const caret = Math.min(Math.max(rect.left + rect.width / 2 - left, 14), width - 14);
        popup.style.setProperty('--caret', `${caret}px`);
    }

    place();
    popup.classList.add('is-visible');

    function onOutsideClick(event) {
        if (popup.contains(event.target) || link.contains(event.target)) return;
        teardown();
    }
    function onKey(event) { if (event.key === 'Escape') teardown(); }
    function teardown() {
        popup.remove();
        window.removeEventListener('scroll', place, true);
        window.removeEventListener('resize', place);
        document.removeEventListener('click', onOutsideClick, true);
        document.removeEventListener('keydown', onKey);
    }

    window.addEventListener('scroll', place, true);
    window.addEventListener('resize', place);
    document.addEventListener('click', onOutsideClick, true);
    document.addEventListener('keydown', onKey);
    popup.querySelector('.reference-popup-close').addEventListener('click', teardown);
    popup.teardown = teardown;
}


function closeProtocolDrawer() {
    const drawer = document.getElementById('protocolDrawer');
    if (!drawer || !drawer.classList.contains('open')) return;
    drawer.classList.remove('open');
    drawer.setAttribute('aria-hidden', 'true');
    drawerStack.length = 0;
    removeProtocolParamFromURL();
}

// Close on the × button, and on any click outside the drawer. The handlers that open
// or re-render the drawer run on this same node, so stopPropagation in them cannot
// prevent this listener from firing -- each has to be excluded by its own class,
// because by the time this runs the clicked element may already have been detached
// from the document by an innerHTML replacement.
document.addEventListener('click', function (event) {
    const drawer = document.getElementById('protocolDrawer');
    if (!drawer || !drawer.classList.contains('open')) return;

    if (event.target.closest('.protocol-drawer-close')) {
        closeProtocolDrawer();
        return;
    }
    // Anything that opens or re-renders the drawer has to be excluded by its own
    // class. Those handlers run on this same node, so stopPropagation in them cannot
    // stop this listener; and once a handler has replaced the drawer's innerHTML the
    // clicked element is detached, so an ancestor check like #protocolDrawer no longer
    // matches it either.
    if (event.target.closest('#protocolDrawer') ||
        event.target.closest('.measurement-link') ||
        event.target.closest('.measurement-category-btn') ||
        event.target.closest('.reference-link') ||
        event.target.closest('.protocol-drawer-back')) return;
    closeProtocolDrawer();
});

// Deep linking, mirroring the ?op= / ?obs_detail= parameters the popups already use.
// Note the category params are cat_stage/category, not stage -- ?stage= is already
// taken by the sidebar search.
function updateURLWithProtocolParam(protocolId) {
    const url = new URL(window.location.href);
    url.searchParams.set('protocol', protocolId);
    url.searchParams.delete('category');
    url.searchParams.delete('cat_stage');
    window.history.replaceState({}, '', url);
}

function updateURLWithCategoryParams(stageCode, categoryKey) {
    const url = new URL(window.location.href);
    url.searchParams.set('cat_stage', stageCode);
    url.searchParams.set('category', categoryKey);
    url.searchParams.delete('protocol');
    window.history.replaceState({}, '', url);
}

function removeProtocolParamFromURL() {
    const url = new URL(window.location.href);
    url.searchParams.delete('protocol');
    url.searchParams.delete('category');
    url.searchParams.delete('cat_stage');
    window.history.replaceState({}, '', url);
}

// ===============================================
// Keyword search: management cards and key measurements
// ===============================================
// The sidebar box matches stage names and codes on the page itself; anything else
// (a pest, a disease, a practice such as "apple scab") goes to /api/search, which
// searches every stage's cards and measurements as the portal serves them.

let keywordHighlight = null;
let keywordHits = [];

function fetchKeywordResults(query) {
    return fetch(`/api/search?q=${encodeURIComponent(query)}`)
        .then(response => response.ok ? response.json() : { total: 0, results: [] })
        .catch(() => ({ total: 0, results: [] }));
}

function keywordHitLabel(hit) {
    const kind = hit.kind === 'measurement' ? 'Measurement' : hit.section || 'Management';
    return `<span class="keyword-hit-title">${escapeHtml(hit.title)}</span>` +
        `<span class="keyword-hit-meta">${escapeHtml(kind)} · ${escapeHtml(hit.stage_code)} ${escapeHtml(hit.stage_name || '')}</span>`;
}

// Opens where the hit lives: a card opens its stage's management guide with the
// matching cards marked; a measurement goes to its stage row and its protocol.
function openKeywordHit(index, query) {
    const hit = keywordHits[index];
    if (!hit) return;
    closeKeywordWindow();
    $("#searchSuggestions").empty().hide();
    if (hit.kind === 'operation') {
        keywordHighlight = { query, titles: new Set(keywordHits.filter(h => h.kind === 'operation' && h.stage_code === hit.stage_code).map(h => h.title)) };
        autoLoadOperationTable(hit.stage_code);
    } else {
        $("#menuSearch").val(hit.stage_code);
        if (typeof searchStage === 'function') searchStage();
        if (hit.protocol_id) openProtocolDrawer(hit.protocol_id);
    }
}

// Called by both operation renderers once the cards are on the page.
function applyKeywordHighlight() {
    if (!keywordHighlight) return;
    const { query, titles } = keywordHighlight;
    keywordHighlight = null;
    const words = query.toLowerCase().split(/\s+/).filter(Boolean);
    const matches = [...document.querySelectorAll('.table-popup .operation-item')].filter(item => {
        const title = item.querySelector('strong')?.textContent.trim();
        const text = item.textContent.toLowerCase();
        return (title && titles.has(title)) || words.every(word => text.includes(word));
    });
    matches.forEach(item => item.classList.add('operation-item--match'));
    if (matches[0]) matches[0].scrollIntoView({ block: 'center' });
}

function closeKeywordWindow() {
    document.querySelector('.keyword-window')?.remove();
}

// Every result, grouped by stage, in a window over the page.
function showKeywordResults(query) {
    closeKeywordWindow();
    const popup = document.createElement('div');
    popup.className = 'centre-window keyword-window';
    popup.innerHTML =
        '<div class="centre-window-card">' +
        '<button type="button" class="centre-window-close" aria-label="Close">&times;</button>' +
        `<h2 class="centre-window-title">Search: ${escapeHtml(query)}</h2>` +
        '<div class="centre-window-body"><p class="protocol-loading"><span class="loading"></span> Searching...</p></div></div>';
    document.body.appendChild(popup);
    popup.querySelector('.centre-window-close').addEventListener('click', closeKeywordWindow);
    popup.addEventListener('click', event => { if (event.target === popup) closeKeywordWindow(); });

    fetchKeywordResults(query).then(({ total, results }) => {
        keywordHits = results;
        const body = popup.querySelector('.centre-window-body');
        if (!results.length) {
            body.innerHTML = `<p class="protocol-empty">Nothing found for “${escapeHtml(query)}”. Try a stage name, a code such as OAR57, or another keyword.</p>`;
            return;
        }
        const groups = [];
        results.forEach((hit, index) => {
            let group = groups.find(g => g.code === hit.stage_code);
            if (!group) groups.push(group = { code: hit.stage_code, name: hit.stage_name, items: [] });
            group.items.push(index);
        });
        body.innerHTML =
            `<p class="keyword-count">${total} result${total === 1 ? '' : 's'}${total > results.length ? `, showing the first ${results.length}` : ''}.</p>` +
            groups.map(group =>
                `<section class="keyword-group"><h3>${escapeHtml(group.code)} · ${escapeHtml(group.name || '')}</h3>` +
                group.items.map(index => {
                    const hit = results[index];
                    return `<button type="button" class="keyword-result" data-index="${index}">` +
                        `<span class="keyword-hit-title">${escapeHtml(hit.title)}</span>` +
                        `<span class="keyword-hit-meta">${escapeHtml(hit.kind === 'measurement' ? 'Key measurement' : hit.section || '')}</span>` +
                        (hit.summary ? `<span class="keyword-hit-summary">${escapeHtml(hit.summary)}</span>` : '') +
                        `</button>`;
                }).join('') + `</section>`).join('');
        body.querySelectorAll('.keyword-result').forEach(button =>
            button.addEventListener('click', () => openKeywordHit(Number(button.dataset.index), query)));
    });
}
