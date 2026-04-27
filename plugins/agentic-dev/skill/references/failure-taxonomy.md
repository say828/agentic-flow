# Failure Taxonomy

Use these classes when deterministic proof or runtime verification fails.

## reference-noise

The source spec contains overlays, callouts, annotations, outdated branding, or non-implementable decorations.

## layout-mismatch

Spacing, sizing, alignment, hierarchy, or artboard boundaries differ from the canonical target.

## text-content-mismatch

Rendered text, labels, placeholders, counts, dates, or branded strings differ from the expected output.

## state-mismatch

The target route renders a different fixture, auth state, seeded entity, toggle state, or viewport-dependent branch than the contract expects.

## semantic-mismatch

The page may look close, but interaction rules, button destinations, validation behavior, or API-backed state transitions diverge from the contract.

## preflight-missing-input

Required route bindings, fixtures, reference assets, or environment prerequisites are missing, so proof must fail before capture.
