## Outdated dependencies

Several dependencies are years behind their current releases. Even when no CVE
applies, stale dependencies accumulate risk and block security patches.

### Affected (`pom.xml`)
| Dependency | Declared | Notes |
|---|---|---|
| `commons-io:commons-io` | `2.4` | Released 2013; current line is 2.16.x |
| `org.apache.commons:commons-lang3` | `3.4` | Released 2015; current line is 3.14.x |

### Expected plugin behaviour
- `depscan-dependency-scanner` flags both as **outdated** with the latest safe version.
- `depscan-auto-remediation` proposes a version-bump PR with a changelog summary.

### Acceptance criteria
- [ ] Both dependencies reported as outdated with current version suggested
- [ ] Auto-remediation PR raised bumping each to a supported release

**Labels:** `dependency`, `outdated`, `demo`
