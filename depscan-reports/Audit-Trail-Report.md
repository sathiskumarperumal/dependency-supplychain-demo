# Audit-Trail Final Report

Project: **vulnerable-invoice-service** · Stage 5 (aggregate) · Generated 2026-07-07 · Source: `main` @ `61ed8c3` → PR [#65](https://github.com/sathiskumarperumal/dependency-supplychain-demo/pull/65) (`fix/depscan-20260707-062247`) · Health Score: **38 / 100** <span class="badge crit">Grade D — high risk</span>

## Executive summary

- **24** dependencies scanned (Stage 1) · **9** CVEs found on `main` (3 CRITICAL / 1 HIGH / 4 MEDIUM / 1 LOW) across `log4j-core`, `jackson-databind`, `guava`.
- **Supply-chain (Stage 1):** 1 typosquat (`com.fastxml.jackson.core:jackson-databind:2.9.8`) resolving via 1 untrusted HTTP repository — both **removed** in PR #65.
- **Licenses:** 1 violation (`mysql-connector-java` GPL-2.0-with-FOSS-exception) — tracked in [#64](https://github.com/sathiskumarperumal/dependency-supplychain-demo/issues/64), not auto-fixed.
- **Remediation (Stage 3):** PR #65 open — `log4j-core`/`log4j-api` → 2.17.1, `jackson-databind` → 2.13.2.1, `guava` → 32.0.0-jre, typosquat + untrusted repo removed. `mvn test` PASS (2/2).
- **Latest gate outcome (Stage 4):** <span class="badge crit">BLOCK</span> — [review posted](https://github.com/sathiskumarperumal/dependency-supplychain-demo/pull/65#pullrequestreview-4642365468). An independent re-scan of the PR head against current NVD data found the 2.13.2.1 `jackson-databind` target still carries **4 unresolved HIGH CVEs** (needs ≥2.18.8), and `mysql-connector-java` carries **1 unresolved HIGH CVE** on top of its license violation. Tracked in follow-up issue [#66](https://github.com/sathiskumarperumal/dependency-supplychain-demo/issues/66).
- **Not merged.** Per pipeline governance the gate never auto-merges; PR #65 requires the #66 follow-up fix and a clean re-gate before a human can merge it.

## Health score breakdown

Score is computed on the **current PR #65 head** (post-remediation, pre-merge), not `main`.

| Factor | Count | Deduction |
|---|---|---|
| Unresolved CRITICAL CVEs (×−15) | 0 | 0 |
| Unresolved HIGH CVEs (×−8) — 4 on jackson-databind 2.13.2.1 + 1 on mysql-connector-java | 5 | −40 |
| Unresolved MEDIUM CVEs (×−2) | 0 | 0 |
| Supply-chain BLOCK findings (×−10) — denied license (mysql-connector-java) | 1 | −10 |
| Outdated major-version deps (×−3) — jackson-databind, guava, commons-io, junit-jupiter | 4 | −12 |
| **Score (floored at 0)** | | **38 / 100** |

> **Baseline on `main` (pre-PR) scored ~1/100 (Grade D)** — 3 unresolved CRITICAL CVEs, 1 HIGH, 4 MEDIUM,
> 2 supply-chain BLOCK findings (typosquat + untrusted repo), 6 major-outdated deps. PR #65 already
> lifted the score from ~1 to 38 by clearing Log4Shell and the supply-chain typosquat/mirror — real
> progress — but newly-discovered `jackson-databind` CVEs and the unresolved `mysql-connector-java`
> CVE/license question keep the project in **Grade D** until issue #66 is closed.

## Top risks (ranked, current PR head)

| Coordinate | Risk | Band | Top CVE | Status |
|---|---|---|---|---|
| com.fasterxml.jackson.core:jackson-databind:2.13.2.1 | high | <span class="badge high">HIGH</span> | CVE-2022-42003 (+3 more) | needs ≥2.18.8 — tracked in #66 |
| mysql:mysql-connector-java:8.0.30 | high | <span class="badge high">HIGH</span> | CVE-2023-22102 | unresolved CVE + license VIOLATION — tracked in #64, #66 |
| org.apache.logging.log4j:log4j-core/api | — | <span class="badge ok">CLEARED</span> | CVE-2021-44228 (Log4Shell) | fixed → 2.17.1 in PR #65 |
| com.google.guava:guava | — | <span class="badge ok">CLEARED</span> | CVE-2020-8908 | fixed → 32.0.0-jre in PR #65 |
| com.fastxml.jackson.core:jackson-databind (typosquat) | — | <span class="badge ok">REMOVED</span> | n/a (supply-chain) | removed in PR #65 |

## Remediation activity (PR #65)

| Dependency | Change | CVEs cleared | Status |
|---|---|---|---|
| log4j-core / log4j-api | 2.14.1 → 2.17.1 | CVE-2021-44228, -45046, -44832, -45105 | <span class="badge ok">CLEARED</span> |
| jackson-databind (real coordinate) | 2.9.8 → 2.13.2.1 | CVE-2019-14540, CVE-2020-36518, CVE-2019-12384, CVE-2019-12814 | <span class="badge high">INEFFECTIVE</span> — 4 newer HIGH CVEs found, needs ≥2.18.8 (#66) |
| guava | 24.1.1-jre → 32.0.0-jre | CVE-2020-8908 | <span class="badge ok">CLEARED</span> |
| com.fastxml…:jackson-databind (typosquat) | removed | n/a (supply-chain) | <span class="badge ok">CLEARED</span> |
| `internal-untrusted-mirror` repository | removed | n/a (supply-chain) | <span class="badge ok">CLEARED</span> |
| mysql-connector-java | not changed | CVE-2023-22102 unresolved + license VIOLATION | <span class="badge crit">MAJOR_REVIEW</span> — issue #64 |

## Gate (Stage 4) — current verdict: BLOCK

| Check | Result | Evidence |
|---|---|---|
| Unit tests (`mvn test`) | <span class="badge ok">PASS</span> | 2/2 passing |
| OWASP CVE (0 unresolved CRITICAL/HIGH) | <span class="badge crit">FAIL</span> | 5 unresolved HIGH CVEs (jackson-databind ×4, mysql-connector-java ×1) |
| Supply-chain audit (Syft + Grype) | <span class="badge crit">FAIL</span> (BLOCK) | HIGH CVEs with available fix + denied license (mysql-connector-java) |

> **Required before merge (tracked in [#66](https://github.com/sathiskumarperumal/dependency-supplychain-demo/issues/66)):**
> bump `jackson-databind` to ≥2.18.8, resolve the `mysql-connector-java` CVE/license question
> (tracked in [#64](https://github.com/sathiskumarperumal/dependency-supplychain-demo/issues/64)),
> then re-run the Stage 4 gate on the updated PR.

## State of supply-chain hygiene

The pipeline caught and eliminated an active supply-chain attack (a typosquatted `jackson-databind`
coordinate resolving through an attacker-controlled HTTP mirror) and cleared Log4Shell and three
other CVE families in a single automated PR, lifting the project's health score from ~1/100 to
38/100. The remaining gap is not a process failure but the process working as intended: an
independent re-scan at gate time caught that the chosen `jackson-databind` patch level had since
accrued new HIGH-severity CVEs, and correctly held the line rather than merging a partially-fixed
dependency. Two tracking issues (#64, #66) capture the remaining human decisions — a database-driver
license/CVE trade-off and one more version bump — before this PR is mergeable.

---
*Aggregated from `depscan-report.json`, `depscan-risk-report.json`, `depscan-supplychain-audit.json`, PR #65, and Stage 4 gate review [#4642365468](https://github.com/sathiskumarperumal/dependency-supplychain-demo/pull/65#pullrequestreview-4642365468). Generated by the Dependency & Supply-Chain Plugin — Stage 5.*
