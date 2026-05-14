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

extension Diagnostics.Parser {
    /// Single-line parser — extracts one ``Diagnostic/Record`` from a
    /// `<path>:<line>:<column>: <severity>: <message>` line.
    ///
    /// Internal namespace: the public entry point is
    /// ``Diagnostics/Parser/parse(stderr:)``; this helper exists so the
    /// per-line shape is testable in isolation and stays distinct from
    /// the stream-level driver.
    internal enum Line {
        /// Parse a single stderr line into a ``Diagnostic/Record``.
        ///
        /// Returns `nil` when the line does not match the expected
        /// `<path>:<line>:<column>: <severity>: <message>` shape — for
        /// example, when the line is a build-progress message, an empty
        /// line, or a continuation of a multi-line diagnostic body.
        internal static func parse(_ line: Swift.String) -> Diagnostic.Record? {
            let parts = line.split(separator: ":", maxSplits: 4, omittingEmptySubsequences: false)
            guard parts.count == 5 else { return nil }
            let path = Swift.String(parts[0])
            guard let lineNumber = Swift.Int(parts[1]),
                  let columnNumber = Swift.Int(parts[2])
            else { return nil }
            let severityString = parts[3].trimmingPrefixWhitespace()
            let message = parts[4].trimmingPrefixWhitespace()
            guard let severity = severity(forKeyword: severityString) else { return nil }
            return Diagnostic.Record(
                location: Source.Location(
                    fileID: path,
                    filePath: path,
                    line: lineNumber,
                    column: columnNumber
                ),
                severity: severity,
                identifier: "swift_build_diagnostic",
                message: message
            )
        }

        /// Map a severity keyword (`error`, `warning`, `note`, `remark`)
        /// to the typed ``Diagnostic/Severity`` case. Unknown keywords
        /// return `nil`, which the caller treats as a non-diagnostic
        /// line.
        internal static func severity(forKeyword keyword: Swift.String) -> Diagnostic.Severity? {
            switch keyword {
            case "error": return .error
            case "warning": return .warning
            case "note": return .note
            case "remark": return .remark
            default: return nil
            }
        }
    }
}

// MARK: - Substring helpers

extension Swift.Substring {
    fileprivate func trimmingPrefixWhitespace() -> Swift.String {
        Swift.String(self.drop(while: { $0 == " " || $0 == "\t" }))
    }
}

extension Swift.String {
    fileprivate func trimmingPrefixWhitespace() -> Swift.String {
        Swift.String(self.drop(while: { $0 == " " || $0 == "\t" }))
    }
}
