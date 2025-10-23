//
//  FileService.swift
//  OCRApp
//
//  Service for saving files to the iOS file system
//

import Foundation
import UIKit
import UniformTypeIdentifiers

/// Service for file operations
class FileService {
    static let shared = FileService()

    private init() {}

    /// Save multiple pages as separate files to a folder
    func savePages(_ pages: [OCRPage], format: ExportFormat, to folderURL: URL) throws {
        let fileManager = FileManager.default

        for (index, page) in pages.enumerated() {
            let filename = page.filename(for: format)
            let fileURL = folderURL.appendingPathComponent(filename)

            // Format the text
            let formattedText = format.format(text: page.text, filename: page.suggestedFilename)

            // Check if file exists and append number if needed
            let finalURL = uniqueFileURL(for: fileURL, fileManager: fileManager)

            // Write to file
            try formattedText.write(to: finalURL, atomically: true, encoding: .utf8)
        }
    }

    /// Generate a unique file URL by appending numbers if file exists
    private func uniqueFileURL(for url: URL, fileManager: FileManager) -> URL {
        var finalURL = url
        var counter = 1

        while fileManager.fileExists(atPath: finalURL.path) {
            let filename = url.deletingPathExtension().lastPathComponent
            let ext = url.pathExtension
            let directory = url.deletingLastPathComponent()

            finalURL = directory.appendingPathComponent("\(filename) \(counter).\(ext)")
            counter += 1
        }

        return finalURL
    }

    /// Create temporary files for sharing
    func createTemporaryFiles(for pages: [OCRPage], format: ExportFormat) throws -> [URL] {
        let tempDirectory = FileManager.default.temporaryDirectory
        var fileURLs: [URL] = []

        for page in pages {
            let filename = page.filename(for: format)
            let fileURL = tempDirectory.appendingPathComponent(filename)

            // Format the text
            let formattedText = format.format(text: page.text, filename: page.suggestedFilename)

            // Write to temporary file
            try formattedText.write(to: fileURL, atomically: true, encoding: .utf8)
            fileURLs.append(fileURL)
        }

        return fileURLs
    }

    /// Get UTType for export format
    func getUTType(for format: ExportFormat) -> UTType {
        switch format {
        case .markdown:
            return UTType(filenameExtension: "md") ?? .plainText
        case .plainText:
            return .plainText
        }
    }
}
