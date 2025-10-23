//
//  OCRApp.swift
//  OCRApp
//
//  Created for iOS 26 with Liquid Glass UI
//

import SwiftUI

@main
struct OCRApp: App {
    @StateObject private var viewModel = OCRViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var viewModel: OCRViewModel

    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            CaptureView()
                .navigationDestination(for: NavigationDestination.self) { destination in
                    switch destination {
                    case .photoGrid:
                        PhotoGridView()
                    case .processing:
                        ProcessingView()
                    case .editReview:
                        EditReviewView()
                    case .results:
                        ResultsView()
                    }
                }
        }
    }
}

enum NavigationDestination: Hashable {
    case photoGrid
    case processing
    case editReview
    case results
}
