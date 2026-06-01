# Vulnerable Invoice Service — Supply-Chain Demo Target

A **deliberately insecure** Java/Maven project used to demonstrate the
[Dependency & Supply-Chain Hygiene plugin](../). Every problem the plugin
detects is planted here on purpose and tracked as a GitHub Issue.

> ⚠️ Do not copy any dependency version from this repo into real software.

## Planted problems → Issues

| # | Detection category | Where it lives | Plugin skill / agent |
|---|---|---|---|
| 1 | **Outdated dependencies** | `commons-io:2.4`, `commons-lang3:3.4` | `depscan-dependency-scanner` |
| 2 | **Known CVE / vulnerable** | `log4j-core:2.14.1` (Log4Shell), `jackson-databind:2.9.8`, `guava:24.1.1-jre` | `depscan-dependency-scanner`, `risk_scoring_agent` |
| 3 | **Unlicensed / license violation** | `mysql-connector-java:8.0.30` (GPL-2.0) | `depscan-supplychain-audit` |
| 4 | **Typosquatted dependency** | `com.fastxml.jackson.core` (impersonates `com.fasterxml`) | `depscan-supplychain-audit` |
| 5 | **Untrusted source** | `http://insecure-mirror.example.net/maven2` repo | `depscan-supplychain-audit` |
| 6 | **Test coverage < 80%** | `DiscountCalculatorTest` covers ~2 of ~6 branches | `depscan-merge-validation`, `pr_validation_agent` |

## Demo flow

```text
1. Scan        depscan-dependency-scanner  → flags outdated + CVE deps (Issues 1,2)
2. Score       /risk_scoring_agent .        → ranks CVEs by severity (Issue 2)
3. Audit       depscan-supplychain-audit    → blocks typosquat, untrusted src, GPL (Issues 3,4,5)
4. Remediate   depscan-auto-remediation     → opens version-bump PRs
5. Gate        /pr_validation_agent <PR>     → mvn test + scans + JaCoCo<80% blocks (Issue 6)
6. Report      depscan-audit-trail          → single health report for the live demo
```

## Building

```bash
# The typosquatted dependency (Issue #4) does not resolve by design.
# Comment it out in pom.xml before running the coverage build (Issue #6):
mvn verify          # JaCoCo check fails at <80% line coverage — expected
```
