# swift-diagnostics

Composed parsers and adapters for diagnostic-emitting tools.

`swift-diagnostics` turns external tool output (today: `swift build` stderr) into typed `Diagnostic.Record` values from `swift-diagnostic-primitives`. It's the L3 home for parser logic that composes the L1 record / severity / source-location primitives — so consumers like `swift-impact`, lint runners, and CI reporters share one parser instead of each carrying their own.

The library lives at `Diagnostics` (plural). The L1 record types live at `Diagnostic` (singular) in [swift-diagnostic-primitives](https://github.com/swift-primitives/swift-diagnostic-primitives) and re-export through this package.

## Use case

You're capturing `swift build`'s stderr from a `Process.Spawn.run(...)` call and want typed diagnostics back, not a raw string blob:

```swift
import Diagnostics

let stderr = Swift.String(decoding: output.stderr ?? .init(), as: Unicode.UTF8.self)
let records: [Diagnostic.Record] = Diagnostics.Parser.parse(stderr: stderr)

for record in records {
    print("\(record.location): \(record.severity): \(record.message)")
}
```

The parser recognises the standard Swift compiler shape `<path>:<line>:<column>: <severity>: <message>` with severities `error`, `warning`, `note`, and `remark`. Lines that don't match (build-progress messages, multi-line diagnostic bodies, blank lines) are silently skipped.

## Architecture

L3 Foundation. Depends on:

- L1: `swift-diagnostic-primitives` (record / severity types), `swift-source-primitives` (`Source.Location`).

Zero external dependencies.

## Related packages

- [swift-diagnostic-primitives](https://github.com/swift-primitives/swift-diagnostic-primitives) — the L1 record type this parser produces.
- [swift-impact](https://github.com/swift-foundations/swift-impact) — consumes this parser to surface typed diagnostics from each downstream `swift build`.

## License

Apache 2.0. See `LICENSE.md`.
