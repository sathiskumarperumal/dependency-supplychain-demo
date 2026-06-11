# Stage 4 Merge Gate Verdict

**Repository:** sathiskumarperumal/dependency-supplychain-demo  
**Branch:** fix/depscan-20260611-074147  
**Head SHA:** ea2fe54f94746db8c26d79714328ead2ab92941e  
**Gate run date:** 2026-06-11  
**Verdict:** BLOCK

---

## Gate Decision: BLOCK

Three independent checks were evaluated. At least one check failed. The gate is blocked.

| Check | Result | Detail |
|---|---|---|
| Check 1 — Tests | PASS | 2 tests, 0 failures, 0 errors |
| Check 2 — OWASP CVE scan | BLOCK | 8 unresolved HIGH CVEs with fixes available |
| Check 3 — Supply-Chain Audit | BLOCK | GPL-2.0 license violation on mysql-connector-java |

---

## Check 1 — Tests

**Result: PASS**

- Test class: `com.demo.supplychain.DiscountCalculatorTest`
- Tests run: 2
- Failures: 0
- Errors: 0
- Skipped: 0
- Build: `mvn -q clean test` exited 0

Tests: `goldTierGetsTenPercentOff`, `standardTierGetsNoDiscount` — both passed.

---

## Check 2 — OWASP Dependency-Check (CVE scan on fixed pom.xml)

**Result: BLOCK**

OWASP Dependency-Check 12.2.2 was run against the fixed pom.xml on the warm NVD database
(`-DautoUpdate=false`). The scan found zero CRITICAL CVEs and 9 HIGH CVE instances (8 distinct
CVE IDs). All HIGH findings have a fix available, triggering the zero-tolerance threshold.

### CRITICAL CVEs

None detected. All previously reported critical Log4Shell and jackson-databind CVEs (CVE-2021-44228,
CVE-2021-45046, CVE-2019-14379, CVE-2019-14540, CVE-2020-36518, CVE-2022-42003) are confirmed
cleared by this scan.

### HIGH CVEs — all have a fix available (BLOCKING)

| CVE | CVSS | Component | Current Version | Fix Version | Notes |
|---|---|---|---|---|---|
| CVE-2026-34479 | 7.5 | log4j-api, log4j-core | 2.17.1 | 2.25.4 | Log4j1XmlLayout XML char escaping — direct dep |
| CVE-2026-34480 | 7.5 | log4j-core | 2.17.1 | 2.25.4 | XmlLayout XML sanitisation — direct dep |
| CVE-2023-2976 | 7.1 | guava | 24.1.1-jre | 32.0.0 | MAJOR_REVIEW — issue #13 tracks major version jump |
| CVE-2022-3171 | 7.5 | protobuf-java | 3.19.4 | 3.19.6 | Transitive via mysql-connector-j |
| CVE-2022-3509 | 7.5 | protobuf-java | 3.19.4 | 3.19.6 | Transitive via mysql-connector-j |
| CVE-2022-3510 | 7.5 | protobuf-java | 3.19.4 | 3.19.6 | Transitive via mysql-connector-j |
| CVE-2024-7254 | 7.5 | protobuf-java | 3.19.4 | 3.25.5 | Transitive via mysql-connector-j |
| CVE-2023-22102 | 8.3 | mysql-connector-j | 8.0.31 | 8.4.0 / 9.x | Affects <= 8.1.0; fix exists in newer release stream |

**Note on protobuf-java:** `com.google.protobuf:protobuf-java:3.19.4` is a transitive dependency
pulled in by `mysql:mysql-connector-java:8.0.31`. It is not declared directly in pom.xml. Three of
its HIGH CVEs are fixed at 3.19.6 and one at 3.25.5. These can be resolved by either adding an
explicit dependency override or by upgrading/replacing the mysql connector.

**Note on CVE-2023-22102:** The OWASP CPE match is `versionEndIncluding=8.1.0`, meaning all
versions 8.1.0 and earlier are affected. The fix requires upgrading to 8.4.0 or 9.x under the new
group ID `com.mysql:mysql-connector-j`. This overlaps with the license MAJOR_REVIEW in issue #14.

**Note on CVE-2026-34479 / CVE-2026-34480:** These are newly disclosed CVEs (2026) affecting
log4j 2.x up to 2.25.3. The Log4Shell fixes applied in this branch (upgrading to 2.17.1) remain
correct; a further bump to 2.25.4 is required to clear these newer findings.

### MEDIUM CVEs (informational — not blocking)

| CVE | CVSS | Component | Fix Version |
|---|---|---|---|
| CVE-2026-34477 | 5.9 | log4j-api, log4j-core 2.17.1 | 2.25.4 |
| CVE-2025-68161 | 4.8 | log4j-core 2.17.1 | 2.24.4 |
| CVE-2023-35116 | 4.7 | jackson-databind 2.14.0 | no fix confirmed |
| CVE-2020-8908 | 3.3 | guava 24.1.1-jre | 32.0.0 (MAJOR_REVIEW) |

---

## Check 3 — Supply-Chain Audit

**Result: BLOCK (pre-existing, deferred to MAJOR_REVIEW)**

Source: `depscan-supplychain-audit.json` (source_sha: ea2fe546, audited: 2026-06-11T08:20:00Z).
Verdict carried forward verbatim — report is fresh and matches current head.

**Blocking finding:**

- **Type:** License violation
- **Coordinate:** `mysql:mysql-connector-java:8.0.31`
- **Detail:** GPL-2.0-with-FOSS-exception is incompatible with the project's permissive-only license
  policy. The CVE fix from 8.0.30 to 8.0.31 was applied correctly (CVE-2022-21363 cleared), but
  the underlying license issue cannot be auto-resolved — it requires replacing the dependency with a
  permissive-licensed driver.
- **Tracking:** Issue #14 opened — MAJOR_REVIEW in progress.
- **Required action:** Replace `mysql:mysql-connector-java` with `com.mysql:mysql-connector-j` (or
  another permissive-licensed MySQL driver) once human review approves the switch.

**Supply-chain items confirmed clean:**

- Zero typosquatted coordinates detected in SBOM (typosquat `com.fastxml.jackson.core` removed)
- Only Maven Central (HTTPS) in effective POM — plain-HTTP mirror removed
- Zero CRITICAL CVEs in Grype scan at time of supply-chain audit
- Zero HIGH CVEs with available fix in Grype scan (GHSA-m6vm-37g8-gqvh on mysql had no fix at
  audit time; OWASP now reports CVE-2023-22102 on the same jar as HIGH with a fix in the newer
  release stream)

**Non-blocking warnings carried forward:**

| Warning | Detail |
|---|---|
| GHSA-m6vm-37g8-gqvh (HIGH) on mysql:8.0.31 | No Grype fix version at audit time; OWASP maps this to CVE-2023-22102 with fix in 8.4+ |
| 3x log4j-core 2.17.1 MEDIUM (GHSA-3pxv, GHSA-vc5p, GHSA-6hg6) | Post-Log4Shell; fix at 2.25.4 |
| guava MEDIUM+LOW MAJOR_REVIEW | Issues #13 in progress |
| checker-compat-qual GPL-2.0-with-classpath-exception | Transitive; classpath exception makes it permissive-compatible |

---

## Aggregate Verdict: BLOCK

```
Check 1 (Tests):          PASS
Check 2 (OWASP CVE):      BLOCK  — 8 unresolved HIGH CVEs, all have fixes available
Check 3 (Supply-Chain):   BLOCK  — GPL-2.0 license violation, MAJOR_REVIEW in progress
```

Gate policy: MERGE only if all three checks PASS. Two checks failed. PR must not be merged.

---

## Remediation Required Before Merge

The following actions are required to clear this gate:

**Required Action 1 — Upgrade log4j to 2.25.4 (Check 2)**  
`log4j-api` and `log4j-core` must be bumped from 2.17.1 to 2.25.4 to clear CVE-2026-34479 (HIGH
7.5) and CVE-2026-34480 (HIGH 7.5). This is a minor version bump within the 2.x stream and does
not require a MAJOR_REVIEW.

**Required Action 2 — Resolve mysql connector (Checks 2 and 3, combined)**  
Replacing `mysql:mysql-connector-java:8.0.31` with `com.mysql:mysql-connector-j:9.x` addresses all
three of:
- CVE-2023-22102 (HIGH 8.3) on the connector itself
- CVE-2022-3171, CVE-2022-3509, CVE-2022-3510 (HIGH 7.5 each) and CVE-2024-7254 (HIGH 7.5) on the
  transitive `protobuf-java:3.19.4` dependency
- The GPL-2.0 license violation (Check 3 block)

This replacement is tracked in issue #14. The Auto-Remediation Skill (Stage 3) can be re-invoked
to apply this change once human approval is confirmed.

**Required Action 3 — Resolve guava MAJOR_REVIEW (Check 2)**  
`guava:24.1.1-jre` carries CVE-2023-2976 (HIGH 7.1 per OWASP; was 5.5 in earlier scan). The fix
is at 32.0.0. This is a major version jump tracked in issue #13 and requires human validation of
API compatibility before the bump can be automated.

---

## Context for Human Reviewer

This branch represents a partial but significant remediation of the pre-existing vulnerability
surface:

- **Cleared:** CVE-2021-44228 (Log4Shell CRITICAL 10.0), CVE-2021-45046 (CRITICAL 9.0),
  CVE-2019-14379/14540 (CRITICAL 9.8 x2), CVE-2020-36518 (HIGH 7.5), CVE-2022-42003 (HIGH 7.5),
  CVE-2022-21363 (MEDIUM), CVE-2024-47554 (MEDIUM), CVE-2025-48924 (MEDIUM)
- **Removed:** typosquat coordinate `com.fastxml.jackson.core:jackson-databind`
- **Removed:** plain-HTTP untrusted Maven mirror

The remaining blocks are structural: log4j needs a further minor bump, and the mysql connector
requires a group-ID change to simultaneously fix the license violation, a HIGH CVE, and four
transitive HIGH CVEs in protobuf-java. The guava block requires a major version review.

Gate cleared — ready for human merge: **NO. Merge is blocked pending the three actions above.**
