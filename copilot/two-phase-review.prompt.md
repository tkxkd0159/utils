---
mode: agent
---

# GOAL
Review all changes between the `origin/main` branch and the current `HEAD`, and generate a single, high-quality, validated code review document named **`REPORT-$ARGUMENTS.md`**.

---

# PROCESS
You must follow this three-phase process sequentially without deviation. Trust all commands in the instructions below to set up and clean up your environment.

## PHASE 1: Data Gathering & Initial Draft Generation
1.  **Fetch Latest Changes:** Run `git fetch origin main --prune`.

2.  **Generate Diffs:** Create the necessary diff files for your analysis:
    * `git diff --no-color --minimal --find-renames --unified=3 origin/main...HEAD > DIFF.patch && git diff --name-status origin/main...HEAD > FILES.txt`

3.  **Initial Analysis:** Perform a broad review of the changes in `DIFF.patch`. When you review, you must ignore any file under `mocks/`. Your analysis must be guided by the **ANALYSIS_CRITERIA** section below. The goal here is discovery—identify all potential issues.

4.  **Generate Internal Draft:** Based on your initial analysis, create a draft report in your internal memory. **Do NOT save this draft to a file.** This draft, which we'll call `[DRAFT_REPORT]`, is an intermediate artifact for the next phase.

---

## PHASE 2: Critical Self-Correction & Refinement

5.  **Change Perspective:** You will now shift your role to that of a **Principal Engineer** reviewing the `[DRAFT_REPORT]` written by the Staff Engineer. Your goal is to increase the accuracy and value of the report.

6.  **Critique and Refine:** Scrutinize every finding in your internal `[DRAFT_REPORT]` using the code in `DIFF.patch` as the source of truth. You must:
    * **Eliminate False Positives:** Remove any findings that are incorrect, based on a misunderstanding of the code, or are stylistically valid despite not matching your preference.
    * **Challenge Severity:** For each remaining issue, critically re-evaluate its severity. Downgrade any finding that is exaggerated. An N+1 query in a non-critical admin panel is not a `Blocker`.
    * **Simplify Fixes:** Ensure the "Minimal fix" suggestions are truly minimal and do not introduce scope creep. Refine them to be as targeted as possible.
    * **Identify Deeper Issues:** Review the diff one last time from this more senior perspective. Did the initial draft miss subtle but important issues like architectural flaws, incorrect abstractions, or non-obvious race conditions? Add these high-value findings.

---

## PHASE 3: Final Report Generation

7.  **Format Final Report:** Synthesize all your refined findings from Phase 2 into a final report. This report must be formatted *exactly* according to the **OUTPUT_FORMAT** section below.

8.  **Save the Final Report:** Your final action is to save the complete, validated, and refined output to a single file named **`REPORT-$ARGUMENTS.md`**. This is your only file output for the entire process and **DO NOT print the report to the terminal and save only**.

---

# ANALYSIS_CRITERIA (For Phase 1)
* **Correctness & Edge Cases:** Logic errors, nullability, boundaries, error paths, concurrency, timeouts, resource leaks.
* **Security & Privacy:** Injection, XSS/CSRF/SSRF, path traversal, deserialization, secrets handling, PII logging.
* **Performance:** Algorithmic complexity ($O(n)$), hot paths, N+1 queries, unnecessary allocations, blocking I/O.
* **API & Compatibility:** Breaking changes, migrations, flags, rollout/rollback safety.
* **Testing:** Coverage gaps, missing negative/property/concurrency tests, flake risks.
* **Reliability & Ops:** Error handling, retries, idempotency, observability (logs/metrics/traces), alerting.
* **Maintainability:** Readability, duplication (DRY), coupling, naming, dead code, TODOs, comment accuracy.
* **Style/Consistency:** Project conventions, lint rules, type hints.

---

# OUTPUT_FORMAT (For Phase 3)
Your final `REPORT-$ARGUMENTS.md` file must contain the following sections exactly as described.

> **VERDICT:** *One of: [Approve | Approve w/ nits | Request changes | Blocker]*
>
> **TRIAGE SUMMARY:** *(Max 10 lines)* A high-level summary of what changed, key risk areas, and the justification for your verdict.
>
> **ISSUES TABLE:**
> *Highest impact issues first.*
>
> | Sev | File:Line | Finding | Why it matters | Minimal fix |
> |---|---|---|---|---|
> | Blocker | | | | |
> | High | | | | |
> | Med | | | | |
> | Low | | | | |
> | Nit | | | | |
>
> **PERF NOTES:**
> *Call out big-O and rough cost deltas, especially in hot code paths.*
>
> **SECURITY NOTES:**
> *Cite exact risky lines, describe the threat model, and provide a minimal safe change.*
>
> **RELEASE/OPS:**
> *Note any migrations, flags, rollback procedures, metrics to watch, or alerts to adjust.*
>
> **NICE-TO-HAVES:**
> *A brief, non-blocking list of potential future improvements.*
>
> **OPEN QUESTIONS:**
> *List any unknowns that block certainty and state what evidence would resolve them.*
