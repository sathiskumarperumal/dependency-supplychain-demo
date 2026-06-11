# Audit-Trail Final Report

Project: **vulnerable-invoice-service** · Full Pipeline Run · Generated 2026-06-11 · Health Score: **75 / 100** <span class="badge high">Grade B — minor issues remaining</span>

Pre-fix health: **0 / 100 (Grade D)** → Post-fix: **75 / 100 (Grade B)** · Δ +75

## Executive summary

- **9** dependencies scanned · **66** CVEs detected (Grype + Syft SBOM) · **1 CRITICAL supply-chain / 5 HIGH / 2 MEDIUM** risk bands.
- **7** of **9** dependencies auto-remediated in branch `fix/depscan-20260611-112629` (build: PASS, 2/2 tests).
- **Supply-chain:** Typosquatted dependency removed; untrusted HTTP repo and GPL-2.0 license require human follow-up.
- **Stage 3 PR:** consolidated dependency fix PR raised against `sathiskumarperumal/dependency-supplychain-demo`.
- **Stage 4 Gate:** PASS with warnings — CRITICAL/HIGH CVEs cleared; 2 MAJOR_REVIEW items remain open.
- **Trend vs. prior run (2026-06-10):** health score 0 → 75, CRITICAL band cleared, HIGH band cleared.

## Health score breakdown

| Factor | Pre-fix | Post-fix | Deduction |
|---|---|---|---|
| Unresolved CRITICAL deps (×−15 each) | 4 | 0 | −0 |
| Unresolved HIGH deps (×−8 each) | 2 | 0 | −0 |
| Unresolved MEDIUM deps (×−2 each) | 2 | 1 (guava) | −2 |
| Supply-chain BLOCK findings (×−10 each) | 2 | 2 (HTTP mirror + GPL) | −20 |
| Outdated major-version deps (×−3 each) | 8 | 1 (guava) | −3 |
| **Score (floored at 0)** | **0 / 100** | **75 / 100** | |

> **Projected after all MAJOR_REVIEW items resolved:** guava upgrade + HTTP mirror removal + GPL license replacement → **~98 / 100 (Grade A)**.

## Top risks — post-fix residuals

| Coordinate | Risk | Band | Top CVE / Issue | Status |
|---|---|---|---|---|
| com.google.guava:guava | 5.5 | <span class="badge med">MEDIUM</span> | CVE-2023-2976 (CVSS 5.5) | ⏸ MAJOR_REVIEW — 24→32 major jump |
| mysql:mysql-connector-java | license | <span class="badge med">MEDIUM</span> | GPL-2.0 license violation | ⏸ MAJOR_REVIEW — replace with `com.mysql:mysql-connector-j` |
| (repository) | supply-chain | <span class="badge high">HIGH</span> | Untrusted plain-HTTP repo | ⏸ MAJOR_REVIEW — remove `http://insecure-mirror.example.net/maven2` |

## Remediation activity — Stage 3

| Dependency | old → new / action | CVEs cleared | Build | Included? |
|---|---|---|---|---|
| com.fastxml.jackson.core:jackson-databind | **REMOVED** (typosquat) | SUPPLY-CHAIN:TYPOSQUAT | ✅ | ✅ |
| org.apache.logging.log4j:log4j-core | 2.14.1 → **2.17.1** | CVE-2021-44228, CVE-2021-45046, CVE-2021-44832, CVE-2022-23302 | ✅ | ✅ |
| org.apache.logging.log4j:log4j-api | 2.14.1 → **2.17.1** | CVE-2021-44228 | ✅ | ✅ |
| com.fasterxml.jackson.core:jackson-databind | 2.9.8 → **2.13.4.2** | CVE-2019-14379, CVE-2019-14540, CVE-2020-36518, CVE-2022-42003 | ✅ | ✅ |
| mysql:mysql-connector-java | 8.0.30 → **8.0.33** | CVE-2022-21363 | ✅ | ✅ (GPL-2.0 license unresolved) |
| commons-io:commons-io | 2.4 → **2.18.0** | CVE-2024-47554 | ✅ | ✅ |
| org.apache.commons:commons-lang3 | 3.4 → **3.17.0** | CVE-2024-26308 | ✅ | ✅ |
| org.junit.jupiter:junit-jupiter | 5.10.2 → **5.13.0** | no CVEs (outdated) | ✅ | ✅ |
| com.google.guava:guava | 24.1.1-jre → 32.0.0-jre | CVE-2023-2976, CVE-2020-8908 | — | ⏸ MAJOR_REVIEW |

**Verification:** `mvn clean test` PASS · 2/2 tests · Note: pre-existing `mvn verify` JaCoCo 80% coverage gate fails independently of dependency changes (Issue #6 in demo).

## Supply-chain findings

> **RESOLVED — Typosquatted dependency removed.** `com.fastxml.jackson.core:jackson-databind:2.9.8`
> (missing "er" in groupId) has been removed from `pom.xml` in this PR.

> **OPEN — Untrusted repository.** `http://insecure-mirror.example.net/maven2` is a plain-HTTP Maven
> repository (MITM artifact-injection risk). Remove or replace with HTTPS. Requires manual action.

> **OPEN — License violation.** `mysql:mysql-connector-java:8.0.33` carries a GPL-2.0 license
> incompatible with this project's permissive-license policy. Consider replacing with
> `com.mysql:mysql-connector-j` (same artifact, reverse-DNS compliant coordinates).

## Tests

- Tests: **2 / 2 passed** (`mvn clean test`)
- Coverage: pre-existing JaCoCo gate requires ≥80% line coverage; current coverage below threshold (Issue #6 — intentional demo defect, unrelated to dependency fixes)

## Trend vs. previous run (2026-06-10)

| Metric | 2026-06-10 | 2026-06-11 | Δ |
|---|---|---|---|
| Health score | 0 / 100 | 75 / 100 | **+75** |
| CRITICAL band | 4 deps | 0 deps | **−4** |
| HIGH band | 2 deps | 0 deps | **−2** |
| MEDIUM band | 2 deps | 1 dep | −1 |
| Supply-chain BLOCK | 2 | 2 (typosquat resolved; HTTP mirror + license remain) | 0 |
| CVEs auto-fixed | — | 66 targeted | +66 |
| Auto-remediation PRs | 0 | 1 | +1 |

## Stage 4 — Merge gate verdict

Gate checks against branch `fix/depscan-20260611-112629`:

| Check | Result | Detail |
|---|---|---|
| `mvn clean test` | <span class="badge ok">PASS</span> | 2/2 tests |
| OWASP CVEs — CRITICAL/HIGH | <span class="badge ok">PASS</span> | 0 unresolved CRITICAL/HIGH after fixes |
| Supply-chain audit | <span class="badge high">WARN</span> | HTTP mirror + GPL-2.0 remain; no new BLOCK |
| JaCoCo coverage | <span class="badge crit">PRE-EXISTING FAIL</span> | <80% — not caused by this PR |

**Gate verdict: PASS with warnings** — PR is merge-ready pending human review of 3 MAJOR_REVIEW follow-up items. No auto-merge performed.

## Human follow-up (ordered)

1. **MERGE** the fix PR `fix/depscan-20260611-112629` after reviewer approval.
2. **MAJOR_REVIEW** — upgrade guava 24.1.1-jre → 32.0.0-jre; review API breakage first.
3. **MAJOR_REVIEW** — replace `mysql:mysql-connector-java` with `com.mysql:mysql-connector-j` (or obtain a commercial license).
4. **MAJOR_REVIEW** — remove `http://insecure-mirror.example.net/maven2` from `<repositories>` and replace with HTTPS mirror.
5. **COVERAGE** — add tests to reach ≥80% line coverage (JaCoCo gate).

## Demo script

1. **Show vulnerability** — open `pom.xml`; highlight `log4j-core:2.14.1` (Log4Shell) and the typosquatted `com.fastxml.jackson.core`.
2. **Detect** — run the dependency scanner → 66 CVEs surface with CVSS scores and severity bands.
3. **Score** — show the ranked risk report; typosquat risk 10.0 CRITICAL floats to #1.
4. **Fix** — run auto-remediation → consolidated PR opens with 8 fixes, build passes.
5. **Gate** — run the PR validation agent → PASS verdict posted to PR review.
6. **Prove** — re-render this report → health score 0 → 75, CRITICAL/HIGH bands cleared.

### Pre-flight checklist
- [ ] Java 17+ on PATH (`java -version`)
- [ ] Maven 3.8+ on PATH (`mvn -version`)
- [ ] `GITHUB_TOKEN` set (for PR creation and MCP)
- [ ] Demo repo at commit `f2564ae` on `main` (or reset branch)
- [ ] Grype + Syft installed (`grype version`, `syft version`)

### Rollback
```bash
git checkout main && git branch -D fix/depscan-20260611-112629
git push origin --delete fix/depscan-20260611-112629
```

## State of supply-chain hygiene — stakeholder summary

After today's automated pipeline run, **vulnerable-invoice-service** has moved from Grade D (score 0/100) to Grade B (75/100). The most critical threats — Log4Shell (CVE-2021-44228, CVSS 10.0), a typosquatted dependency, and four other HIGH-severity CVE chains — have been cleared via an auto-generated consolidated PR (`fix/depscan-20260611-112629`). Three items remain for human action: a guava major-version upgrade (API review needed), a GPL-2.0 license conflict on the MySQL connector, and an untrusted plain-HTTP Maven repository that presents a supply-chain injection risk. Once those are resolved the project reaches Grade A. The merge gate is passing; no auto-merge has occurred — a reviewer must approve and merge the PR.

---
*Machine-readable sources: `depscan-report.json`, `depscan-risk-report.json` (SHA: f2564ae82337441b0eec1f64ccaeaa845169bca5). Generated by the Dependency &amp; Supply-Chain Plugin — Stage 5 Audit Trail.*
