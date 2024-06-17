 // Handle caret toggling
 var carets = document.querySelectorAll('.caret');
 carets.forEach(function(caret) {
     caret.classList.add("caret-down");
     var nested = caret.nextElementSibling;
     if (nested) {
         nested.style.display = "block";
     }
 });

 document.querySelectorAll('.caret').forEach(function(caret) {
     caret.addEventListener('click', function() {
         // Hide all nested elements
         document.querySelectorAll('.nested').forEach(function(nested) {
             nested.style.display = "none";
         });

         // Reset all carets
         document.querySelectorAll('.caret').forEach(function(caret) {
             caret.classList.remove("caret-down");
         });

         // Toggle the clicked caret and its nested element
         this.classList.toggle("caret-down");
         var nested = this.nextElementSibling;
         if (nested) {
             nested.style.display = nested.style.display === "block" ? "none" : "block";
         }
     });
 });

 // Toggle visibility function
 window.toggleVisibility = function(elementId) {
     // Hide all sections
     document.querySelectorAll('.tree-container').forEach(function(container) {
         container.style.display = 'none';
     });

     // Show the clicked section
     const element = document.getElementById(elementId);
     if (element) {
         element.style.display = 'block';
     }
 };
    // Create table from JSON
// Create table from JSON
async function createTableFromJson(tableId) {
    const tableContainer = document.getElementById(`tableContainer${tableId}`);
    const fileName = `table-content${tableId}`;
    try {
        const response = await fetch(fileName);
        if (!response.ok) throw new Error('Network response was not ok');
        const html = await response.text();
        tableContainer.innerHTML = html;
        tableContainer.style.display = 'block';
        initializeReferences(); // Re-initialize references after loading table content
    } catch (error) {
        console.error('Failed to load table:', error);
    }
}

// Show table function
window.showTable = async function(tableId, event) {
    if (event) {
        event.preventDefault(); // Prevent the default behavior
    }
    const tableContainer = document.getElementById(`tableContainer${tableId}`);
    const toggleBtn = document.getElementById(`toggleTableBtn${tableId}`);
    try {
        if (tableContainer.style.display === 'none' || tableContainer.style.display === '') {
            await createTableFromJson(tableId);
            tableContainer.style.display = 'block';
            toggleBtn.textContent = 'Hide Details';
        } else {
            tableContainer.style.display = 'none';
            toggleBtn.textContent = 'Show Details';
        }
    } catch (error) {
        console.error('Failed to load table:', error);
    }
};




    // Reference link functionality
    function addReferenceLinkListeners() {
        document.querySelectorAll('.reference-link').forEach(function(link) {
            link.addEventListener('click', function(event) {
                event.preventDefault();
                const bibtexKeys = this.dataset.bibtexKey.split(',');
                fetchReferenceDetails(bibtexKeys, showReferencePopup, this);
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

// Show reference popup
function showReferencePopup(references, referenceLink) {
    if (!references || references.length === 0) return;

    const existingPopup = document.querySelector('.reference-popup');
    if (existingPopup) {
        existingPopup.remove();
    }

    const popup = document.createElement('div');
    popup.classList.add('reference-popup');
    popup.innerHTML = `
        <div class="reference-popup-content">
            <span class="close-popup">&times;</span>
            ${references.map(ref => `
                <h3>${ref.title} (${ref.year})</h3>
                <p>Author: ${ref.author}</p>
                <p>Publisher: ${ref.publisher}</p>
            `).join('<hr>')}
        </div>
    `;

    document.body.appendChild(popup);

    // Position the popup above the reference link
    const linkRect = referenceLink.getBoundingClientRect();
    let top = linkRect.top - popup.offsetHeight - 10;
    let left = linkRect.left + (linkRect.width / 2) - (popup.offsetWidth / 2);

    // Adjust if the popup goes out of the viewport
    if (top < 0) {
        top = linkRect.bottom + 10;
    }
    if (left < 0) {
        left = 10;
    }
    if (left + popup.offsetWidth > window.innerWidth) {
        left = window.innerWidth - popup.offsetWidth - 10;
    }

    popup.style.top = `${top}px`;
    popup.style.left = `${left}px`;
    popup.style.position = 'fixed';

    popup.style.display = 'block';

    // Close the popup when the user clicks on <span> (x)
    popup.querySelector('.close-popup').addEventListener('click', function() {
        popup.remove();
    });

    // Close the popup when the user clicks anywhere outside of the popup
    window.addEventListener('click', function(event) {
        if (!popup.contains(event.target) && !referenceLink.contains(event.target)) {
            popup.remove();
        }
    }, { once: true });
}
// Function to replace references with consistent numbering
function replaceReferences(text) {
    const referenceMap = {};
    let index = 0;

    return text.replace(/cite{([^}]+)}/g, function (match, bibtexKeys) {
        const keys = bibtexKeys.split(",").map(key => key.trim());
        return keys.map(key => {
            if (!referenceMap[key]) {
                referenceMap[key] = ++index;
            }
            const refIndex = referenceMap[key];
            const refId = `ref-${refIndex}-${key}`;
            return `<a href="#" class="reference-link" data-bibtex-key="${key}" id="${refId}">[${refIndex}]</a>`;
        }).join(' ');
    });
}

    function initializeReferences() {
        const bodyContent = document.body.innerHTML;
        const updatedContent = replaceReferences(bodyContent);
        document.body.innerHTML = updatedContent;
        addReferenceLinkListeners();
    }

    // Initialize references after the DOM is ready
    initializeReferences();

