---
name: "csv-explore"
description: "Explore a CSV file interactively in chat. Shows shape, columns, and lets the user pick a view: focused markdown table, column stats, value frequencies, or an HTML viewer opened in the browser."
---

# CSV Explore

Interactively explore a CSV file. Detects which tool is available and uses it exclusively, following a fixed priority: **duckdb → qsv → csvkit**.

## Invocation

```
/csv-explore <path> [col1,col2,...]
```

- `path` — relative or absolute path to the CSV file (required)
- `col1,col2,...` — optional comma-separated column names or numbers to pre-select

## Workflow

### Step 0 — Pick the tool

Run `command -v duckdb qsv csvlook` once. Use the first available tool for **all** operations in this session. If none are found, stop and show the install hints.

### Step 1 — Resolve the file

If the path is relative, resolve from the current working directory. If it does not exist, say so and stop.

### Step 2 — Detect headers and prepare the file

Check the first row of the file:
- If it looks like column names (short words, snake_case, camelCase) → file has headers, use as-is.
- If it looks like data (UUID, large integer, timestamp, raw values) → file is **headerless**. Tell the user. Prepend the header row to a temp file: `{ echo "$HEADERS"; cat file; } > /tmp/csv_with_headers.csv` and use `/tmp/csv_with_headers.csv` for all subsequent commands.

With duckdb, use `head -1` to inspect the first row, then `duckdb -noheader -list -c "SELECT column_name FROM (DESCRIBE SELECT * FROM 'file')"` to list column names.
With qsv/csvkit, use `head -1` to inspect and `qsv headers` / `head -1` to list columns.

### Step 3 — Show shape and column list

Present as `Rows: N  |  Columns: M` followed by a numbered column list in a code block.

| | duckdb | qsv | csvkit |
|---|---|---|---|
| Row count | `duckdb -noheader -list -c "SELECT COUNT(*) FROM 'file'"` | `qsv count file` | `csvstat --count file 2>/dev/null` |
| Column names | `duckdb -noheader -list -c "SELECT column_name FROM (DESCRIBE SELECT * FROM 'file')"` | `qsv headers file` | `head -1 file` split on commas |

### Step 4 — Ask what the user wants

- **Table** — selected columns as a markdown table in chat
- **Stats** — numeric summary per column
- **Frequency** — top-N value counts for selected columns
- **HTML viewer** — sortable/searchable table opened in the browser

If the user provided columns in the invocation args, skip asking which columns and go straight to asking which view.

### Step 5 — Execute the chosen view

---

#### Table

Ask which columns (or offer first 6) and how many rows: **head N** (default 20), **sample N** (random), or **full** (warn if >200 rows and ask to confirm).

| Mode | duckdb | qsv | csvkit |
|---|---|---|---|
| head | `duckdb -markdown -c "SELECT cols FROM 'file' LIMIT N"` | `qsv select cols file \| qsv slice -l N \| qsv table` | `csvcut -c cols file \| head -N \| csvlook 2>/dev/null` |
| sample | `duckdb -markdown -c "SELECT cols FROM 'file' USING SAMPLE N ROWS"` | `qsv select cols file \| qsv sample N \| qsv table` | `csvsql --query "SELECT cols FROM stdin ORDER BY RANDOM() LIMIT N" 2>/dev/null \| csvlook 2>/dev/null` — warn: ~34s on 100k rows |
| full | `duckdb -markdown -c "SELECT cols FROM 'file'"` | `qsv select cols file \| qsv table` | `csvcut -c cols file \| csvlook 2>/dev/null` |

- duckdb and csvkit output markdown tables — render without a code fence.
- qsv outputs fixed-width text — wrap in a code block.

---

#### Stats

| duckdb | qsv | csvkit |
|---|---|---|
| `duckdb -markdown -c "SUMMARIZE SELECT cols FROM 'file'"` | `qsv stats --select cols file \| qsv select field,mean,stddev,min,max,nullcount \| qsv table` | `csvstat --csv -c cols file 2>/dev/null \| csvcut -c column_name,mean,stdev,min,max,nulls \| csvlook 2>/dev/null` |

- duckdb gives the richest output (quartiles included).
- duckdb and csvkit output markdown; qsv needs a code block.

---

#### Frequency

| duckdb | qsv | csvkit |
|---|---|---|
| For each selected column: `duckdb -markdown -c "SELECT col, COUNT(*) AS count FROM 'file' GROUP BY col ORDER BY count DESC LIMIT 10"` | `qsv frequency --select cols file --limit 10 \| qsv table` | `csvstat --freq --freq-count 10 -c cols file 2>/dev/null` |

- duckdb and qsv can be piped through `csvlook` if csvkit is available — but since we use one tool, present as markdown (duckdb) or code block (qsv/csvkit).
- csvkit `--freq` outputs a text report, not a table — wrap in a code block.

---

#### HTML viewer

If the file has more than 10,000 rows, warn the user and ask whether to proceed with all rows or sample down first.

**Convert to JSON:**

| duckdb | qsv | csvkit |
|---|---|---|
| `duckdb -c "COPY (SELECT * FROM 'file') TO '/tmp/csv_data.json' (FORMAT JSON, ARRAY true)"` — correct types, proper JSON array | `qsv tojsonl file 2>/dev/null > /tmp/csv_data.jsonl` — parse with `try/except json.loads` per line | `python3 -c "import csv,json,sys; print(json.dumps(list(csv.DictReader(sys.stdin))))" < file > /tmp/csv_data.json` — values as strings, acceptable for display. Do NOT use `csvjson` — it coerces `0` to boolean `false`. |

**Generate HTML:**

Always write the HTML file using a Python script via Bash (never the Write tool — it fails on large files). Always embed the JSON data inline in the HTML (never reference an external file — `file://` URLs cannot fetch local files due to browser security restrictions).

Use a Python heredoc like:
```
uv run python3 - <<'PY'
import json
# load rows from /tmp/csv_data.json or parse /tmp/csv_data.jsonl
...
html = f"""...<script>const data = {json.dumps(rows)};</script>..."""
with open("/tmp/csv_viewer.html", "w") as f:
    f.write(html)
print(f"{len(rows):,} rows embedded, {len(html):,} bytes")
PY
```

The HTML template should use Tabulator (CDN) with sorting, per-column filtering, pagination (50 rows/page), and movable columns.

Open: `open` (macOS), `xdg-open` (Linux), `start` (Windows). Detect platform with `uname -s`.
Tell the user the file path and the actual embedded row count.

---

### Step 6 — Offer a follow-up

After each view ask: "Want another view, different columns, or a different format?"

---

## Install hints

Detect OS with `uname -s` (`Darwin` = macOS, `Linux` = Linux; Windows: check `$env:OS`).

| Tool | macOS | Linux | Windows |
|---|---|---|---|
| `duckdb` | `brew install duckdb` | GitHub release binary | `winget install DuckDB.cli` |
| `qsv` | `brew install qsv` | `cargo install qsv` or GitHub release binary | `winget install jqp.qsv` or `scoop install qsv` |
| `csvkit` | `uv tool install csvkit` | `uv tool install csvkit` | `uv tool install csvkit` |

Prefer `uv tool install` for csvkit. Fall back to `pip install csvkit` only if `uv` is not available.

## Rules

- Use only the first available tool — do not mix tools within a session.
- duckdb and csvkit output markdown tables natively — render without a code fence.
- qsv outputs fixed-width text — always wrap in a code block.
- For headerless files, always prepend headers to `/tmp/csv_with_headers.csv` before running any commands.
- Never dump the full file to chat. Slice to ≤50 rows for table views unless the user explicitly asks for more.
- Suppress csvkit dialect warnings with `2>/dev/null` throughout.
- Keep the HTML viewer self-contained (single file, CDN links only).
- csvsql sampling is slow (~34s on 100k rows) — always warn the user before running it on large files.
