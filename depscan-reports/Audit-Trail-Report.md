# Audit-Trail Final Report

Project: **vulnerable-invoice-service** · Stage 5 (aggregate) · Generated 2026-07-05 · Run: PR #61 (`fix/depscan-20260705-060314` @ `7337200`) · Health Score: **64 / 100 (projected after merge)** <span class="badge med">Grade C — needs attention</span>

## Executive summary

- **23** dependencies scanned (8 direct, 15 transitive) · **13** CVEs found on `main` before this run, plus **2 newly-disclosed HIGH CVEs** (jackson-databind, commons-io) surfaced mid-run by the Stage 4 Grype/NVD re-check.
- **This run's PR (#61)** removes 1 typosquat and clears **6 vulnerable dependencies**: log4j-core/api (Log4Shell), jackson-databind, guava, commons-lang3, commons-io — the jackson-databind and commons-io targets were corrected mid-run (2.13.4.2→2.18.8, 2.7→2.14.0) after the first gate pass caught residual HIGH CVEs.
- **Supply-chain verdict: `BLOCK`** — not because of anything in this PR, but because two pre-existing, unconditional block conditions remain on `main`: the GPL-2.0 `mysql-connector-java` license violation (#58) and the untrusted plain-HTTP Maven mirror (#21). Per the `depscan-supplychain-audit` policy these block **every** PR until a human resolves them, regardless of which PR introduced them.
- **Licenses:** 1 violation stands (GPL-2.0 on mysql-connector-java, unchanged by this PR — a version bump alone doesn't fix the license).
- **Gate outcome on PR #61 (final, corrected):** <span class="badge crit">BLOCK</span> — tests and CVE checks PASS; supply-chain check FAILs on the two standing findings above. PR is **not mergeable as-is**; the dependency fixes themselves are verified clean.

> **Self-correction note:** the first Stage 4 pass on this PR incorrectly posted a `PASS`, treating the untrusted-mirror and license findings as "pre-existing, non-gating." That contradicts the codified `depscan-supplychain-audit` policy (no carve-out for pre-existing findings) and this repo's own precedent (issue #57 blocked PR #56 on the same standing conditions). The verdict was corrected to `BLOCK` within the same run — see PR #61 review history.

## Health score breakdown

| State | CRITICAL CVE | HIGH CVE | MEDIUM CVE | Supply-chain BLOCK findings | Outdated-major deps | Score |
|---|---|---|---|---|---|---|
| **Before this run** (`main` @ `61ed8c3`) | 3 (−45) | 0 (−0) | 3 (−6) | 3 — typosquat, untrusted mirror, license (−30) | 1 — guava (−3) | **16 / 100** <span class="badge crit">Grade D</span> |
| **After PR #61 merges** (projected) | 0 (−0) | 1 — mysql CVE-2023-22102, no fix available (−8) | 4 — Grype MEDIUM findings on log4j-core 2.17.1 (3) + jackson-databind 2.18.8 (1) (−8) | 2 — untrusted mirror + license, still open (−20) | 0 (−0) | **64 / 100** <span class="badge med">Grade C</span> |

The typosquat removal and 6 dependency bumps in this PR account for the entire **+48-point** jump. The remaining 36-point gap to Grade A is entirely the two pre-existing supply-chain findings (#58, #21) plus the un-fixable mysql CVE — none of which this PR touches.

## Top risks (ranked, current `main` state)

| Coordinate | Risk | Band | Top CVE | Status |
|---|---|---|---|---|
| `com.fastxml.jackson.core:jackson-databind` (typosquat) | — | <span class="badge crit">CRITICAL</span> | n/a (supply-chain) | removed in PR #61 |
| `org.apache.logging.log4j:log4j-core` / `-api` | 7.8 | <span class="badge high">HIGH</span> | CVE-2021-44228 (Log4Shell, CVSS 10.0) | fixed in PR #61 → 2.17.1 |
| `com.fasterxml.jackson.core:jackson-databind` | 7.8 | <span class="badge high">HIGH</span> | CVE-2019-14379 +3 more; also CVE-2026-54512/54513 (found mid-run) | fixed in PR #61 → 2.18.8 |
| `com.google.guava:guava` | 6.0 | <span class="badge high">HIGH</span> | CVE-2018-10237, CVE-2020-8908 | fixed in PR #61 → 32.0.0-jre |
| `org.apache.commons:commons-lang3` | 5.2 | <span class="badge med">MEDIUM</span> | CVE-2025-48924 | fixed in PR #61 → 3.18.0 |
| `commons-io:commons-io` | 4.9 | <span class="badge med">MEDIUM</span> | CVE-2021-29425; also CVE-2024-47554 (found mid-run) | fixed in PR #61 → 2.14.0 |
| `mysql:mysql-connector-java` | 2.8 | <span class="badge high">HIGH</span> (CVE) / <span class="badge crit">BLOCK</span> (license) | CVE-2023-22102 (no fix); GPL-2.0 license violation | **not fixed** — tracked in #58, blocks every PR |
| Untrusted HTTP mirror (`internal-untrusted-mirror`) | — | <span class="badge crit">BLOCK</span> | n/a (supply-chain) | **not fixed** — tracked in #21, blocks every PR |

## Remediation activity — PR #61

| Dependency | Change | CVEs cleared | Notes |
|---|---|---|---|
| `com.fastxml.jackson.core:jackson-databind` | removed | n/a (typosquat) | unresolvable coordinate, was blocking the build |
| `log4j-core` / `log4j-api` | 2.14.1 → 2.17.1 | CVE-2021-44228, CVE-2021-45046, CVE-2021-45105 | |
| `jackson-databind` | 2.9.8 → **2.18.8** | CVE-2019-14379, CVE-2019-12384, CVE-2020-36518, CVE-2026-54512, CVE-2026-54513 | target corrected mid-run from 2.13.4.2 after gate found the CVSS-8.1 pair still present |
| `guava` | 24.1.1-jre → 32.0.0-jre | CVE-2018-10237, CVE-2020-8908 | |
| `commons-lang3` | 3.4 → 3.18.0 | CVE-2025-48924 | |
| `commons-io` | 2.4 → **2.14.0** | CVE-2021-29425, CVE-2024-47554 | target corrected mid-run from 2.7 after gate found CVE-2024-47554 still present |
| `mysql-connector-java` | *(unchanged)* | — | version bump alone doesn't clear the GPL-2.0 license → routed to #58, not auto-fixed |

Build: `mvn clean test package` — **PASS** (2/2 tests). `mvn dependency:tree` confirmed every bumped coordinate resolved to its target with no vulnerable transitive override.

## Gate (Stage 4) — final verdict: BLOCK

| Check | Result | Detail |
|---|---|---|
| Unit tests | <span class="badge ok">PASS</span> | 2/2 passed, 0 failed |
| OWASP/NVD CVE (0 CRITICAL/HIGH unresolved) | <span class="badge ok">PASS</span> | Both previously-flagged HIGH CVEs (jackson-databind, commons-io) confirmed cleared via live NVD |
| Supply-chain audit (Grype + SBOM) | <span class="badge crit">FAIL (BLOCK)</span> | GPL-2.0 license violation (#58) + untrusted HTTP mirror (#21) — both unconditional BLOCK conditions, pre-existing, not introduced by this PR |

Two gate passes ran on PR #61: the first (head `c860e83`) correctly BLOCKed on residual CVEs; after correction (head `75b769b`) those CVE checks PASSed, but the supply-chain check's initial `WARN` verdict was itself found to be a misapplication of policy and corrected to `BLOCK` in-run.

**Required actions before merge:**
1. Resolve #58 — replace `mysql-connector-java` (e.g. MariaDB Connector/J, LGPL-2.1) or record an explicit license-policy exception.
2. Resolve #21 — remove or replace `internal-untrusted-mirror` with an HTTPS, allowlisted repository.
3. Re-run the Stage 4 gate once both are addressed.

## Governance note

This repository already carries **~30 open `fix/depscan-*` PRs** and **~15 duplicate open issues** for the same mysql-connector-java license finding, accumulated from daily pipeline runs since 2026-06-11 (left open by design — the pipeline never closes or supersedes prior runs' PRs/issues). This run followed that convention for the PR, but referenced the most recent existing issues (#58, #21, #46) instead of filing further duplicates. **Recommendation for a human:** triage and close the stale duplicates, and make the one policy call (#58/#21) that's been blocking every dependency PR for the better part of a month — that single decision would very likely be enough to unblock the entire backlog.

---
*Aggregated from `depscan-report.json`, `depscan-risk-report.json`, `depscan-supplychain-audit.json`, and the PR #61 review history. Generated by the Dependency & Supply-Chain Plugin — Stage 5.*
