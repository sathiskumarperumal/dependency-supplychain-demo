## Typosquatted dependency

A dependency impersonates a well-known library via a near-identical coordinate.
This is a classic supply-chain attack vector and must be blocked before resolution.

### Affected (`pom.xml`)
| Declared (malicious) | Impersonates (legitimate) | Tell |
|---|---|---|
| `com.fastxml.jackson.core:jackson-databind` | `com.fasterxml.jackson.core:jackson-databind` | groupId is missing the **`er`** in `faster` |

The malicious coordinate does **not** exist on Maven Central and will fail to
resolve by design — comment it out before running the coverage build (Issue #6).

### Expected plugin behaviour
- `depscan-supplychain-audit` flags the coordinate as a likely **typosquat**
  (edit-distance / known-good comparison) and blocks the PR.

### Acceptance criteria
- [ ] `com.fastxml.jackson.core` detected as typosquatting `com.fasterxml.jackson.core`
- [ ] PR blocked with the legitimate coordinate suggested

**Labels:** `dependency`, `security`, `supply-chain`, `typosquatting`, `demo`
