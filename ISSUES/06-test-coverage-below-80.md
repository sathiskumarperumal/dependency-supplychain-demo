## Test coverage below 80%

The merge gate requires ≥ 80% line coverage (JaCoCo). The shipped test suite
intentionally covers only part of the code, so `mvn verify` fails the gate.

### Affected
- `DiscountCalculatorTest` exercises only the `STANDARD` and `GOLD` branches of
  `applyDiscount`.
- The bulk-bonus branches (`applyBulkBonus`) and the entire `loyaltyPoints`
  method are **untested**.
- JaCoCo rule in `pom.xml`: `LINE COVEREDRATIO minimum 0.80`.

### Expected plugin behaviour
- `depscan-merge-validation` / `pr_validation_agent` runs `mvn test` + JaCoCo and
  **blocks the merge** because coverage is under 80%, reporting the exact ratio.

### Acceptance criteria
- [ ] Coverage measured and reported as below 80%
- [ ] Merge gate blocks the PR with the coverage figure and uncovered classes
- [ ] Adding tests for the uncovered branches clears the gate

**Labels:** `quality`, `coverage`, `ci`, `demo`
