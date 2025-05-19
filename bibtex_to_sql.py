import bibtexparser

def parse_bibtex_to_sql(bibtex_file, output_file):
    with open(bibtex_file) as bibfile:
        bib_database = bibtexparser.load(bibfile)

    

    with open(output_file, 'w') as sqlfile:
        sqlfile.write("DROP TABLE IF EXISTS reference_data;\n")
        sqlfile.write("""
CREATE TABLE reference_data (
    id SERIAL PRIMARY KEY,
    bibtex_key VARCHAR(255) NOT NULL,
    title TEXT NOT NULL,
    author TEXT NOT NULL,
    year INT,
    publisher TEXT,
    bibtex_entry TEXT
);\n""")

        for entry in bib_database.entries:
            bibtex_key = entry.get('ID', '')
            title = entry.get('title', '').replace("'", "''")
            author = entry.get('author', '').replace("'", "''")
            year = entry.get('year', 'NULL')
            publisher = entry.get('publisher', '').replace("'", "''")
            bibtex_entry = ' '
            # f"@{entry['ENTRYTYPE']}{{{bibtex_key},\n" + ',\n'.join([f"  {k}={{'{v}'}}" for k, v in entry.items() if k not in ['ID', 'ENTRYTYPE']]) + '\n}'

            sqlfile.write(f"INSERT INTO reference_data (bibtex_key, title, author, year, publisher, bibtex_entry) VALUES ('{bibtex_key}', '{title}', '{author}', {year}, '{publisher}', '{bibtex_entry}');\n")

if __name__ == "__main__":
    parse_bibtex_to_sql('mybibliography.bib', 'database.sql')
