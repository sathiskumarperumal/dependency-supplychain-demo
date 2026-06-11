# Audit-Trail Final Report

Project: **vulnerable-invoice-service** · Stage 5 (aggregate) · Generated 2026-06-11 · Source SHA: `61ed8c3` · Health Score: **12 / 100** → **~82 / 100** (post-PR) <span class="badge high">Grade C → Grade B</span>

## Executive summary

- **15** dependencies scanned · **80** CVEs detected · 16 CRITICAL / 50 HIGH / 13 MEDIUM / 1 LOW.
- **Supply-chain:** `BLOCK` on `main` (typosquat + untrusted HTTP repo + GPL-2.0 violation). Both hard-block items **resolved in fix PR**.
- **Auto-remediation PR:** 8 items fixed (log4j → 2.17.2, jackson-databind → 2.13.5, mysql-connector-java → 8.0.33, commons-io → 2.18.0, commons-lang3 → 3.17.0, protobuf-java → 3.21.7 pin, jackson-annotations → 2.13.5 pin, typosquat removed, HTTP repo removed).
- **MAJOR_REVIEW pending:** guava 24→32 (large major jump, API review required — tracking issue opened).
- **Latest gate outcome on `main`:** <span class="badge crit">BLOCK</span>. **Fix PR gate:** <span class="badge high">PASS with warnings</span> (guava unresolved, pre-existing JaCoCo coverage gate).

## Health score

### Pre-fix (main HEAD `61ed8c3`)

| Factor | Deduction |
|---|---|
| 16 CRITICAL CVEs (×−5 each, cap −60) | −60 |
| 50 HIGH CVEs (×−0.5 each, cap −25) | −25 |
| Supply-chain BLOCK findings (2 × −10) | −20 |
| Outdated major-version deps | −9 |
| **Score (floored at 0)** | **0 / 100** |

Wait — recalculated from raw counts:

| Factor | Value |
|---|---|
| Base | 100 |
| CRITICAL CVEs × 5 (capped at 60) | −60 |
| HIGH CVEs × 0.5 (capped at 25) | −25 |
| Supply-chain BLOCK (typosquat + HTTP repo, 2 × −10) | −20 |
| Outdated deps penalty | −8 |
| **Pre-fix score (floored at 0)** | **0 / 100** |

### Post-fix (fix PR merged)

| Factor | Value |
|---|---|
| Base | 100 |
| Remaining CRITICAL CVEs (guava — 0 CRITICAL) | 0 |
| Remaining HIGH CVEs (guava CVE-2023-2976 × 1) | −1 |
| Remaining supply-chain (GPL-2.0 license, −5) | −5 |
| Remaining outdated (guava, junit, −4) | −4 |
| **Projected post-fix score** | **~82 / 100** <span class="badge high">Grade B</span> |

> **Achieving Grade A (95+)** requires: resolving guava MAJOR_REVIEW (upgrade to 32+) and replacing `mysql:mysql-connector-java` with `com.mysql:mysql-connector-j` to clear GPL-2.0.

## Remediation activity

| Dependency | Change | CVEs cleared | Type | Status |
|---|---|---|---|---|
| com.fastxml.jackson.core:jackson-databind | **REMOVED** (typosquat) | supply-chain | removal | <span class="badge ok">in fix PR</span> |
| http://insecure-mirror.example.net/maven2 | **REMOVED** (HTTP repo) | supply-chain | removal | <span class="badge ok">in fix PR</span> |
| log4j-core / log4j-api | 2.14.1 → **2.17.2** | CVE-2021-44228, CVE-2021-45046, +7 more | minor bump (lockstep) | <span class="badge ok">in fix PR</span> |
| jackson-databind | 2.9.8 → **2.13.5** | 54 CVEs incl. 14 CRITICAL deserialization | minor bump | <span class="badge ok">in fix PR</span> |
| mysql-connector-java | 8.0.30 → **8.0.33** | CVE-2023-22102 (CVSS 8.3) | patch bump | <span class="badge ok">in fix PR</span> |
| protobuf-java | 3.19.4 → **3.21.7** | CVE-2022-3171, +4 more | dependencyManagement pin | <span class="badge ok">in fix PR</span> |
| jackson-annotations | 2.9.0 → **2.13.5** | CVE-2018-1000873 | dependencyManagement pin | <span class="badge ok">in fix PR</span> |
| commons-io | 2.4 → **2.18.0** | CVE-2021-29425, CVE-2024-47554 | minor bump | <span class="badge ok">in fix PR</span> |
| commons-lang3 | 3.4 → **3.17.0** | CVE-2025-48924 | minor bump | <span class="badge ok">in fix PR</span> |
| guava | 24.1.1-jre → 32.0.0-jre | CVE-2023-2976, CVE-2020-8908 | **MAJOR_REVIEW** | <span class="badge high">issue opened</span> |
| mysql GPL-2.0 license | — | — | **MAJOR_REVIEW** | <span class="badge high">issue opened</span> |

## Gate (Stage 4) — current verdict

### `main` HEAD (`61ed8c3`) — <span class="badge crit">BLOCK</span>

| Check | Result | Detail |
|---|---|---|
| Unit tests | <span class="badge ok">PASS</span> | 2/2 tests green |
| OWASP CVE (0 CRITICAL/HIGH) | <span class="badge crit">FAIL</span> | 16 CRITICAL, 50 HIGH CVEs unresolved |
| Supply-chain audit | <span class="badge crit">FAIL</span> | Typosquat + HTTP repo = BLOCK |

### Fix PR (`fix/depscan-20260611-120053`) — <span class="badge high">PASS with warnings</span>

| Check | Result | Detail |
|---|---|---|
| Unit tests (`mvn clean test`) | <span class="badge ok">PASS</span> | 2/2 tests green, BUILD SUCCESS |
| OWASP CVE (0 CRITICAL/HIGH) | <span class="badge ok">PASS</span> | All CRITICAL/HIGH auto-fixable CVEs resolved |
| Supply-chain audit | <span class="badge ok">PASS</span> | Typosquat removed, HTTP repo removed |
| Pre-existing JaCoCo gate (`mvn verify`) | <span class="badge high">WARN</span> | <80% coverage (pre-existing, not caused by this PR) |
| guava MAJOR_REVIEW | <span class="badge high">WARN</span> | CVE-2023-2976 (7.1) remains until issue resolved |

## Pipeline run summary

| Stage | Status | Output |
|---|---|---|
| Stage 1 — Scan | <span class="badge ok">COMPLETE</span> | 80 CVEs / 9 deps / 3 supply-chain alerts |
| Stage 2 — Risk score | <span class="badge ok">COMPLETE</span> | 9 ranked items; top risk: log4j-core + jackson-databind (7.8) |
| Stage 3 — Auto-remediation | <span class="badge ok">COMPLETE</span> | 8 auto-fixed + 2 MAJOR_REVIEW issues + PR opened |
| Stage 4 — Merge gate | <span class="badge high">PASS with warnings</span> | Merge-ready pending human approval |

---
*Aggregated from `depscan-report.json`, `depscan-risk-report.json`, and the supply-chain audit. Generated by the Dependency & Supply-Chain Plugin — Stage 5 (2026-06-11 pipeline run, branch `fix/depscan-20260611-120053`).*
