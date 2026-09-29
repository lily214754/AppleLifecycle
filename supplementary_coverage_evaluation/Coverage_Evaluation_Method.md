# Coverage evaluation method

## Preparation

The question set is 100 questions and answers from the eXtension Apples community site
(apples.extension.org), saved in `Question_Set.csv` with question number, question, answer and the source
URL of each question. Each answer is the eXtension answer page plus the eXtension article it links
to, where there is one. The answers are used only as the reference (gold). The eXtension site itself
is never used as evidence.

For each answer in the question set:

### 1) Decompose the answer into atomic facts

Each answer is split into atomic facts. An atomic fact is one statement that can be true or false.
It keeps the numbers, units, conditions, comparison and direction it needs, and the strength of
the original wording ("can", "should", "must").

- A topic or entity on its own ("dead branches") is not a fact; "dead branches can be removed in
  summer" is.
- A sentence that only repeats an earlier fact is not counted again.
- Table rows with the same attribute and value become one fact listing the members.

Result: 2263 atomic facts over the 100 answers.

### 2) Facts that count in the denominator

A fact counts in the denominator only if it is **apple or apple-orchard information**: the tree,
the fruit, the orchard soil, pests and diseases acting on them, grower operations (timing, rate,
method, outcome), decision rules and thresholds, and legal limits on what the grower may do.

Not counted (decided from the fact's subject before any search, for supported and unsupported
facts alike):

- facts that are not apple information, such as what a catalogue or database lists, an institution's
  history, crops other than apple, or human-health claims; and records tied to a place or a date,
  such as where a disease has been reported or the damage in one year (176 facts);
- NC-140 or other regional trial results, and figures from one trial year (82 facts).

General knowledge that a university published, and general thresholds that contain numbers, stay
in the denominator.

Result: 2005 facts in the denominator.

### 3) Facts that count in the numerator

A fact in the denominator counts in the numerator when the Apple Portal either:

**a) Covers it.** A portal card leads (by its reference link) to an authoritative source (e.g. a
university extension guide, a government handbook, a research book), and that source contains the
information with all its conditions.

**b) Makes it inferable.** No single passage states it, but it follows from portal-linked sources
through a short chain of reasoning, where every premise is in a source and every step is written
down. Rules given to the LLM for inference include:

- *Pollinator example:* a pollinizer works when (1) its pollen is compatible and (2) its bloom
  overlaps the main cultivar's bloom. If a source rates a cultivar as a good pollinizer, and the
  bloom periods of the two cultivars are shown to overlap, the pairing is inferable even though no
  source recommends that exact pair. Ripening dates cannot stand in for bloom dates.
- The strength of the wording is kept: "may" does not support "usually"; one good option is not
  "the best".
- Conditions must match before two sources are combined (cultivar, rootstock, stage, season,
  units, comparison baseline).
- "About N" is supported by a recommended range for the same measure that contains N.
- Ordinary logic, arithmetic and unit conversion are allowed; an agronomic premise is never
  invented, and the gold answer is never evidence.
- When a newer authoritative source on the portal gives a more accurate answer to the same fact,
  it counts (a "modern equivalent"), with the old and new statements, source and reason recorded.

**How coverage is decided.** The portal is the evaluation surface: a fact counts only when a
relevant card on the Apple Portal (https://applelifecycle-3094d65c1fea.herokuapp.com) links to the authoritative site and the information is inside
that site. The LLM judges each fact after searching the portal widely (the fact's own lifecycle
stage first, then other stages; at least three wordings; the value as well as the word; the full
linked page or PDF). If a fact cannot be supported, the judge names the missing piece and it is
**ABSENT**. For every fact `Coverage_Judgements.md` records the verdict, the reasoning, the searches,
the portal route and card, the authoritative source and the evidence quote.

Result: 1487 covered + 399 inferable = 1886 facts in the numerator; 119 absent.

## Calculation

For question $q$:

- $N_q$ = facts of question $q$ in the denominator
- $C_q$ = facts covered, $I_q$ = facts inferable

Coverage accuracy of each question:

$$
\text{Coverage}_q = \frac{C_q + I_q}{N_q}
$$

Overall coverage accuracy (all facts pooled, micro):

$$
\text{Coverage accuracy} = \frac{\sum_{q=1}^{100} (C_q + I_q)}{\sum_{q=1}^{100} N_q}
= \frac{1487 + 399}{2005} = \frac{1886}{2005} = 94.06\%
$$

Mean over questions (macro):

$$
\text{Coverage accuracy}_{macro} = \frac{1}{100} \sum_{q=1}^{100} \text{Coverage}_q = 92.52\%
$$

59 of the 100 questions reach 100%. Each question's $C_q + I_q$, $N_q$ and $\text{Coverage}_q$
are given in the summary table and at the head of each question in `Coverage_Judgements.md`.

