## Unlicensed / license-policy violation

The project policy permits only permissive licenses (Apache-2.0, MIT, BSD). A
copyleft (GPL) dependency is present and must be blocked.

### Affected (`pom.xml`)
| Dependency | Declared | License | Problem |
|---|---|---|---|
| `mysql:mysql-connector-java` | `8.0.30` | **GPL-2.0** | Copyleft license violates permissive-only policy |

### Expected plugin behaviour
- `depscan-supplychain-audit` (Grype + license check) flags the GPL dependency
  as a **license violation** and blocks the PR.
- Suggests a compliant alternative (e.g. MariaDB Connector/J under LGPL, or the
  approved internal driver).

### Acceptance criteria
- [ ] GPL-2.0 dependency detected and reported as a policy violation
- [ ] PR blocked with a clear license-violation reason
- [ ] Compliant alternative suggested

**Labels:** `dependency`, `license`, `compliance`, `demo`
