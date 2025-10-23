//
//  Constants.swift
//  OCRApp
//
//  Constant values for Liquid Glass UI design
//

import SwiftUI

/// Constant values that the app defines for Liquid Glass UI
struct Constants {
    // MARK: - App-wide constants

    static let cornerRadius: CGFloat = 15.0
    static let standardPadding: CGFloat = 14.0
    static let safeAreaPadding: CGFloat = 30.0

    // MARK: - Glass effect constants

    static let glassSpacing: CGFloat = 16.0
    static let glassCornerRadius: CGFloat = 24.0

    // MARK: - Photo grid constants

    static let photoGridSpacing: CGFloat = 14.0
    @MainActor static var photoGridItemMinSize: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 240.0
        } else {
            return 160.0
        }
    }
    static let photoGridItemMaxSize: CGFloat = 320.0
    static let photoThumbnailSize: CGFloat = 120.0

    // MARK: - Camera constants

    static let cameraButtonSize: CGFloat = 72.0
    static let cameraButtonIconSize: CGFloat = 32.0
    static let thumbnailPreviewSize: CGFloat = 60.0

    // MARK: - Page card constants

    static let pageCardHeight: CGFloat = 200.0
    static let pageCardPadding: CGFloat = 16.0
    static let pageCardSpacing: CGFloat = 12.0

    // MARK: - Button constants

    static let actionButtonHeight: CGFloat = 50.0
    static let actionButtonCornerRadius: CGFloat = 12.0
    static let smallButtonSize: CGFloat = 44.0

    // MARK: - Style

    static let backgroundStyle = Material.ultraThickMaterial
    static let cardBackgroundStyle = Material.regularMaterial
}
