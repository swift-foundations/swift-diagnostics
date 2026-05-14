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

/// Top-level namespace for diagnostic-tooling foundations.
///
/// `Diagnostics` (plural) is the L3 home for composed parsers, formatters,
/// and tool-output adapters that produce or consume the L1
/// `Diagnostic.Record` (singular) type from `swift-diagnostic-primitives`.
///
/// Distinct from `Diagnostic` (singular):
/// - `Diagnostic` (in `swift-diagnostic-primitives`) owns the record types,
///   severity, and source-location wiring.
/// - `Diagnostics` (this package) owns the composed parsers and adapters
///   that turn external tool output into those records.
public enum Diagnostics: Swift.Sendable {}
