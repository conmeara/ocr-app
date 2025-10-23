//
//  OCRViewModel.swift
//  OCRApp
//
//  Main view model managing app state
//

import SwiftUI
import Combine

/// Main view model for the OCR app
@MainActor
class OCRViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published var capturedPhotos: [CapturedPhoto] = []
    @Published var ocrPages: [OCRPage] = []
    @Published var selectedFormat: ExportFormat = .markdown
    @Published var navigationPath = NavigationPath()

    @Published var isProcessing = false
    @Published var processingProgress: Double = 0.0
    @Published var errorMessage: String?
    @Published var showError = false

    // MARK: - Services

    private let ocrService = NanonetsService.shared
    private let fileService = FileService.shared
    private let clipboardService = ClipboardService.shared

    // MARK: - Photo Management

    func addPhoto(_ image: UIImage) {
        let photo = CapturedPhoto(image: image)
        capturedPhotos.append(photo)
    }

    func removePhoto(_ photo: CapturedPhoto) {
        capturedPhotos.removeAll { $0.id == photo.id }
    }

    func clearPhotos() {
        capturedPhotos.removeAll()
    }

    // MARK: - OCR Processing

    func processPhotos() async {
        isProcessing = true
        processingProgress = 0.0

        let images = capturedPhotos.map { $0.image }
        let totalImages = Double(images.count)

        do {
            var processedPages: [OCRPage] = []

            for (index, image) in images.enumerated() {
                let result = try await ocrService.processImage(image)
                let page = OCRPage(
                    photoId: capturedPhotos[index].id,
                    suggestedFilename: result.suggestedFilename,
                    text: result.text
                )
                processedPages.append(page)

                // Update progress
                processingProgress = Double(index + 1) / totalImages
            }

            ocrPages = processedPages
            isProcessing = false

            // Navigate to edit review
            navigationPath.append(NavigationDestination.editReview)

        } catch {
            isProcessing = false
            showError(error.localizedDescription)
        }
    }

    // MARK: - Page Management

    func updatePage(_ page: OCRPage, filename: String, text: String) {
        if let index = ocrPages.firstIndex(where: { $0.id == page.id }) {
            ocrPages[index].suggestedFilename = filename
            ocrPages[index].text = text
            ocrPages[index].isEdited = true
        }
    }

    func deletePage(_ page: OCRPage) {
        ocrPages.removeAll { $0.id == page.id }
    }

    // MARK: - Export Actions

    func copyAllPages() {
        clipboardService.copyAllPages(ocrPages, format: selectedFormat)
    }

    func copyPage(_ page: OCRPage) {
        clipboardService.copyPage(page, format: selectedFormat)
    }

    func saveToFolder(folderURL: URL) throws {
        try fileService.savePages(ocrPages, format: selectedFormat, to: folderURL)
    }

    func createTemporaryFiles() throws -> [URL] {
        return try fileService.createTemporaryFiles(for: ocrPages, format: selectedFormat)
    }

    // MARK: - Navigation

    func navigateToPhotoGrid() {
        navigationPath.append(NavigationDestination.photoGrid)
    }

    func navigateToProcessing() {
        navigationPath.append(NavigationDestination.processing)
    }

    func navigateToResults() {
        navigationPath.append(NavigationDestination.results)
    }

    func resetToCapture() {
        navigationPath.removeLast(navigationPath.count)
        capturedPhotos.removeAll()
        ocrPages.removeAll()
    }

    func goBack() {
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
        }
    }

    // MARK: - Error Handling

    private func showError(_ message: String) {
        errorMessage = message
        showError = true
    }
}
