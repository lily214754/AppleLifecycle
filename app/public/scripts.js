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
              if (stageCode.startsWith('OAR')) loadOAROperationsByStage(stageCode);
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

// The guide sources behind one operation, stacked above the guide itself.
function showOperationReferences(refs) {
  if (!refs || !refs.length) return;
  closeDetailWindow();

  const win = document.createElement('div');
  win.className = 'centre-window detail-window';
  win.innerHTML =
      '<div class="centre-window-card centre-window-card--narrow">' +
      '<button type="button" class="centre-window-close" aria-label="Close">&times;</button>' +
      `<h3 class="centre-window-title">Where this comes from</h3>` +
      '<ul class="guide-source-list">' +
      refs.map(ref => {
          const name = escapeHtml(ref.third_party_database || 'Source not recorded');
          const page = (ref.page_number || '').trim();
          return `<li class="guide-source">
              <div class="guide-source-name">${
                  ref.link
                      ? `<a href="${escapeHtml(ref.link)}" target="_blank" rel="noopener noreferrer">${name}</a>`
                      : name}</div>
              ${page && page.toUpperCase() !== 'N/A'
                  ? `<div class="guide-source-page">${escapeHtml(page)}</div>` : ''}
              ${ref.link ? `<div class="guide-source-url">${escapeHtml(ref.link)}</div>` : ''}
          </li>`;
      }).join('') +
      '</ul></div>';
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

        let html = `<b>${section}</b><br>`;
        Object.entries(subsectionGroup).forEach(([subsection, ops]) => {
          ops.forEach(op => {
            const subsectionPrefix = (subsection && subsection.toLowerCase() !== 'general') ? `<strong>${subsection}</strong>: ` : '';
            const refs = op.references || [{
              third_party_database: op.third_party_database,
              link: op.link,
              page_number: op.page_number
            }];
            const proposed = op.status === 'proposed';
            html += `
              <div class="operation-item${proposed ? ' operation-item--proposed' : ''}">
                ${proposed ? '<span class="operation-proposed-tag">proposed</span>' : ''}
                ${subsectionPrefix}${op.description}
                <a class="details-link" onclick='showDetailMulti(${JSON.stringify(refs)})'>[Details]</a>
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
  function showDetailMulti(refs) {
    showOperationReferences(refs);
    updateURLWithOpDetailParam(JSON.stringify(refs));
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
    const stageCodeToTableName = {
      "OAR00": "Table S8: Suggested operation guide during dormancy (OAR00).",
      "OAR01": "Table S9: Suggested operation guide for bud development (OAR01).",
      "OAR10": "Table S11: Suggested operation guide for green tip to half-inch green stage (OAR10).",
      "OAR11": "Table S12: Suggested operation guide for summer stage (OAR11).",
      "OAR12": "Table S13: Suggested operation guide for leaf development stage (OAR12)",
      "OAR43": "Table S14: Suggested operation guide for tight cluster stage (OAR43).",
      "OAR44": "Table S15: Suggested operation guide for pink bud stage (OAR44).",
      "OAR50": "Table S17: Suggested operation guide for bloom stage (OAR50).",
      "OAR55": "Table S18: Suggested operation guide for full bloom stage (OAR55).",
      "OAR57": "Table S19: Suggested operation guide for petal fall stage (OAR57).",
      "OAR59": "Table S20: Suggested operation guide for postbloom stage (OAR59).",
      "OAR60": "Table S22: Suggested operation guide for return bloom stage (OAR60).",
      "OAR71": "Table S27: Suggested operation guide for first cover spray stage (OAR71).",
      "OAR72": "Table S28: Suggested operation guide for second cover stage (OAR72).",
      "OAR73": "Table S29: Suggested operation guide for late fruit development stage (OAR73).",
      "OAR82": "Table S32: Suggested operation guide for harvest stage (OAR82)."
      // Add other OAR mappings here
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
        objective.innerHTML = SECTION_OBJECTIVES[section] || `- ${section}`;
        const cell = row.insertCell(1);
        cell.setAttribute('data-section', section);
      });

      document.querySelectorAll('td[data-section]').forEach(cell => {
        const sectionLabel = cell.dataset.section?.trim();
        const sectionData = sectionMap[sectionLabel];

        if (sectionData) {
          let html = `<b>${sectionLabel}</b><br>`;
          Object.entries(sectionData).forEach(([subsection, ops]) => {
            ops.forEach(op => {
              const subsectionPrefix = (subsection && subsection.toLowerCase() !== 'general') ? `<strong>${subsection}</strong>: ` : '';
              const refs = op.references || [];
              const proposed = op.status === 'proposed';
              html += `
                <div class="operation-item${proposed ? ' operation-item--proposed' : ''}">
                  ${proposed ? '<span class="operation-proposed-tag">proposed</span>' : ''}
                  ${subsectionPrefix}${op.description}
                  <a class="details-link" onclick='showDetailMulti(${JSON.stringify(refs)})'>[Details]</a>
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
    const title = escapeHtml(clean(reference.title));
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
    </li>`;
}


function renderProtocol(protocol) {
    const stages = (protocol.stages || [])
        .map(stage => `<span class="protocol-stage-chip" title="${escapeHtml(stage.stage_name || '')}">${escapeHtml(stage.stage_code)}</span>`)
        .join('');
    const references = (protocol.references || []).map(protocolReferenceHtml).join('');

    return `
        ${protocol.category ? `<div class="protocol-category">${escapeHtml(protocol.category)}</div>` : ''}
        <h2 class="protocol-title">${escapeHtml(protocol.indicator)}</h2>

        <h3 class="protocol-heading">Measurement protocol</h3>
        <p class="protocol-text">${escapeHtml(protocol.protocol_text)}</p>

        ${protocol.formula_latex ? `
        <h3 class="protocol-heading">Formula</h3>
        <p class="protocol-formula">${escapeHtml(protocol.formula_latex)}</p>` : ''}

        ${protocol.instruments ? `
        <h3 class="protocol-heading">Instruments and methods</h3>
        <p class="protocol-instruments">${escapeHtml(protocol.instruments)}</p>` : ''}

        <h3 class="protocol-heading">Applies to</h3>
        <div class="protocol-stages">${stages || '<em>Not stage-specific</em>'}</div>
        ${protocol.stage_scope ? `<div class="protocol-scope">Source scope: ${escapeHtml(protocol.stage_scope)}</div>` : ''}

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
                    body.innerHTML = drawerBackHtml() + renderProtocol(protocol);
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
                const title = escapeHtml(clean(ref.title));
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

