# Dependency Health Report — vulnerable-invoice-service

Generated: 2026-07-03T06:23:00Z   |   Health Score: **60 / 100** (Grade C)   |   Trend: 27 → **60** (+33)

## Executive Summary

- 23 dependencies scanned on `main` (source `61ed8c3`) · 18 CRITICAL / 46 HIGH / 17 MEDIUM / 1 LOW CVE findings across 8 vulnerable coordinates · **7 of 8** cleared via consolidated auto-remediation PR #59
- Supply-chain: **BLOCK** on the PR (2 findings remain: license violation, untrusted HTTP mirror) — the typosquat finding is resolved
- Gate outcome on latest PR (#59): **BLOCK** — human action required before merge

## Top Risks (ranked, post-remediation state on PR #59)

| Coordinate | Risk | Band | Top CVE / Issue | Status |
|---|---|---|---|---|
| mysql:mysql-connector-java:8.0.30 | 2.8 (CVE) | <span class="badge high">HIGH</span> | CVE-2023-22102 (8.3) + GPL-2.0 license violation | Not fixed — tracked in issue #58 |
| pom.xml `internal-untrusted-mirror` | — | <span class="badge high">HIGH</span> | Untrusted HTTP repository (MITM risk) | Not fixed — pre-existing, no PR touches it yet |
| com.google.guava:guava:32.0.1-jre | — | <span class="badge low">LOW</span> | Outdated (major line available: 33.6.0-jre) | Hygiene only, no CVE |

## Remediation Activity (PR #59)

| Dependency | old → new / action | CVEs cleared | PR | Merged? |
|---|---|---|---|---|
| com.fastxml.jackson.core:jackson-databind | REMOVE (typosquat) | n/a — supply-chain | #59 | Awaiting human |
| org.apache.logging.log4j:log4j-core / log4j-api | 2.14.1 → 2.25.4 | CVE-2021-44228 (Log4Shell) + 8 more | #59 | Awaiting human |
| com.fasterxml.jackson.core:jackson-databind | 2.9.8 → 2.22.0 | CVE-2020-9548 + 55 more | #59 | Awaiting human |
| com.google.protobuf:protobuf-java (transitive) | 3.19.4 → 3.25.5 (dependencyManagement pin) | CVE-2022-3171, -3509, -3510, CVE-2024-7254 | #59 | Awaiting human |
| com.google.guava:guava | 24.1.1-jre → 32.0.1-jre | CVE-2023-2976, CVE-2020-8908 | #59 | Awaiting human |
| org.apache.commons:commons-lang3 | 3.4 → 3.18.0 | CVE-2025-48924 | #59 | Awaiting human |
| commons-io:commons-io | 2.4 → 2.14.0 | CVE-2024-47554 | #59 | Awaiting human |
| mysql:mysql-connector-java | not bumped (license flag not clearable by version bump) | CVE-2023-22102 unresolved | issue #58 | Human follow-up |

## Supply-Chain Findings

| Type | Coordinate | Detail | Status |
|---|---|---|---|
| TYPOSQUAT | com.fastxml.jackson.core:jackson-databind | Impersonates com.fasterxml.jackson.core (missing "er") | **RESOLVED** in PR #59 |
| LICENSE_VIOLATION | mysql:mysql-connector-java:8.0.30 | GPL-2.0 with FOSS Exception, denied in permissive-only project | OPEN — issue #58 |
| UNTRUSTED_SOURCE | pom.xml `internal-untrusted-mirror` | Plain-HTTP repo (`http://insecure-mirror.example.net/maven2`), not on trusted allowlist | OPEN — no PR yet |

## Tests

- Tests: **2 / 2 passed** (`mvn clean test` on PR #59 head)
- Pre-existing: JaCoCo 80% line-coverage gate fails on `mvn clean verify` (Issue #6) — out of scope for the dependency/supply-chain gate, unrelated to this run's changes

## Trend vs. Previous Run

| Metric | Before (main, baseline) | After PR #59 (if merged) |
|---|---|---|
| Health score | 27 / 100 (Grade D) | **60 / 100 (Grade C)** |
| Vulnerable-dependency bands (HIGH/MEDIUM) | 4 HIGH / 3 MEDIUM | 1 HIGH / 0 MEDIUM |
| Supply-chain blocking findings | 2 (typosquat, untrusted repo) | 2 (license violation, untrusted repo) |
| Major-outdated direct dependencies | 5 | 4 |
| CVEs resolved this cycle | — | **7 of 8** flagged dependencies fixed |

## Appendix — Full Findings

- Scan (base, `61ed8c3`): `depscan-report.json`
- Risk scores (base): `depscan-risk-report.json`
- Supply-chain audit (PR head, `31ab913`): `depscan-supplychain-audit.json`
- CVE report: `depscan-reports/CVE-Report.md`
- Risk report: `depscan-reports/Risk-Scoring-Report.md`
- Full audit trail: `depscan-reports/Audit-Trail-Report.md`
- Remediation PR: https://github.com/sathiskumarperumal/dependency-supplychain-demo/pull/59
- Follow-up issue (license violation): https://github.com/sathiskumarperumal/dependency-supplychain-demo/issues/58
