// scripts.js
// Reference and Table Popup System
// ===============================================

// Reference link functionality
function addReferenceLinkListeners(scopeElement = document) {
    scopeElement.querySelectorAll('.reference-link').forEach(function(link) {
        link.addEventListener('click', function(event) {
            event.preventDefault();
            const bibtexKeys = this.dataset.bibtexKey.split(',');
            fetchReferenceDetails(bibtexKeys, showReferencePopup, this);
        });
    });

    scopeElement.querySelectorAll('.table-ref-link').forEach(function(link) {
        link.addEventListener('click', function(event) {
            event.preventDefault();
            const tableUrl = this.dataset.table;
            openTablePopup(tableUrl);
        });
    });
}

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

// function showReferencePopup(references, referenceLink) {
//     if (!references || references.length === 0) return;

//     const existingPopup = document.querySelector('.reference-popup');
//     if (existingPopup) existingPopup.remove();

//     const popup = document.createElement('div');
//     popup.classList.add('reference-popup');
//     popup.innerHTML = `
//         <div class="reference-popup-content">
//             <span class="close-popup">&times;</span>
//             ${references.map(ref => `
//                 <div class="reference-item">
//                     <p><strong>${ref.title}</strong> (${ref.year})</p>
//                     <p><em>${ref.author}</em></p>
//                     <p>Published by: ${ref.publisher}</p>
//                 </div>
//             `).join('<hr>')}
//         </div>
//     `;

//     document.body.appendChild(popup);
//     positionPopup(popup, referenceLink);

//     popup.querySelector('.close-popup').addEventListener('click', () => {
//         popup.remove();
//         // removeOpParamFromURL();
//     });


//     window.addEventListener('click', function tempClickHandler(event) {
//         if (!popup.contains(event.target) && !referenceLink.contains(event.target)) {
//             popup.remove();
//             window.removeEventListener('click', tempClickHandler);
//         }
//     });
// }

function showReferencePopup(references, referenceLink) {
  if (!references || references.length === 0) return;

  const existingPopup = document.querySelector('.reference-popup');
  if (existingPopup) existingPopup.remove();

  const popup = document.createElement('div');
  popup.classList.add('reference-popup');

  // Function to clean LaTeX markup
  function cleanLatex(text) {
    return text
      .replace(/\\relax\s*/g, '')           // remove \relax
      .replace(/\\&/g, '&')                 // replace \& with &
      .replace(/\\{\s*o\s*}/gi, 'ø')        // {\o}
      .replace(/\\{\s*aa\s*}/gi, 'å')       // {\aa}
      .replace(/\\{\s*ae\s*}/gi, 'æ')       // {\ae}
      .replace(/\\{\s*\"a\s*}/gi, 'ä')      // {\"a}
      .replace(/\\{\s*\"o\s*}/gi, 'ö')      // {\"o}
      .replace(/\\{\s*\"u\s*}/gi, 'ü')      // {\"u}
      .replace(/[{}]/g, '');                // remove all curly braces
  }

  popup.innerHTML = `
    <div class="reference-popup-content">
      <span class="close-popup">&times;</span>
      ${references.map(ref => `
        <div class="reference-item">
          <p><strong>${cleanLatex(ref.title)}</strong> (${ref.year})</p>
          <p><em>${cleanLatex(ref.author)}</em></p>
          <p>Published by: ${cleanLatex(ref.publisher)}</p>
        </div>
      `).join('<hr>')}
    </div>
  `;

  document.body.appendChild(popup);
  positionPopup(popup, referenceLink);

  popup.querySelector('.close-popup').addEventListener('click', () => popup.remove());

  window.addEventListener('click', function tempClickHandler(event) {
    if (!popup.contains(event.target) && !referenceLink.contains(event.target)) {
      popup.remove();
      window.removeEventListener('click', tempClickHandler);
    }
  });
}


// Position popup with boundary checks
// function positionPopup(popup, anchor) {
//     const rect = anchor.getBoundingClientRect();
//     const popupWidth = popup.offsetWidth;
//     const popupHeight = popup.offsetHeight;
    
//     let top = rect.top - popupHeight - 10;
//     let left = rect.left + (rect.width/2) - (popupWidth/2);
    
//     // Viewport boundary checks
//     top = Math.max(10, Math.min(top, window.innerHeight - popupHeight - 10));
//     left = Math.max(10, Math.min(left, window.innerWidth - popupWidth - 10));

//     Object.assign(popup.style, {
//         position: 'fixed',
//         top: `${top}px`,
//         left: `${left}px`,
//         zIndex: '5000',
//         maxWidth: '400px',
//         padding: '15px',
//         border: '1px solid #ccc',
//         borderRadius: '8px',
//         backgroundColor: '#fff',
//         boxShadow: '0 4px 6px rgba(0,0,0,0.1)'
//     });
// }

function positionPopup(popup, referenceLink) {
  function updatePosition() {
    const linkRect = referenceLink.getBoundingClientRect();
    const popupRect = popup.getBoundingClientRect();

    let top = linkRect.bottom + 10; // Default: below the link
    let left = linkRect.left;

    // First, position offscreen to measure size
    popup.style.visibility = 'hidden';
    popup.style.top = '0px';
    popup.style.left = '0px';
    popup.style.maxWidth = '400px';
    popup.style.position = 'fixed';
    document.body.appendChild(popup);
    const fullHeight = popup.offsetHeight;
    const fullWidth = popup.offsetWidth;

    // If not enough space below, try placing above
    const spaceBelow = window.innerHeight - linkRect.bottom;
    const spaceAbove = linkRect.top;

    if (spaceBelow < fullHeight && spaceAbove > fullHeight) {
      top = linkRect.top - fullHeight - 10;
    } else if (spaceBelow < fullHeight) {
      // Still not enough, push up as much as possible
      top = window.innerHeight - fullHeight - 10;
    }

    // Prevent right overflow
    if (left + fullWidth > window.innerWidth) {
      left = window.innerWidth - fullWidth - 10;
    }

    // Prevent left overflow
    if (left < 10) {
      left = 10;
    }

    popup.style.top = `${top}px`;
    popup.style.left = `${left}px`;
    popup.style.visibility = 'visible';
  }

  updatePosition();
  window.addEventListener('scroll', updatePosition);
  window.addEventListener('resize', updatePosition);

  function removeListeners() {
    popup.remove();
    window.removeEventListener('scroll', updatePosition);
    window.removeEventListener('resize', updatePosition);
    window.removeEventListener('click', tempClickHandler);
  }

  popup.querySelector('.close-popup').addEventListener('click', removeListeners);

  function tempClickHandler(event) {
    if (!popup.contains(event.target) && !referenceLink.contains(event.target)) {
      removeListeners();
    }
  }

  window.addEventListener('click', tempClickHandler);
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

function initializeCiteReferences() {
    const newBody = replaceReferences(document.body.innerHTML);
    document.body.innerHTML = newBody;
    addReferenceLinkListeners();
}

// Table Popup System
// ===============================================







function openTablePopup(tableUrl) {
  const existing = document.querySelector('.table-popup, #popup-style');
  if (existing) existing.remove();

  const popup = document.createElement('div');
  popup.className = 'table-popup';

  const style = document.createElement('style');
  style.id = 'popup-style';
  style.textContent = `
      .table-popup {
          position: fixed;
          top: 0;
          left: 0;
          width: 100%;
          height: 100%;
          background: rgba(0,0,0,0.4);
          display: flex;
          justify-content: center;
          align-items: center;
          z-index: 4000;
      }
      .table-content-container {
          position: relative;
          background: white;
          padding: 20px;
          border-radius: 10px;
          width: 80%;
          height: 80%;
          overflow: auto;
          box-shadow: 0 4px 16px rgba(0,0,0,0.2);
      }
      .close-popup {
          position: absolute;
          top: 12px;
          right: 12px;
          background: #eee;
          border: none;
          width: 28px;
          height: 28px;
          border-radius: 50%;
          font-size: 18px;
          font-weight: bold;
          line-height: 1;
          cursor: pointer;
          color: #333;
          z-index: 10;
          transition: background 0.3s ease, color 0.3s ease;
      }
      .close-popup:hover {
          background-color:rgb(41, 27, 27);
          color: white;
      }
      /* New delete button styles */
      .delete-btn {
          background:rgb(128, 113, 112);
          color: white;
          padding: 8px 16px;
          border-radius: 4px;
          border: none;
          cursor: pointer;
          font-size: 14px;
          transition: all 0.3s ease;
          display: inline-flex;
          align-items: center;
          gap: 6px;
          margin: 4px 2px;
      }
      .delete-btn:hover {
          background:rgb(16, 15, 15);
          transform: translateY(-1px);
          box-shadow: 0 2px 8px rgba(0,0,0,0.1);
      }
      .delete-btn:active {
          transform: translateY(0);
      }
      .delete-btn::before {
          content: '🗑';
          font-size: 16px;
      }
      /* Loading animation */
      @keyframes spin {
          0% { transform: rotate(0deg); }
          100% { transform: rotate(360deg); }
      }
      .loading {
          display: inline-block;
          width: 20px;
          height: 20px;
          border: 3px solid rgba(0,0,0,0.1);
          border-radius: 50%;
          border-top-color: #3498db;
          animation: spin 1s ease-in-out infinite;
      }
  `;
  document.head.appendChild(style);

  const container = document.createElement('div');
  container.className = 'table-content-container';

  const closeBtn = document.createElement('button');
  closeBtn.className = 'close-popup';
  closeBtn.innerHTML = '&times;';

  closeBtn.onclick = () => {
      popup.remove();
      removeOpParamFromURL();
      removeObsParamFromURL();
  };

  container.appendChild(closeBtn);

  const contentHolder = document.createElement('div');
  contentHolder.innerHTML = '<p><span class="loading"></span> Loading table content...</p>';
  container.appendChild(contentHolder);

  function extractStageCode(tableUrl) {
      const match = tableUrl.match(/operation-content(OAR[^.]+)\.html/);
      return match ? match[1] : null;
  }

  let stageCode = extractStageCode(tableUrl);

  if (tableUrl.includes("operation-contentODG00.html")) stageCode = "ODG00";
  else if (tableUrl.includes("operation-contentODG01.html")) stageCode = "ODG01";
  else if (tableUrl.includes("operation-contentODG02.html")) stageCode = "ODG02";

  if (tableUrl.includes("operation-contentOAR")) {
      tableUrl = "operation-contentOAR.html";
  }

  function fixTableUrl(url) {
      const pattern = /operation-content(\d+\.\d+\.\d+)\.html/;
      if (pattern.test(url)) {
          url = url.replace(pattern, 'table-content$1.html');
          updateURLWithObsParam(url);
          return url;
      }
      return url;
  }

  tableUrl = fixTableUrl(tableUrl);

  fetch(tableUrl)
      .then(response => {
          if (!response.ok) throw new Error(`Failed to load: ${response.status}`);
          return response.text();
      })
      .then(html => {
          const processed = replaceReferences(html);
          contentHolder.innerHTML = processed;

          // Add delete button handlers
          const deleteButtons = contentHolder.querySelectorAll('.delete-btn');
          deleteButtons.forEach(btn => {
              btn.addEventListener('click', function(e) {
                  if (!confirm('Are you sure you want to delete this item?')) return;
                  
                  // Add loading state
                  const originalHTML = btn.innerHTML;
                  btn.innerHTML = '<span class="loading"></span> Deleting...';
                  btn.disabled = true;
                  
                  // Simulate delete action
                  setTimeout(() => {
                      btn.innerHTML = originalHTML;
                      btn.disabled = false;
                      const row = btn.closest('tr');
                      row.style.transition = 'all 0.3s ease';
                      row.style.opacity = '0';
                      setTimeout(() => row.remove(), 300);
                  }, 1500);
              });
          });

          if (stageCode) {
              if (stageCode.startsWith('OAR')) {
                  loadOAROperationsByStage(stageCode);
              } else if (stageCode.startsWith('ODG')) {
                  loadOperationsByStage(stageCode);
              }
              updateURLWithOpParam(stageCode);
          } else {
              updateURLWithObsParam(tableUrl);
          }

          addReferenceLinkListeners(container);
      })
      .catch(error => {
          console.error('Table load error:', error);
          contentHolder.innerHTML = `<p class="error">Error loading table: ${error.message}</p>`;
      });

  popup.appendChild(container);
  document.body.appendChild(popup);
}




function updateURLWithOpDeatilParam(thirdPartyId) {
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

function removeOpDeatilParam() {
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
            html += `
              <div style="margin-left: 1em; margin-bottom: 0.5em;">
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


  function showDetailMulti(refs) {
    let content = refs.map(r => `
      <p><strong>${r.third_party_database || 'N/A'}</strong><br>
      <a href="${r.link || '#'}" target="_blank">${r.link || 'No link available'}</a><br>
      Page: ${r.page_number || 'N/A'}</p>
    `).join('<hr>');
    document.getElementById('modal-content-body').innerHTML = content;
    document.getElementById('detailModal').style.display = 'flex';
    updateURLWithOpDeatilParam(content)
    
  }

  function autoLoadDetailMulti(opDetailParam){
    const content = decodeURIComponent(opDetailParam);
    document.getElementById('modal-content-body').innerHTML = content;
    document.getElementById('detailModal').style.display = 'flex';
    updateURLWithOpDeatilParam(content)


  }

  function closeModal() {
    document.getElementById('detailModal').style.display = 'none';
    removeOpDeatilParam(); 
    
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
      "OAR82": "Table S33: Suggested operation guide for harvest stage (OAR82)."
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

      document.querySelectorAll('td[data-section]').forEach(cell => {
        const sectionLabel = cell.dataset.section?.trim();
        const sectionData = sectionMap[sectionLabel];

        if (sectionData) {
          let html = `<b>${sectionLabel}</b><br>`;
          Object.entries(sectionData).forEach(([subsection, ops]) => {
            ops.forEach(op => {
              const subsectionPrefix = (subsection && subsection.toLowerCase() !== 'general') ? `<strong>${subsection}</strong>: ` : '';
              const refs = op.references || [];
              html += `
                <div style="margin-left: 1em; margin-bottom: 0.5em;">
                  ${subsectionPrefix}${op.description}
                  <a class="details-link" onclick='showDetailMulti(${JSON.stringify(refs)})'>[Details]</a>
                </div>
              `;
            });
          });
          cell.innerHTML = replaceReferences(html);
          // updateURLWithOpDeatilParam(subsection)
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
    if (e.key === 'Escape') {
        const popup = document.querySelector('.reference-popup');
        if (popup) popup.remove();
    }
});

