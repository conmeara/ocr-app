//
//  OCRPage.swift
//  OCRApp
//
//  Model for OCR processed page
//

import Foundation

/// Represents a page that has been processed with OCR
struct OCRPage: Identifiable {
    let id = UUID()
    let photoId: UUID
    var suggestedFilename: String
    var text: String
    var isEdited: Bool = false

    init(photoId: UUID, suggestedFilename: String, text: String) {
        self.photoId = photoId
        self.suggestedFilename = suggestedFilename
        self.text = text
    }

    /// Returns the filename with appropriate extension
    func filename(for format: ExportFormat) -> String {
        let cleanName = suggestedFilename.trimmingCharacters(in: .whitespacesAndNewlines)
        let baseName = cleanName.isEmpty ? "Untitled" : cleanName

        // Remove existing extension if present
        let nameWithoutExtension = baseName.replacingOccurrences(of: ".md", with: "")
            .replacingOccurrences(of: ".txt", with: "")

        return "\(nameWithoutExtension).\(format.fileExtension)"
    }
}
