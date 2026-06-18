# Dependency Health Report — vulnerable-invoice-service

Generated: 2026-06-18T07:10:00Z   |   Health Score: **79 / 100** (Grade B)   |   Trend: 27 → **79** (+52)

## Executive Summary

- 12 dependencies scanned · 12 CVEs found on `main` · **11 fixed** via auto-remediation PR #30
- Supply-chain: **WARN** (1 blocking finding: untrusted HTTP repo — manual action required)
- Gate outcome on latest PR (#30): **CONDITIONAL PASS**

## Top Risks (ranked)

| Coordinate | Risk | Band | Top CVE | Status |
|---|---|---|---|---|
| mysql:mysql-connector-java:8.0.30 | 7.2 | HIGH | CVE-2023-22102 (8.9) | MAJOR_REVIEW — issue #29 |
| http://insecure-mirror.example.net | — | WARN | UNTRUSTED_REPO | Manual: remove `<repository>` block |

## Remediation Activity

| Dependency | old → new | CVEs cleared | PR | Merged? |
|---|---|---|---|---|
| com.fastxml…:jackson-databind | REMOVE (typosquat) | supply-chain | #30 | Awaiting human |
| log4j-core / log4j-api | 2.14.1 → 2.25.4 | 6 (incl. Log4Shell) | #30 | Awaiting human |
| jackson-databind | 2.9.8 → 2.18.3 | 53+ deserialization CVEs | #30 | Awaiting human |
| commons-io | 2.4 → 2.18.0 | CVE-2024-47554 | #30 | Awaiting human |
| commons-lang3 | 3.4 → 3.18.0 | CVE-2025-48924 | #30 | Awaiting human |
| guava | 24.1.1-jre → 33.4.0-jre | CVE-2023-2976 | #30 | Awaiting human |
| mysql-connector-java | 8.0.30 (no in-kind fix) | CVE-2023-22102 | issue #29 | MAJOR_REVIEW |

## Supply-Chain Findings

| Type | Detail | Status |
|---|---|---|
| TYPOSQUAT — com.fastxml… | Impersonates com.fasterxml (edit-distance 2) | RESOLVED in PR #30 |
| UNTRUSTED_REPO — HTTP mirror | Plain-HTTP repo declared; MITM risk | OPEN — manual PR needed |

## Tests

- Tests: **2 / 2 passed** (`mvn clean test` on fix branch)
- Pre-existing: JaCoCo 80% coverage gate fails (`mvn verify`) — Issue #6, out-of-scope for dependency gate

## Trend vs. Previous Run

| Metric | Before (main) | After PR #30 |
|---|---|---|
| Health score | 27 / 100 (Grade D) | **79 / 100 (Grade B)** |
| Total CVEs | 12 | 1 |
| CRITICAL/HIGH CVEs | 5 | 1 |
| Supply-chain BLOCKs | 2 | 1 |
| CVEs resolved this cycle | — | **11** |

## Appendix — Full Findings

- Scan: `depscan-report.json`
- Risk scores: `depscan-risk-report.json`
- CVE report: `depscan-reports/CVE-Report.md`
- Risk report: `depscan-reports/Risk-Scoring-Report.md`
- Full audit trail: `depscan-reports/Audit-Trail-Report.md`
- Remediation PR: https://github.com/sathiskumarperumal/dependency-supplychain-demo/pull/30
- MAJOR_REVIEW issue: https://github.com/sathiskumarperumal/dependency-supplychain-demo/issues/29
