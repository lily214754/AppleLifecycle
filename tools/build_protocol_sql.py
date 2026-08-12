#!/usr/bin/env python3
"""Generate app/config/protocol.sql from the Table S4A/S4B source files.

Sources (app/config/source/):
  apple_two_new_tables_compact_insert.tex  -- Table S4A (17 transitions) + S4B (85 protocols)
  METHOD_SOURCE_AUDIT_previous_complete.csv -- adds the `Protocol basis` classifier to S4B
  apple_two_new_tables_compact_refs.bib     -- 74 references, 13 of them protocol websites

Also seeds key_measurement for every stage shown in the portal, from
app/data/tablesData.json plus the S4B indicators that apply to each stage.

Run:  python3 tools/build_protocol_sql.py
"""

import collections
import csv
import json
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = os.path.join(ROOT, 'app', 'config', 'source')
TEX = os.path.join(SRC, 'apple_two_new_tables_compact_insert.tex')
CSV_FILE = os.path.join(SRC, 'METHOD_SOURCE_AUDIT_previous_complete.csv')
BIB = os.path.join(SRC, 'apple_two_new_tables_compact_refs.bib')
TABLES_JSON = os.path.join(ROOT, 'app', 'data', 'tablesData.json')
MAP_FILE = os.path.join(ROOT, 'tools', 'measurement_protocol_map.json')
OUT_BOOT = os.path.join(ROOT, 'app', 'config', 'protocol.sql')
OUT_MIGRATION = os.path.join(ROOT, 'migrations', '2026-08-11_measurement_protocol.sql')

# Bib keys that are byte-identical duplicates of another entry; collapse to the survivor.
DUPLICATE_KEYS = {'wsu_irrigation_sensors': 'wsu_soil_moisture'}

# The .bib records the URL as first published; these have since moved. Following the
# redirect here saves the reader's browser a hop and keeps the link stable.
URL_REDIRECTS = {
    'https://ucanr.edu/?legacy-file=19114.pdf&legacy-file-path=sites/kingscounty/files/':
        'https://ucanr.edu/sites/default/files/2010-06/19114.pdf',
    'https://www.licor.com/env/support/LAI-2200C/manuals.html':
        'https://www.licor.com/support/LAI-2200C/manuals.html',
}

# Stage name as it appears in tablesData.json -> stage_code in the `stage` table.
# Mirrors stageCodeMapping in app/templates/tree_lifecycle.html.
SITE_STAGE_CODES = {
    'Seed Germination': 'NDG00',
    'Juvenile Period': 'NDG01',
    'Transition Period': 'NDG02',
    'Reproductive Phase': 'NDG03',
    'Aging': 'NDG04',
    'Planting Tree': 'ODG00',
    'Young Tree': 'ODG01',
    'Mature Tree': 'ODG02',
    'End of Productive Life': 'ODG03',
    'Dormancy': 'OAR00',
    'Para-dormancy': 'OAR00-00',
    'Endo-dormancy': 'OAR00-01',
    'Eco-dormancy': 'OAR00-02',
    'Bud Development': 'OAR(01-04)',
    'Leaf Development': 'OAR(10-19)',
    'Shoot Development': 'OAR(31-39)',
    'Shoot Growth Completion': 'OAR79',
    'Inflorescence Emergence': 'OAR(40-45)',
    'Flowering': 'OAR(50-59)',
    'Pollination': 'OAR50-00',
    'Fertilization': 'OAR50-01',
    'Fruit set': 'OAR50-02',
    'Flower Bud Formation for Next Season': 'OAR(60-62)',
    'Flower Induction': 'OAR60',
    'Flower Initiation': 'OAR61',
    'Bud differentiation': 'OAR62',
    'Fruit Development': 'OAR(70-79)',
    'Cell division': 'OAR70-00',
    'Cell enlargement': 'OAR70-01',
    'Maturity of Fruit and Seed': 'OAR(80-89)',
    'Leaf Senescence': 'OAR(90-93)',
}

# Named instruments and methods to surface as a separate drawer field. Order matters
# only for readability of the resulting list.
INSTRUMENT_TERMS = [
    'orchard weather station', 'quantum sensor', 'linear ceptometer', 'ceptometer',
    'temperature probe', 'capacitance', 'TDR probe', 'tensiometer',
    'matric-potential sensor', 'electromagnetic or conductivity sensor',
    'root-image analysis', 'calipers', 'survey pole', 'leaf-area meter',
    'CI-110 Plant Canopy Imager', 'LAI-2200C', 'SPAD meter',
    'infrared gas analyser', 'IRGA', 'PAM fluorometer', 'pressure chamber',
    'microtensiometer', 'infrared radiometer', 'thermal camera', 'thermal image',
    'dendrometer', 'penetrometer', 'refractometer', 'pH meter', 'colorimeter',
    'spectrophotometer', 'DA meter', 'GC-FID', 'UHPLC-MS/MS', 'LC-MS/MS', 'HPLC',
    'AAS', 'ICP', 'Kjeldahl', 'fluorescence microscopy', 'light microscopy',
    'increment core', 'pheromone trap', 'aniline blue', 'iodine', 'scanned',
    'oven-dry', 'balance', 'tape',
]

# LaTeX symbols that carry meaning in the protocol prose. Substituted before
# unrecognised commands are stripped.
SYMBOLS = {
    r'\\pi': 'π', r'\\circ': '°', r'\\times': '×', r'\\pm': '±',
    r'\\leq': '<=', r'\\geq': '>=', r'\\mu': 'µ', r'\\alpha': 'α',
    r'\\beta': 'β', r'\\Delta': 'Δ', r'\\approx': '~',
}

ACCENTS = {
    ("'", 'a'): 'á', ("'", 'e'): 'é', ("'", 'i'): 'í', ("'", 'o'): 'ó',
    ("'", 'u'): 'ú', ("'", 'c'): 'ć', ("'", 'n'): 'ń', ("'", 's'): 'ś',
    ('"', 'a'): 'ä', ('"', 'e'): 'ë', ('"', 'o'): 'ö', ('"', 'u'): 'ü',
    ('^', 'a'): 'â', ('^', 'e'): 'ê', ('^', 'i'): 'î', ('^', 'o'): 'ô',
    ('`', 'a'): 'à', ('`', 'e'): 'è', ('~', 'n'): 'ñ',
}

# The ten Table S4B section headings, mapped to the short labels the portal shows in
# the Key Measurements column -- the full headings are far too long for a table cell,
# so they are kept as the hover title and shown in the drawer instead. Order here is
# source order, which is also the order categories are listed in each cell.
# 'other' is the bucket for measurements with no S4B protocol (Image, Fruit quality).
CATEGORY_LABELS = [
    ('environment',   'Environment',                  'Environmental, timing and orchard context'),
    ('soil',          'Soil & root-zone',             'Soil and root-zone'),
    ('tree-identity', 'Tree identity & establishment', 'Tree identity, establishment and natural developmental traits'),
    ('roots',         'Root system',                  'Root system'),
    ('canopy',        'Canopy & yield',               'Tree size, canopy, crop load and productivity'),
    ('buds',          'Buds & dormancy',              'Bud, dormancy and reserve status'),
    ('leaves',        'Leaves',                       'Leaf morphology, physiology and nutrients'),
    ('flowering',     'Flowering & pollination',      'Flowering, pollination and flower-bud formation'),
    ('fruit',         'Fruit growth & quality',       'Fruit growth, maturity and quality'),
    ('health',        'IPDM & senescence',            'IPDM, senescence and end of productive life'),
    ('other',         'Other',                        'Not covered by a Table S4B protocol'),
]

# Formulas that appear in the protocol prose, keyed by a distinctive substring.
FORMULAS = {
    'trunk cross-sectional area': r'TCSA = C^{2}/(4\pi)',
    'light interception': r'1 - I_{below}/I_{above}',
    'absorbance difference': r'I_{AD} = A_{670} - A_{720}',
    'maximum daily trunk shrinkage': r'MDS = D_{max,daily} - D_{min,daily}',
}


# --------------------------------------------------------------------------
# LaTeX helpers
# --------------------------------------------------------------------------

def detex(text):
    """Turn a LaTeX cell into the plain text the website will display."""
    text = text.replace('\\%', '%').replace('\\&', '&').replace('\\_', '_')
    text = text.replace('\\#', '#').replace('\\$', '$')
    text = re.sub(r'\$\\rightarrow\$', '->', text)
    text = re.sub(r'\$>\s*([\d.]+)\$', r'>\1', text)
    text = re.sub(r'\$<\s*([\d.]+)\$', r'<\1', text)
    text = re.sub(r'\\textbf\{([^{}]*)\}', r'\1', text)
    text = re.sub(r'\\textit\{([^{}]*)\}', r'\1', text)
    text = re.sub(r'\\emph\{([^{}]*)\}', r'\1', text)
    text = re.sub(r'\\text\{([^{}]*)\}', r'\1', text)
    text = re.sub(r'\\mathrm\{([^{}]*)\}', r'\1', text)
    text = re.sub(r'\\citep?\{[^}]*\}', '', text)
    # ranges: 15--20 -> 15-20, but keep an em dash as a dash
    text = text.replace('--', '-')
    text = re.sub(r'\$([^$]*)\$', r'\1', text)
    text = text.replace('\\,', ' ').replace('\\;', ' ')
    # Accents in author names: {\'a} -> á, {\"u} -> ü, {\^i} -> î.
    text = re.sub(r'\{?\\([\'"`^~])\{?([a-zA-Z])\}?\}?',
                  lambda m: ACCENTS.get((m.group(1), m.group(2)), m.group(2)), text)
    # Symbols must be substituted before unknown commands are dropped, or
    # "TCSA=C^2/(4\pi)" silently becomes "TCSA=C^2/(4)".
    for command, symbol in SYMBOLS.items():
        text = re.sub(command + r'(?![a-zA-Z])', symbol, text)
    text = re.sub(r'\\[a-zA-Z]+', '', text)
    text = text.replace('{', '').replace('}', '')
    text = re.sub(r'\s+', ' ', text)
    return text.strip()


def sql_str(value):
    if value is None or value == '':
        return 'NULL'
    return "'" + str(value).replace("'", "''") + "'"


def sql_required(value, fallback=''):
    """For reference_data.title / .author, which are NOT NULL. Institutional
    protocol sources (@misc) often carry an organization instead of an author."""
    return "'" + str(value if value else fallback).replace("'", "''") + "'"


# --------------------------------------------------------------------------
# Stage code expansion
# --------------------------------------------------------------------------

def stage_interval(code):
    """Numeric interval covered by a stage_code in the `stage` table.

    Returns (family, lo, hi). Parenthesised OAR codes are ranges; a bare
    hyphen (OAR50-01) marks a sub-stage of its parent, not a range.
    """
    m = re.match(r'^(NDG|ODG)(\d+)$', code)
    if m:
        n = int(m.group(2))
        return (m.group(1), n, n)

    m = re.match(r'^OAR\((\d+)-(\d+)\)-BB-(\d+)$', code)
    if m:
        n = int(m.group(3))
        return ('OAR', n, n)

    m = re.match(r'^OAR\((\d+)-(\d+)\)$', code)
    if m:
        return ('OAR', int(m.group(1)), int(m.group(2)))

    m = re.match(r'^OAR(\d+)-(\d+)$', code)
    if m:
        # sub-stage: OAR50-01 lives at BBCH 50, it is not the range 50..1
        n = int(m.group(1))
        return ('OAR', n, n)

    m = re.match(r'^OAR(\d+)$', code)
    if m:
        n = int(m.group(1))
        return ('OAR', n, n)

    return None


def expand_scope(scope, known_codes):
    """Map an S4B `Stage(s)` cell onto concrete stage_codes.

    'NDG00; ODG00--03; OAR00--93' -> every stage_code whose interval falls inside
    one of those windows. 'OAR70--00' wraps past the end of the annual cycle and is
    expanded as OAR70..OAR93 plus OAR00. Bare tokens with no code (e.g. 'postharvest')
    are ignored here but retained verbatim in stage_scope.
    """
    windows = []
    unmatched = []
    for token in scope.split(';'):
        token = token.strip()
        if not token:
            continue
        m = re.match(r'^(NDG|ODG|OAR)(\d+)--(\d+)$', token)
        if m:
            family, lo, hi = m.group(1), int(m.group(2)), int(m.group(3))
            if lo > hi:  # wraps past the end of the annual cycle
                windows.append((family, lo, 99))
                windows.append((family, 0, hi))
            else:
                windows.append((family, lo, hi))
            continue
        m = re.match(r'^(NDG|ODG|OAR)(\d+)$', token)
        if m:
            n = int(m.group(2))
            windows.append((m.group(1), n, n))
            continue
        unmatched.append(token)

    # A stage is in scope when its BBCH window overlaps one of the scope windows.
    # Containment would be too strict: protocols scoped OAR80--82 must still reach
    # the portal's 'Maturity of Fruit and Seed' stage, whose code is OAR(80-89).
    codes = []
    for code in known_codes:
        iv = stage_interval(code)
        if not iv:
            continue
        family, lo, hi = iv
        for wfamily, wlo, whi in windows:
            if family == wfamily and lo <= whi and hi >= wlo:
                codes.append(code)
                break

    return prune_to_broadest(codes), codes, unmatched


def prune_to_broadest(codes):
    """Keep only the highest-level stage in each matched branch.

    A protocol scoped OAR10--82 overlaps the Flowering range OAR(50-59) and also
    every one of its children (OAR50, OAR55, OAR50-00 ...). Attaching it to all of
    them would bury each sub-stage row under dozens of inherited protocols, so the
    children are dropped whenever their parent is already in the set.
    """
    intervals = {code: stage_interval(code) for code in codes}
    kept = []
    for code in codes:
        family, lo, hi = intervals[code]
        has_ancestor = False
        for other in codes:
            if other == code:
                continue
            ofamily, olo, ohi = intervals[other]
            if ofamily != family or not (olo <= lo and ohi >= hi):
                continue
            wider = (ohi - olo) > (hi - lo)
            same_window_but_shorter_code = (olo, ohi) == (lo, hi) and len(other) < len(code)
            if wider or same_window_but_shorter_code:
                has_ancestor = True
                break
        if not has_ancestor:
            kept.append(code)
    return kept


# --------------------------------------------------------------------------
# Parsers
# --------------------------------------------------------------------------

def split_rows(body):
    """Split a longtable body into logical rows on the `\\\\` row terminator."""
    rows = []
    for chunk in re.split(r'\\\\\s*\n', body):
        chunk = chunk.strip()
        if chunk:
            rows.append(chunk)
    return rows


def parse_tex():
    with open(TEX, encoding='utf-8') as fh:
        tex = fh.read()

    tables = re.findall(r'\\begin\{longtable\}(.*?)\\end\{longtable\}', tex, re.S)
    if len(tables) != 2:
        sys.exit('expected 2 longtables in the .tex, found %d' % len(tables))

    s4a, s4b = [], []
    for index, table in enumerate(tables):
        body = table.split('\\endlastfoot', 1)[1]
        category = None
        for row in split_rows(body):
            if row.startswith('\\bottomrule') or row.startswith('\\midrule'):
                continue
            header = re.match(r'\\multicolumn\{4\}\{l\}\{\\textbf\{(.+?)\}\}', row, re.S)
            if header:
                category = detex(header.group(1))
                continue
            if row.startswith('\\multicolumn'):
                continue
            cells = [c.strip() for c in row.split('&')]
            if len(cells) != 4:
                continue
            refs = re.findall(r'\\citep?\{([^}]*)\}', cells[3])
            keys = []
            for group in refs:
                for key in group.split(','):
                    key = key.strip()
                    key = DUPLICATE_KEYS.get(key, key)
                    if key and key not in keys:
                        keys.append(key)
            record = {
                'col1': detex(cells[0]),
                'col2': detex(cells[1]).replace('-', '--') if index == 1 else detex(cells[1]),
                'col2_raw': cells[1].strip(),
                'col3': detex(cells[2]),
                'refs': keys,
                'category': category,
            }
            (s4a if index == 0 else s4b).append(record)
    return s4a, s4b


def parse_bib():
    with open(BIB, encoding='utf-8') as fh:
        raw = fh.read()

    entries = []
    for match in re.finditer(r'@(\w+)\s*\{\s*([^,]+),', raw):
        entry_type = match.group(1).lower()
        key = match.group(2).strip()
        start = match.end()
        depth = 1
        i = match.start()
        # walk from the opening brace of the entry to its matching close
        i = raw.index('{', match.start())
        depth = 0
        for j in range(i, len(raw)):
            if raw[j] == '{':
                depth += 1
            elif raw[j] == '}':
                depth -= 1
                if depth == 0:
                    body = raw[start:j]
                    break
        fields = {}
        for fmatch in re.finditer(r'(\w+)\s*=\s*', body):
            name = fmatch.group(1).lower()
            pos = fmatch.end()
            if pos >= len(body):
                continue
            if body[pos] == '{':
                depth = 0
                for k in range(pos, len(body)):
                    if body[k] == '{':
                        depth += 1
                    elif body[k] == '}':
                        depth -= 1
                        if depth == 0:
                            fields[name] = body[pos + 1:k]
                            break
            else:
                end = body.find(',', pos)
                fields[name] = body[pos:end if end != -1 else len(body)].strip()
        entries.append({
            'key': key,
            'type': entry_type,
            'title': detex(fields.get('title', '')),
            'author': detex(fields.get('author', '')),
            'year': fields.get('year', '').strip(),
            'publisher': detex(fields.get('publisher') or fields.get('journal')
                               or fields.get('organization') or ''),
            'url': URL_REDIRECTS.get(
                (fields.get('url') or '').strip().replace('\\&', '&'),
                (fields.get('url') or '').strip().replace('\\&', '&')),
        })
    return [e for e in entries if e['key'] not in DUPLICATE_KEYS]


def parse_csv_basis():
    """`Protocol basis` per indicator. The CSV keeps raw LaTeX math ($F_v/F_m$)
    where the .tex cell has already been detexed, so key on the detexed form."""
    basis = {}
    with open(CSV_FILE, encoding='utf-8') as fh:
        for row in csv.DictReader(fh):
            basis[detex(row['Indicator(s)'])] = row['Protocol basis'].strip()
    return basis


def parse_site_measurements():
    """Pull the Key Measurements column out of each row in tablesData.json."""
    with open(TABLES_JSON, encoding='utf-8') as fh:
        data = json.load(fh)

    result = {}
    for stage_name, row_html in data.items():
        cells = re.findall(r'<td>(.*?)</td>', row_html, re.S)
        if len(cells) < 4:
            continue
        items = []
        for part in re.split(r'<br\s*/?>', cells[3], flags=re.I):
            text = re.sub(r'<[^>]+>', '', part)
            text = re.sub(r'cite\{[^}]*\}', '', text)
            text = text.strip()
            text = re.sub(r'^-\s*', '', text).strip()
            # A couple of entries end in a full stop where the rest do not.
            text = text.rstrip('.').strip()
            if text and text.upper() != 'NA':
                items.append(text)
        result[stage_name] = items
    return result


# --------------------------------------------------------------------------
# Derived fields
# --------------------------------------------------------------------------

def find_formula(protocol_text, indicator):
    haystack = (protocol_text + ' ' + indicator).lower()
    for needle, formula in FORMULAS.items():
        if needle in haystack:
            return formula
    return None


def find_instruments(protocol_text):
    found = []
    lowered = protocol_text.lower()
    for term in INSTRUMENT_TERMS:
        if term.lower() in lowered and term not in found:
            found.append(term)
    return '; '.join(found) if found else None


def build_variant_lookup(indicators):
    """`Leaf area index (LAI): optical canopy analyser` names one of three ways to
    measure the same indicator. Only treat the text after a colon as a method
    variant when at least two rows share the same prefix, so single rows such as
    `Rootstock:scion diameter ratio at graft union` are left alone.
    """
    prefixes = collections.Counter(
        ind.split(':', 1)[0].strip() for ind in indicators if ':' in ind)
    shared = {prefix for prefix, count in prefixes.items() if count > 1}
    return lambda ind: (ind.split(':', 1)[1].strip()
                        if ':' in ind and ind.split(':', 1)[0].strip() in shared
                        else None)


# --------------------------------------------------------------------------
# SQL emission
# --------------------------------------------------------------------------

SCHEMA = """
-- ---------------------------------------------------------------------------
-- Measurement protocols (Table S4B) and lifecycle transition criteria (S4A).
-- Generated by tools/build_protocol_sql.py -- do not edit by hand.
-- ---------------------------------------------------------------------------

ALTER TABLE reference_data ADD COLUMN IF NOT EXISTS url TEXT;
ALTER TABLE reference_data ADD COLUMN IF NOT EXISTS source_type TEXT;

DROP TABLE IF EXISTS protocol_reference;
DROP TABLE IF EXISTS protocol_stage;
DROP TABLE IF EXISTS stage_transition_reference;
DROP TABLE IF EXISTS stage_transition;

ALTER TABLE key_measurement DROP COLUMN IF EXISTS protocol_id;
-- measurement_protocol references measurement_category, so it has to go first or the
-- FK blocks the drop on every boot after the first.
DROP TABLE IF EXISTS measurement_protocol;
DROP TABLE IF EXISTS measurement_category;

-- The Table S4B section headings, normalised so the portal can group the Key
-- Measurements column by category and drill into one category at a time.
CREATE TABLE measurement_category (
    category_id   SERIAL PRIMARY KEY,
    category_key  TEXT UNIQUE NOT NULL,
    short_label   TEXT NOT NULL,
    full_name     TEXT NOT NULL,
    display_order INT NOT NULL
);

CREATE TABLE measurement_protocol (
    protocol_id    SERIAL PRIMARY KEY,
    indicator      TEXT NOT NULL,
    category       TEXT,                 -- verbatim S4B heading, kept for source fidelity
    category_id    INT REFERENCES measurement_category(category_id),
    method_variant TEXT,
    stage_scope    TEXT,
    protocol_text  TEXT NOT NULL,
    protocol_basis TEXT,
    formula_latex  TEXT,
    instruments    TEXT
);

CREATE TABLE protocol_stage (
    protocol_id INT REFERENCES measurement_protocol(protocol_id) ON DELETE CASCADE,
    stage_id    INT REFERENCES stage(stage_id),
    PRIMARY KEY (protocol_id, stage_id)
);

CREATE TABLE protocol_reference (
    protocol_id  INT REFERENCES measurement_protocol(protocol_id) ON DELETE CASCADE,
    reference_id INT REFERENCES reference_data(id),
    PRIMARY KEY (protocol_id, reference_id)
);

CREATE TABLE stage_transition (
    transition_id          SERIAL PRIMARY KEY,
    row_kind               TEXT CHECK (row_kind IN ('transition','stage_progression')),
    from_stage_code        TEXT,
    to_stage_code          TEXT,
    operational_criterion  TEXT NOT NULL,
    quantitative_reference TEXT
);

CREATE TABLE stage_transition_reference (
    transition_id INT REFERENCES stage_transition(transition_id) ON DELETE CASCADE,
    reference_id  INT REFERENCES reference_data(id),
    PRIMARY KEY (transition_id, reference_id)
);

ALTER TABLE key_measurement ADD COLUMN IF NOT EXISTS protocol_id INT
    REFERENCES measurement_protocol(protocol_id);
ALTER TABLE key_measurement ADD COLUMN IF NOT EXISTS display_order INT;
ALTER TABLE key_measurement ADD COLUMN IF NOT EXISTS origin TEXT;

DELETE FROM key_measurement;

CREATE INDEX IF NOT EXISTS idx_key_measurement_stage ON key_measurement(stage_id);
CREATE INDEX IF NOT EXISTS idx_protocol_stage_stage ON protocol_stage(stage_id);
"""


def build(known_codes):
    s4a, s4b = parse_tex()
    bib = parse_bib()
    basis_by_indicator = parse_csv_basis()
    site_measurements = parse_site_measurements()

    with open(MAP_FILE, encoding='utf-8') as fh:
        measurement_map = {k: v for k, v in json.load(fh).items()
                           if not k.startswith('_')}
    for item, number in measurement_map.items():
        if not isinstance(number, int) or not 1 <= number <= len(s4b):
            sys.exit('measurement_protocol_map.json: %r maps to %r, which is not a '
                     'valid S4B row number (1-%d)' % (item, number, len(s4b)))

    out = [SCHEMA]
    warnings = []
    method_variant = build_variant_lookup([r['col1'] for r in s4b])

    # --- references -------------------------------------------------------
    out.append('\n-- References from the S4A/S4B bibliography (%d entries).' % len(bib))
    # Clear out rows a previous run of this generator inserted, so edits to the .bib
    # or to detex() take effect. source_type is only ever set by this file, so rows
    # that came from mybibliography.bib are left alone even if a key collides.
    out.append("DELETE FROM reference_data WHERE source_type IS NOT NULL AND bibtex_key IN (%s);"
               % ', '.join(sql_str(e['key']) for e in bib))
    for entry in bib:
        year = entry['year'] if re.match(r'^\d{4}$', entry['year'] or '') else 'NULL'
        out.append(
            "INSERT INTO reference_data (bibtex_key, title, author, year, publisher, "
            "bibtex_entry, url, source_type)\n"
            "SELECT {k}, {t}, {a}, {y}, {p}, ' ', {u}, {st}\n"
            "WHERE NOT EXISTS (SELECT 1 FROM reference_data WHERE bibtex_key = {k});".format(
                k=sql_str(entry['key']), t=sql_required(entry['title'], entry['key']),
                a=sql_required(entry['author'], entry['publisher']),
                y=year, p=sql_str(entry['publisher']),
                u=sql_str(entry['url']), st=sql_str(entry['type'])))

    # --- categories -------------------------------------------------------
    category_ids = {full: i for i, (_, _, full) in enumerate(CATEGORY_LABELS, start=1)}
    out.append('\n-- Table S4B section headings, as browsable categories.')
    for i, (key, short_label, full) in enumerate(CATEGORY_LABELS, start=1):
        out.append("INSERT INTO measurement_category (category_id, category_key, short_label, "
                   "full_name, display_order) VALUES ({i}, {k}, {s}, {f}, {i});".format(
                       i=i, k=sql_str(key), s=sql_str(short_label), f=sql_str(full)))
    out.append("SELECT setval('measurement_category_category_id_seq', %d, true);"
               % len(CATEGORY_LABELS))

    # A section heading the .tex introduces but CATEGORY_LABELS does not know would
    # otherwise land silently in 'other'; fail instead so the source revision is noticed.
    unknown = sorted({row['category'] for row in s4b
                      if row['category'] and row['category'] not in category_ids})
    if unknown:
        sys.exit('CATEGORY_LABELS is missing these Table S4B section headings: %s'
                 % ', '.join(repr(u) for u in unknown))

    # --- protocols --------------------------------------------------------
    out.append('\n-- Table S4B: %d measurement protocols.' % len(s4b))
    protocol_stage_pairs = []
    protocol_ref_pairs = []
    indicator_to_index = {}
    # every stage a protocol touches, before ancestor-pruning; used only to rescue
    # sub-stages that would otherwise end up with no measurements at all
    protocols_by_stage_unpruned = {}

    for i, row in enumerate(s4b, start=1):
        indicator = row['col1']
        indicator_to_index.setdefault(indicator, i)
        scope_raw = row['col2_raw']
        codes, all_codes, unmatched = expand_scope(scope_raw, known_codes)
        for code in all_codes:
            protocols_by_stage_unpruned.setdefault(code, []).append(i)
        if not codes:
            warnings.append('no stage matched for S4B row %d (%s): %s'
                            % (i, indicator[:50], scope_raw))
        for token in unmatched:
            warnings.append('S4B row %d: stage token %r has no stage_code' % (i, token))

        basis = basis_by_indicator.get(indicator)
        if basis is None:
            basis = 'Source paper protocol'
            warnings.append('S4B row %d (%s) has no CSV counterpart; basis defaulted'
                            % (i, indicator[:50]))

        out.append(
            "INSERT INTO measurement_protocol (protocol_id, indicator, category, category_id, "
            "method_variant, stage_scope, protocol_text, protocol_basis, formula_latex, "
            "instruments) VALUES ({i}, {ind}, {cat}, {cid}, {mv}, {sc}, {pt}, {pb}, {f}, {inst});".format(
                i=i, ind=sql_str(indicator), cat=sql_str(row['category']),
                cid=category_ids.get(row['category'], 'NULL'),
                mv=sql_str(method_variant(indicator)),
                sc=sql_str(detex(scope_raw)), pt=sql_str(row['col3']),
                pb=sql_str(basis), f=sql_str(find_formula(row['col3'], indicator)),
                inst=sql_str(find_instruments(row['col3']))))

        for code in codes:
            protocol_stage_pairs.append((i, code))
        for key in row['refs']:
            protocol_ref_pairs.append((i, key))

    out.append("SELECT setval('measurement_protocol_protocol_id_seq', %d, true);" % len(s4b))

    out.append('\n-- protocol -> stage (%d links)' % len(protocol_stage_pairs))
    for pid, code in protocol_stage_pairs:
        out.append("INSERT INTO protocol_stage (protocol_id, stage_id) "
                   "SELECT {p}, stage_id FROM stage WHERE stage_code = {c} "
                   "ON CONFLICT DO NOTHING;".format(p=pid, c=sql_str(code)))

    out.append('\n-- protocol -> reference (%d links)' % len(protocol_ref_pairs))
    for pid, key in protocol_ref_pairs:
        out.append("INSERT INTO protocol_reference (protocol_id, reference_id) "
                   "SELECT {p}, id FROM reference_data WHERE bibtex_key = {k} "
                   "ON CONFLICT DO NOTHING;".format(p=pid, k=sql_str(key)))

    # --- S4A transitions --------------------------------------------------
    out.append('\n-- Table S4A: %d lifecycle transition criteria (stored, no UI yet).' % len(s4a))
    for i, row in enumerate(s4a, start=1):
        transition = row['col1']
        if '->' in transition:
            src, dst = [p.strip() for p in transition.split('->', 1)]
            kind = 'transition'
        else:
            src, dst = None, transition.strip()
            kind = 'stage_progression'
        out.append(
            "INSERT INTO stage_transition (transition_id, row_kind, from_stage_code, "
            "to_stage_code, operational_criterion, quantitative_reference) "
            "VALUES ({i}, {k}, {f}, {t}, {c}, {q});".format(
                i=i, k=sql_str(kind), f=sql_str(src), t=sql_str(dst),
                c=sql_str(row['col2']), q=sql_str(row['col3'])))
        for key in row['refs']:
            out.append("INSERT INTO stage_transition_reference (transition_id, reference_id) "
                       "SELECT {i}, id FROM reference_data WHERE bibtex_key = {k} "
                       "ON CONFLICT DO NOTHING;".format(i=i, k=sql_str(key)))
    out.append("SELECT setval('stage_transition_transition_id_seq', %d, true);" % len(s4a))

    # --- key measurements -------------------------------------------------
    # Which protocols apply to each stage, for the 's4b' top-up pass.
    protocols_by_stage = {}
    for pid, code in protocol_stage_pairs:
        protocols_by_stage.setdefault(code, []).append(pid)

    site_count = 0
    s4b_count = 0
    unmapped = []
    out.append('\n-- Key measurements: site wording first, then S4B indicators not already covered.')

    for stage_name, items in site_measurements.items():
        code = SITE_STAGE_CODES.get(stage_name)
        if not code:
            warnings.append('tablesData.json stage %r has no stage_code' % stage_name)
            continue

        covered = set()
        order = 0
        for item in items:
            order += 1
            site_count += 1
            pid = measurement_map.get(item)
            if pid:
                covered.add(pid)
            else:
                unmapped.append((stage_name, item))
            protocol_sql = str(pid) if pid else 'NULL'
            out.append(
                "INSERT INTO key_measurement (stage_id, reference_id, measurement_name, "
                "display_order, origin, protocol_id) SELECT stage_id, NULL, {n}, {o}, 'site', {p} "
                "FROM stage WHERE stage_code = {c};".format(
                    n=sql_str(item), o=order, p=protocol_sql, c=sql_str(code)))

        # A sub-stage inherits nothing from its parent by design, but a stage that
        # would otherwise render an empty cell (Flower Induction lists only "NA")
        # falls back to every protocol whose scope touches it.
        additions = protocols_by_stage.get(code, [])
        if not items and not additions:
            additions = protocols_by_stage_unpruned.get(code, [])
            if additions:
                warnings.append('stage %s (%s) had no measurements; filled from %d '
                                'protocols whose scope covers it'
                                % (code, stage_name, len(additions)))

        for pid in additions:
            if pid in covered:
                continue
            covered.add(pid)
            order += 1
            s4b_count += 1
            out.append(
                "INSERT INTO key_measurement (stage_id, reference_id, measurement_name, "
                "display_order, origin, protocol_id) SELECT s.stage_id, NULL, p.indicator, "
                "{o}, 's4b', p.protocol_id FROM stage s, measurement_protocol p "
                "WHERE s.stage_code = {c} AND p.protocol_id = {p};".format(
                    o=order, c=sql_str(code), p=pid))

    stats = {
        'protocols': len(s4b),
        'transitions': len(s4a),
        'references': len(bib),
        'site_measurements': site_count,
        's4b_measurements': s4b_count,
        'unmapped': unmapped,
        'warnings': warnings,
    }
    return '\n'.join(out) + '\n', stats


def main():
    # The stage_codes that exist in the database, read straight from natural.sql
    # so the two files cannot drift apart.
    with open(os.path.join(ROOT, 'app', 'config', 'natural.sql'), encoding='utf-8') as fh:
        natural = fh.read()
    block = re.search(r'INSERT INTO stage \(stage_code, stage_name, description\) VALUES(.*?);',
                      natural, re.S)
    known_codes = re.findall(r"^\('([^']+)'", block.group(1), re.M)
    if not known_codes:
        sys.exit('could not read stage codes from natural.sql')

    sql, stats = build(known_codes)

    os.makedirs(os.path.dirname(OUT_MIGRATION), exist_ok=True)
    with open(OUT_BOOT, 'w', encoding='utf-8') as fh:
        fh.write(sql)
    with open(OUT_MIGRATION, 'w', encoding='utf-8') as fh:
        fh.write('-- Standalone migration: measurement protocols (Tables S4A/S4B).\n'
                 '-- Safe to run against an existing database; recreates only the new\n'
                 '-- protocol tables and re-seeds key_measurement.\n'
                 'BEGIN;\n' + sql + 'COMMIT;\n')

    print('stage_codes read from natural.sql : %d' % len(known_codes))
    print('measurement_protocol rows         : %d' % stats['protocols'])
    print('stage_transition rows             : %d' % stats['transitions'])
    print('reference_data rows added         : %d' % stats['references'])
    print("key_measurement origin='site'     : %d" % stats['site_measurements'])
    print("key_measurement origin='s4b'      : %d" % stats['s4b_measurements'])
    print('site items with no protocol       : %d' % len(stats['unmapped']))
    for stage_name, item in stats['unmapped']:
        print('    unmapped: %-34s %s' % (stage_name, item))
    if stats['warnings']:
        print('\nwarnings (%d):' % len(stats['warnings']))
        for warning in stats['warnings']:
            print('    ' + warning)
    print('\nwrote %s' % os.path.relpath(OUT_BOOT, ROOT))
    print('wrote %s' % os.path.relpath(OUT_MIGRATION, ROOT))


if __name__ == '__main__':
    main()
