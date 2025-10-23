//
//  ClipboardService.swift
//  OCRApp
//
//  Service for clipboard operations
//

import UIKit

/// Service for copying text to clipboard
class ClipboardService {
    static let shared = ClipboardService()

    private init() {}

    /// Copy all pages to clipboard with separator
    func copyAllPages(_ pages: [OCRPage], format: ExportFormat, separator: String = "\n\n---\n\n") {
        let combinedText = pages.enumerated().map { index, page in
            let formattedText = format.format(text: page.text, filename: page.suggestedFilename)
            return formattedText
        }.joined(separator: separator)

        UIPasteboard.general.string = combinedText
    }

    /// Copy a single page to clipboard
    func copyPage(_ page: OCRPage, format: ExportFormat) {
        let formattedText = format.format(text: page.text, filename: page.suggestedFilename)
        UIPasteboard.general.string = formattedText
    }

    /// Copy plain text to clipboard
    func copyText(_ text: String) {
        UIPasteboard.general.string = text
    }
}
