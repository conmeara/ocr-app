//
//  NanonetsService.swift
//  OCRApp
//
//  Service for Nanonets OCR and filename extraction
//

import Foundation
import UIKit

/// Service for interacting with Nanonets API
class NanonetsService {
    static let shared = NanonetsService()

    private init() {}

    // API configuration
    private let apiKey: String = "" // User needs to add their Nanonets API key
    private let ocrEndpoint = "https://app.nanonets.com/api/v2/OCR/Model/{model_id}/LabelFile/"

    /// Errors that can occur during OCR processing
    enum OCRError: LocalizedError {
        case missingAPIKey
        case invalidImage
        case networkError(Error)
        case invalidResponse
        case processingFailed(String)

        var errorDescription: String? {
            switch self {
            case .missingAPIKey:
                return "Nanonets API key is not configured. Please add your API key to NanonetsService.swift"
            case .invalidImage:
                return "The image could not be processed"
            case .networkError(let error):
                return "Network error: \(error.localizedDescription)"
            case .invalidResponse:
                return "Invalid response from server"
            case .processingFailed(let message):
                return "OCR processing failed: \(message)"
            }
        }
    }

    /// Process an image with OCR
    func processImage(_ image: UIImage) async throws -> (text: String, suggestedFilename: String) {
        guard !apiKey.isEmpty else {
            throw OCRError.missingAPIKey
        }

        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw OCRError.invalidImage
        }

        // Create multipart form data request
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: URL(string: ocrEndpoint)!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        // Add basic auth
        let loginString = "\(apiKey):"
        let loginData = loginString.data(using: .utf8)!
        let base64LoginString = loginData.base64EncodedString()
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")

        // Create body
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        // Make request
        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw OCRError.invalidResponse
            }

            // Parse response
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            let extractedText = extractTextFromResponse(json)

            // Extract filename from text
            let filename = await extractFilename(from: extractedText)

            return (extractedText, filename)

        } catch let error as OCRError {
            throw error
        } catch {
            throw OCRError.networkError(error)
        }
    }

    /// Extract text from Nanonets API response
    private func extractTextFromResponse(_ response: [String: Any]?) -> String {
        guard let result = response?["result"] as? [[String: Any]],
              let firstResult = result.first,
              let prediction = firstResult["prediction"] as? [[String: Any]] else {
            return ""
        }

        // Concatenate all OCR text
        let texts = prediction.compactMap { $0["ocr_text"] as? String }
        return texts.joined(separator: "\n")
    }

    /// Extract filename from text using simple heuristics
    /// In a production app, this would call an LLM API
    private func extractFilename(from text: String) async -> String {
        let lines = text.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        // Try to find a title in the first few lines
        for line in lines.prefix(3) {
            // Look for date patterns
            if line.contains("/") || line.contains("-") {
                let cleaned = cleanFilename(line)
                if !cleaned.isEmpty {
                    return cleaned
                }
            }

            // Use first non-empty line if it's reasonable length
            if line.count >= 3 && line.count <= 50 {
                return cleanFilename(line)
            }
        }

        // Fallback to date-based name
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }

    /// Clean a string to be a valid filename
    private func cleanFilename(_ text: String) -> String {
        // Remove invalid filename characters
        let invalidCharacters = CharacterSet(charactersIn: "/<>:\"|?*\\")
        let components = text.components(separatedBy: invalidCharacters)
        return components.joined().trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Process multiple images in batch
    func processImages(_ images: [UIImage]) async throws -> [(text: String, suggestedFilename: String)] {
        var results: [(String, String)] = []

        for (index, image) in images.enumerated() {
            do {
                let result = try await processImage(image)
                results.append(result)
            } catch {
                // If one image fails, use fallback
                let fallbackName = "Untitled \(index + 1)"
                results.append(("", fallbackName))
            }
        }

        return results
    }
}
