# Dependency & Supply-Chain Gate — Stage 4 Verdict

**PR:** #25 — fix(deps): batch CVE remediation — log4j / jackson / guava / commons [2026-06-12]
**Branch:** fix/depscan-20260612-064614 -> main
**Head SHA:** 8da1dd0d70f3fb4a50bd41de86dea58b551fb965
**Gate run:** 2026-06-12

---

## VERDICT: BLOCK

---

## Check Results

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | Unit Tests (mvn test) | PASS | 2 passed, 0 failed, 0 errors |
| 2 | OWASP Dependency-Check (CVE scan) | FAIL | 8 unresolved HIGH CVEs |
| 3 | Supply-Chain Audit (Grype + policy) | FAIL | Untrusted HTTP repository in pom.xml |

---

## Check 1 — Unit Tests: PASS

Build command: `mvn -q test package`
Exit code: 0

Surefire report: `target/surefire-reports/TEST-com.demo.supplychain.DiscountCalculatorTest.xml`

| Test | Result |
|---|---|
| goldTierGetsTenPercentOff | PASS |
| standardTierGetsNoDiscount | PASS |

Total: 2 passed, 0 failed, 0 errors, 0 skipped.

---

## Check 2 — OWASP Dependency-Check: FAIL

Scanner: OWASP dependency-check-maven 12.2.2
NVD data directory: /home/runner/.m2/repository/org/owasp/dependency-check-data/11.0
Report: `target/dependency-check-report.json`

**8 unresolved HIGH CVEs (zero-tolerance threshold exceeded):**

| CVE | CVSS | Severity | Affected Artifact | Notes |
|---|---|---|---|---|
| CVE-2026-34480 | 7.5 | HIGH | log4j-core@2.17.2 | XmlLayout XML 1.0 sanitization failure; fix: 2.25.4 |
| CVE-2026-34479 | 7.5 | HIGH | log4j-core@2.17.2 | Log4j1XmlLayout XML injection (CPE match on core); fix: see 2.x bridge |
| CVE-2026-34479 | 7.5 | HIGH | log4j-api@2.17.2 | Same CVE, CPE overmatch on api jar (bridge not present in classpath) |
| CVE-2023-22102 | 8.3 | HIGH | mysql-connector-java@8.0.30 | Oracle MySQL Connector/J takeover; pre-existing, carried from main |
| CVE-2024-7254 | 7.5 | HIGH | protobuf-java@3.19.4 (transitive via mysql) | StackOverflow via nested protobuf groups |
| CVE-2022-3171 | 7.5 | HIGH | protobuf-java@3.19.4 (transitive via mysql) | Binary data parsing DoS |
| CVE-2022-3509 | 7.5 | HIGH | protobuf-java@3.19.4 (transitive via mysql) | Text format parsing DoS |
| CVE-2022-3510 | 7.5 | HIGH | protobuf-java@3.19.4 (transitive via mysql) | Message-Type Extensions parsing DoS |

**MEDIUM (non-blocking, logged):**

| CVE | CVSS | Severity | Affected Artifact |
|---|---|---|---|
| CVE-2026-34477 | 5.9 | MEDIUM | log4j-core@2.17.2, log4j-api@2.17.2 |
| CVE-2025-68161 | 4.8 | MEDIUM | log4j-core@2.17.2 |
| CVE-2025-48924 | 5.3 | MEDIUM | commons-lang3@3.14.0 |
| CVE-2023-35116 | 4.7 | MEDIUM | jackson-databind@2.15.4 |

**Gate policy applied:** 0 CRITICAL / 0 HIGH tolerance. With 8 unresolved HIGHs, Check 2 is FAIL.

**Context notes (for human reviewer):**
- CVE-2026-34479 on log4j-api is a likely CPE overmatch — it describes the Log4j 1-to-2 bridge
  (log4j-1.2-api), which is not present in this project's classpath. A suppression entry can be
  added after human review confirms the bridge jar is absent.
- CVE-2026-34480 is genuine: log4j-core XmlLayout up to 2.25.3 is affected; fix is 2.25.4.
- CVE-2023-22102 and protobuf-java CVEs are carried from mysql-connector-java@8.0.30, which the PR
  explicitly deferred (GPL-2.0 / no-CVE at that time per PR description). The NVD DB now shows
  active CVEs on mysql-connector-java@8.0.30 and its transitive protobuf-java@3.19.4.

---

## Check 3 — Supply-Chain Audit (Grype + policy): FAIL

Grype version: 0.114.0
Grype DB built: 2026-06-11T08:06:19Z
SBOM: `target/sbom.cdx.json` (CycloneDX 1.6, 15 components)
Grype report: `target/grype-sbom-report.json`

### Blocking Finding: Untrusted HTTP Repository

The pom.xml still declares an HTTP (non-TLS) Maven repository:

```
repository id:  internal-untrusted-mirror
url:            http://insecure-mirror.example.net/maven2
```

Per supply-chain audit policy: any HTTP (non-HTTPS) repository declared in pom.xml is an automatic
BLOCK, regardless of whether artifacts were actually resolved from it. This was not addressed in
the remediation PR (listed as "human follow-up required").

### Grype Vulnerability Findings

| ID | CVSS | Severity | Artifact | Fix State |
|---|---|---|---|---|
| GHSA-m6vm-37g8-gqvh (CVE-2023-22102) | 8.9 | HIGH | mysql-connector-java@8.0.30 | not-fixed (no available fix version) |
| GHSA-3pxv-7cmr-fjr4 (CVE-2026-34480) | 6.9 | MEDIUM | log4j-core@2.17.2 | fixed in 2.25.4 |
| GHSA-j288-q9x7-2f5v (CVE-2025-48924) | 6.5 | MEDIUM | commons-lang3@3.14.0 | fixed in 3.18.0 |
| GHSA-vc5p-v9hr-52mj (CVE-2025-68161) | 6.3 | MEDIUM | log4j-core@2.17.2 | fixed in 2.25.3 |
| GHSA-6hg6-v5c8-fphq (CVE-2026-34477) | 6.3 | MEDIUM | log4j-core@2.17.2 | fixed in 2.25.4 |

Note: GHSA-m6vm-37g8-gqvh is HIGH severity but has no available fix version (state: not-fixed).
Per supply-chain audit policy, HIGH with no available fix = WARN, not BLOCK.
The HTTP repository alone is sufficient to trigger BLOCK.

### Typosquatting: CLEAR
The typosquatted coordinate `com.fastxml.jackson.core:jackson-databind` has been removed. No
suspected typosquats detected in the current SBOM.

### Supply-chain Verdict: BLOCK (untrusted HTTP repository)

---

## Aggregate Decision

```
gate = PASS if (check1 == PASS and check2 == PASS and check3 == PASS)
       else BLOCK
```

Check 1: PASS
Check 2: FAIL (8 unresolved HIGH CVEs)
Check 3: FAIL (untrusted HTTP repository)

**Final verdict: BLOCK**

---

## Required Actions

The following must be resolved before this PR may be merged:

### Action 1 — Upgrade log4j-core and log4j-api to 2.25.4 (addresses CVE-2026-34480, CVE-2026-34477, CVE-2025-68161)

In pom.xml, change:
```xml
<version>2.17.2</version>   <!-- for log4j-core and log4j-api -->
```
to:
```xml
<version>2.25.4</version>
```

After upgrading, add a CVE suppression for CVE-2026-34479 on log4j-api and log4j-core if the
Log4j 1-to-2 bridge (log4j-1.2-api) is confirmed absent from the classpath. Alternatively, upgrade
confirms that 2.25.4 does not include the bridge.

### Action 2 — Upgrade mysql-connector-java and resolve protobuf-java CVEs

mysql-connector-java@8.0.30 carries CVE-2023-22102 (HIGH, 8.3) and pulls in
protobuf-java@3.19.4 with 4 HIGH CVEs (CVE-2022-3171, CVE-2022-3509, CVE-2022-3510, CVE-2024-7254).

Options (human decision required due to GPL-2.0):
- Upgrade to `com.mysql:mysql-connector-j:9.1.0` (uses updated protobuf, CVE-2023-22102 resolved
  per Oracle CPU; GPL-2.0 classpath exception applies)
- Or remove/replace with a non-GPL connector

Note: This was explicitly deferred in the PR as requiring human review. The gate blocks regardless.

### Action 3 — Remove or replace the untrusted HTTP repository in pom.xml

Remove the `internal-untrusted-mirror` repository declaration from pom.xml, or replace it with
an HTTPS-verified mirror. This is the sole blocking finding for Check 3.

```xml
<!-- REMOVE this block entirely, or change url to https:// -->
<repository>
    <id>internal-untrusted-mirror</id>
    <url>http://insecure-mirror.example.net/maven2</url>
    ...
</repository>
```

### Action 4 (Advisory) — Upgrade commons-lang3 to 3.18.0 (MEDIUM, non-blocking)

CVE-2025-48924 (MEDIUM 5.3/6.5): StackOverflow in ClassUtils.getClass() on long inputs.
Fix available: commons-lang3 3.18.0. Not a gate-blocking item, but recommended.

---

## Auto-Remediation Note

Actions 1 and 3 are candidates for the Auto-Remediation Skill (Stage 3). Action 2 requires
a human decision on the GPL-2.0 connector replacement.

---

*Generated by Stage 4 PR Validation Agent — 2026-06-12*
*Gate: dependency & supply-chain only. Code coverage is out of scope for this gate.*
