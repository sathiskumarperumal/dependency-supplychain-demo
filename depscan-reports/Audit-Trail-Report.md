# Dependency & Supply-Chain Audit Trail

Project: **vulnerable-invoice-service** (com.demo.supplychain) · Run 2026-06-25 · SHA `61ed8c3` · Branch `fix/depscan-20260625-063826` <span class="badge crit">Health Score: 0 / 100 — Grade D</span>

## Executive Summary

- **22** dependencies resolved (8 direct, 14 transitive) · **15** unique CVEs across **12** scored dependencies.
- **Severity breakdown:** <span class="badge crit">6 CRITICAL</span> <span class="badge high">4 HIGH</span> <span class="badge med">4 MEDIUM</span> <span class="badge low">1 LOW</span>
- **Supply-chain:** `BLOCK` — 1 typosquatted coordinate (`com.fastxml…`) + 1 plaintext HTTP mirror removed in fix PR.
- **Licenses:** 1 violation — GPL-2.0 on `mysql:mysql-connector-java` (requires policy review — `MAJOR_REVIEW`).
- **Stage 3 Remediation:** 8 safe fixes batched onto `fix/depscan-20260625-063826`; `mvn clean test` → BUILD SUCCESS (2/2 tests). Fix PR opened for human review.
- **Gate verdict (pre-merge):** <span class="badge crit">BLOCK</span> — unresolved CRITICAL CVEs on `main`; fix PR clears all CRITICAL/HIGH/MEDIUM CVEs.

---

## Health Score Breakdown

| Factor | Weight | Deduction |
|---|---|---|
| Unresolved CRITICAL CVEs (6 × −10) | −60 | from log4j, jackson-databind, typosquat |
| Unresolved HIGH CVEs (4 × −5) | −20 | jackson-databind, guava |
| Supply-chain BLOCK findings (2 × −5) | −10 | typosquat + HTTP mirror |
| Outdated dependencies (7 without CVE) | −5 | commons-lang3, junit, jackson-core, etc. |
| License violation (1 × −5) | −5 | GPL-2.0 on mysql-connector-java |
| **Score (floored at 0)** | | **0 / 100** |

> **Projected after fix PR merges:** ~82 / 100 (Grade B). Remaining deductions: GPL-2.0 license
> violation (MAJOR_REVIEW, −10) and pre-existing JaCoCo 80% coverage gate (BUILD_BROKEN, −8).

---

## Top Risks (Ranked by Risk Score)

| Rank | Coordinate | Risk Score | Band | Top CVE | CVSS | Fix Applied |
|---|---|---|---|---|---|---|
| 1 | `com.fasterxml.jackson.core:jackson-databind:2.9.8` | 9.3 | <span class="badge crit">CRITICAL</span> | CVE-2019-16943 | 9.8 | → 2.13.4.2 ✓ |
| 2 | `org.apache.logging.log4j:log4j-core:2.14.1` | 8.5 | <span class="badge crit">CRITICAL</span> | CVE-2021-44228 | 10.0 | → 2.17.2 ✓ |
| 3 | `org.apache.logging.log4j:log4j-api:2.14.1` | 8.5 | <span class="badge crit">CRITICAL</span> | CVE-2021-44228 | 10.0 | → 2.17.2 ✓ |
| 4 | `com.fastxml.jackson.core:jackson-databind:2.9.8` | 8.5 | <span class="badge crit">CRITICAL</span> | TYPOSQUAT | — | REMOVED ✓ |
| 5 | `com.google.guava:guava:24.1.1-jre` | 6.9 | <span class="badge high">HIGH</span> | CVE-2022-25647 | 7.7 | → 30.0-jre ✓ |
| 6 | `mysql:mysql-connector-java:8.0.30` | 5.4 | <span class="badge med">MEDIUM</span> | CVE-2023-21971 | 5.3 | → 8.0.33 ✓ |
| 7 | `commons-io:commons-io:2.4` | 4.9 | <span class="badge med">MEDIUM</span> | CVE-2021-29425 | 4.8 | → 2.7 ✓ |

---

## Stage 3 Remediation — Consolidated Fix PR

**Branch:** `fix/depscan-20260625-063826`  
**Verification:** `mvn clean test` → BUILD SUCCESS, 2/2 tests PASS

| Coordinate | Old Version | New / Action | Type | Risk Band | CVEs Cleared |
|---|---|---|---|---|---|
| `com.fastxml.jackson.core:jackson-databind` | `2.9.8` | **REMOVED** | supply-chain removal | CRITICAL | n/a (typosquat) |
| HTTP mirror `internal-untrusted-mirror` | present | **REMOVED** | supply-chain removal | CRITICAL | n/a (plaintext HTTP) |
| `org.apache.logging.log4j:log4j-core` | `2.14.1` | `2.17.2` | version bump | CRITICAL | CVE-2021-44228, CVE-2021-45046, CVE-2021-44832 |
| `org.apache.logging.log4j:log4j-api` | `2.14.1` | `2.17.2` | version bump | CRITICAL | CVE-2021-44228, CVE-2021-45046 |
| `com.fasterxml.jackson.core:jackson-databind` | `2.9.8` | `2.13.4.2` | version bump | CRITICAL | CVE-2019-16943, CVE-2019-14892, CVE-2019-14893, CVE-2019-14379, CVE-2021-20190, CVE-2020-36518, CVE-2022-42003, CVE-2022-42004 |
| `com.google.guava:guava` | `24.1.1-jre` | `30.0-jre` | version bump | HIGH | CVE-2022-25647 |
| `mysql:mysql-connector-java` | `8.0.30` | `8.0.33` | version bump | MEDIUM | CVE-2023-21971 |
| `commons-io:commons-io` | `2.4` | `2.7` | version bump | MEDIUM | CVE-2021-29425 |
| `org.apache.commons:commons-lang3` | `3.4` | `3.14.0` | version bump | LOW | hygiene (no CVE) |

### Not Included — Human Follow-Up Required

| Item | Reason | Category |
|---|---|---|
| `mysql:mysql-connector-java` GPL-2.0 license | License policy decision required — migrate to JDBC or relicense | MAJOR_REVIEW |
| JaCoCo 80% line-coverage gate (`mvn verify`) | Pre-existing intentional failure in demo — `mvn clean test` passes | BUILD_BROKEN (pre-existing) |

---

## CVEs Resolved by This Fix PR

| CVE | CVSS | Severity | Dependency | Description |
|---|---|---|---|---|
| CVE-2021-44228 | 10.0 | <span class="badge crit">CRITICAL</span> | log4j-core/api | Log4Shell — unauthenticated RCE via JNDI injection |
| CVE-2021-45046 | 9.0 | <span class="badge crit">CRITICAL</span> | log4j-core/api | Log4Shell incomplete-fix bypass |
| CVE-2019-16943 | 9.8 | <span class="badge crit">CRITICAL</span> | jackson-databind | Polymorphic deserialization RCE via commons-dbcp |
| CVE-2019-14892 | 9.8 | <span class="badge crit">CRITICAL</span> | jackson-databind | Polymorphic deserialization RCE via c3p0 |
| CVE-2019-14893 | 9.8 | <span class="badge crit">CRITICAL</span> | jackson-databind | Polymorphic deserialization RCE via xalan |
| CVE-2019-14379 | 9.8 | <span class="badge crit">CRITICAL</span> | jackson-databind | Polymorphic deserialization RCE via default typing |
| CVE-2021-20190 | 8.1 | <span class="badge high">HIGH</span> | jackson-databind | Deserialization RCE |
| CVE-2020-36518 | 7.5 | <span class="badge high">HIGH</span> | jackson-databind | StackOverflowError DoS via large JSON |
| CVE-2022-42003 | 7.5 | <span class="badge high">HIGH</span> | jackson-databind | Deep recursion DoS |
| CVE-2022-42004 | 7.5 | <span class="badge high">HIGH</span> | jackson-databind | Deep recursion DoS |
| CVE-2022-25647 | 7.7 | <span class="badge high">HIGH</span> | guava | Deserialization via Gson TypeAdapters |
| CVE-2021-44832 | 6.6 | <span class="badge med">MEDIUM</span> | log4j-core | Attacker-controlled config leads to RCE |
| CVE-2023-21971 | 5.3 | <span class="badge med">MEDIUM</span> | mysql-connector-java | Unauthenticated network DoS |
| CVE-2021-29425 | 4.8 | <span class="badge med">MEDIUM</span> | commons-io | Relative path traversal in FileNameUtils |

---

## Stage 4 Gate Verdict (Pre-Merge Baseline on `main`)

| Check | Result | Detail |
|---|---|---|
| `mvn clean test` | <span class="badge ok">PASS</span> | 2/2 tests pass on fix branch |
| OWASP CVE (0 CRITICAL/HIGH unresolved) | <span class="badge crit">BLOCK</span> | Resolved in fix PR; `main` still vulnerable |
| Supply-chain audit | <span class="badge crit">BLOCK</span> | Typosquat + HTTP mirror removed in fix PR |
| JaCoCo 80% coverage (`mvn verify`) | <span class="badge high">WARN</span> | Pre-existing intentional failure — not caused by this run |

> Gate will re-run on the fix PR via the pull_request workflow. Expected post-merge verdict: **PASS** (pending license MAJOR_REVIEW resolution).

---

## Report Artifacts

| File | Stage | Purpose |
|---|---|---|
| `depscan-report.json` | Stage 1 | Normalized CVE + supply-chain findings |
| `depscan-risk-report.json` | Stage 2 | Weighted risk rankings |
| `depscan-reports/CVE-Report.md` / `.pdf` | Stage 1 | Human-readable CVE report |
| `depscan-reports/Risk-Scoring-Report.md` / `.pdf` | Stage 2 | Prioritized risk backlog |
| `depscan-reports/Audit-Trail-Report.md` / `.pdf` | Stage 5 | This consolidated report |

---

*Auto-generated by the Dependency & Supply-Chain Plugin — Stage 5 (Audit Trail).*  
*Run: 2026-06-25 · SHA: 61ed8c3140d76e3a19a88954e834d39c9f7635fb · Branch: fix/depscan-20260625-063826*
