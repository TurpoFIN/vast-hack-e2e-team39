# Magnificent demo — Rewind (≤2 min)

**Judge one-liner:**
> A picker files a vague report; Rewind rejects the wrong forklift hits, confirms the real contact across 5 cameras to within centimetres of ground truth, and hands you a cited evidence pack — including the blind spot where nobody was looking.

## Run
```bash
cd /workspace/vast-hack
demos/run_magnificent.sh          # artifact replay (default, <1 s)
demos/run_magnificent.sh --rerun  # live investigate when CPU/VLM free
streamlit run app.py
```

Latest scored case: **CASE-1002-112438-9ff8** — INC-013 confirmed, 0.0 s / 0.07 m vs GT.
