//
//  ExportFormat.swift
//  OCRApp
//
//  Export format options for OCR results
//

import Foundation

/// Available export formats for OCR results
enum ExportFormat: String, CaseIterable {
    case markdown = "Markdown"
    case plainText = "Plain Text"

    var fileExtension: String {
        switch self {
        case .markdown:
            return "md"
        case .plainText:
            return "txt"
        }
    }

    var icon: String {
        switch self {
        case .markdown:
            return "doc.richtext"
        case .plainText:
            return "doc.plaintext"
        }
    }

    /// Formats the text according to the export format
    func format(text: String, filename: String? = nil) -> String {
        switch self {
        case .markdown:
            // Add markdown header if filename is provided
            if let filename = filename {
                return "# \(filename)\n\n\(text)"
            }
            return text
        case .plainText:
            return text
        }
    }
}
