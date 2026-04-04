# TEST-NEEDS: TradeUnionist.jl

## CRG Grade: C — ACHIEVED 2026-04-04

## Current State

| Category | Count | Details |
|----------|-------|---------|
| **Source modules** | 12 | 567 lines |
| **Test files** | 1 | 361 lines, 174 @test/@testset |
| **Benchmarks** | 0 | None |

## What's Missing

- [ ] **E2E**: No end-to-end workflow test
- [ ] **Performance**: No benchmarks
- [ ] **Error handling**: No tests for invalid data inputs

## FLAGGED ISSUES
- **174 tests for 12 modules = 14.5 tests/module** -- solid
- **Single test file for 12 modules** -- should be split

## Priority: P3 (LOW)

## FAKE-FUZZ ALERT

- `tests/fuzz/placeholder.txt` is a scorecard placeholder inherited from rsr-template-repo — it does NOT provide real fuzz testing
- Replace with an actual fuzz harness (see rsr-template-repo/tests/fuzz/README.adoc) or remove the file
- Priority: P2 — creates false impression of fuzz coverage
