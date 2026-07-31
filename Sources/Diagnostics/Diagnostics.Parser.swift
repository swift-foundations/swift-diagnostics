// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-diagnostics open source project
//
// Copyright (c) 2026 Coen ten Thije Boonkkamp and the swift-diagnostics project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

extension Diagnostics {
    /// Parser that maps a Swift compiler / SwiftPM tool's stderr stream
    /// into a sequence of typed ``Diagnostic/Record`` values.
    ///
    /// Pulled out of `swift-impact` per `[RES-018]` case (c) on
    /// 2026-05-14 — see
    /// `swift-institute/Research/swift-package-domain-l1-l2-split.md`
    /// for the architectural framing. The L1 home for the record /
    /// severity / source-location types is `swift-diagnostic-primitives`;
    /// the composed L3 parser that produces those records from external
    /// tool output lives here.
    ///
    /// The current implementation targets `swift build` stderr where each
    /// diagnostic line is shaped as
    /// `<path>:<line>:<column>: <severity>: <message>` and severity is one
    /// of `error`, `warning`, `note`, or `remark`. Lines that do not match
    /// this shape are silently skipped — the parser never throws, and an
    /// arbitrary stderr stream simply yields the records it can recognise.
    public enum Parser: Swift.Sendable {
    }
}

extension Diagnostics.Parser {
    /// Parse `text` (a captured stderr stream) into the diagnostic
    /// records it contains.
    ///
    /// - Parameter text: The decoded UTF-8 contents of a tool's
    ///   `stderr` pipe. May contain any number of non-diagnostic
    ///   lines interleaved with parseable lines.
    /// - Returns: The diagnostics in input order. Lines that do not
    ///   match the expected shape are skipped without error.
    public static func parse(stderr text: Swift.String) -> [Diagnostic.Record] {
        // Splits on the UTF-8 byte view rather than `Character`: Swift
        // groups an adjacent CR+LF pair into a single extended grapheme
        // cluster, so a `Character`-level split(separator: "\n") never
        // matches inside a CRLF pair and a CRLF stream would parse as one
        // unsplit blob. Bytes have no such fusion, and `\n`/`\r` are
        // single-byte ASCII code points in UTF-8.
        var records: [Diagnostic.Record] = []
        for byteLine in text.utf8.split(separator: 0x0A, omittingEmptySubsequences: true) {
            var byteLine = byteLine
            if byteLine.last == 0x0D {
                byteLine.removeLast()
            }
            guard let record = Line.parse(Swift.String(decoding: byteLine, as: Swift.UTF8.self)) else { continue }
            records.append(record)
        }
        return records
    }
}
