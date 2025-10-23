//
//  CapturedPhoto.swift
//  OCRApp
//
//  Model for captured photos
//

import SwiftUI
import PhotosUI

/// Represents a photo captured by the user
struct CapturedPhoto: Identifiable, Hashable {
    let id = UUID()
    let image: UIImage
    let timestamp: Date

    init(image: UIImage) {
        self.image = image
        self.timestamp = Date()
    }

    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: CapturedPhoto, rhs: CapturedPhoto) -> Bool {
        lhs.id == rhs.id
    }
}
