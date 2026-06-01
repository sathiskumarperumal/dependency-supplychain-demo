## Untrusted source repository

The build pulls artifacts from an unverified repository served over plain HTTP.
Untrusted/insecure sources allow dependency substitution and MITM tampering.

### Affected (`pom.xml`)
```xml
<repository>
  <id>internal-untrusted-mirror</id>
  <url>http://insecure-mirror.example.net/maven2</url>
</repository>
```

Problems:
- **Plain HTTP** (no TLS) — artifacts can be tampered with in transit.
- **Non-allowlisted host** — not Maven Central or an approved internal registry.

### Expected plugin behaviour
- `depscan-supplychain-audit` flags the repository as an **untrusted source** and
  blocks the PR until it is removed or replaced with an HTTPS allowlisted mirror.

### Acceptance criteria
- [ ] HTTP / non-allowlisted repository detected and reported
- [ ] PR blocked with remediation guidance (use HTTPS + approved registry)

**Labels:** `dependency`, `security`, `supply-chain`, `demo`
