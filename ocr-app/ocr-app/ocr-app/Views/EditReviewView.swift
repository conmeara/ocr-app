//
//  EditReviewView.swift
//  OCRApp
//
//  Review and edit OCR results with Liquid Glass UI
//

import SwiftUI

struct EditReviewView: View {
    @EnvironmentObject var viewModel: OCRViewModel

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                // List of pages
                ScrollView {
                    LazyVStack(spacing: Constants.standardPadding) {
                        ForEach(viewModel.ocrPages) { page in
                            PageCardView(
                                page: page,
                                isEditable: true,
                                onUpdate: { filename, text in
                                    viewModel.updatePage(page, filename: filename, text: text)
                                },
                                onDelete: {
                                    viewModel.deletePage(page)
                                }
                            )
                        }
                    }
                    .padding(Constants.standardPadding)
                }

                // Bottom action bar
                VStack(spacing: Constants.standardPadding) {
                    Text("\(viewModel.ocrPages.count) page\(viewModel.ocrPages.count == 1 ? "" : "s") ready")
                        .font(.headline)
                        .foregroundStyle(.white)

                    Button(action: {
                        viewModel.navigateToResults()
                    }) {
                        HStack {
                            Text("Continue")
                            Image(systemName: "arrow.right")
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: Constants.actionButtonHeight)
                    }
                    .buttonStyle(.glass)
                    .glassEffect(.regular, in: .rect(cornerRadius: Constants.actionButtonCornerRadius))
                    .disabled(viewModel.ocrPages.isEmpty)
                }
                .padding(Constants.standardPadding)
                .background(Material.ultraThickMaterial)
            }
        }
        .navigationTitle("Review & Edit")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK") {}
        } message: {
            Text(viewModel.errorMessage ?? "An error occurred")
        }
    }
}

#Preview {
    NavigationStack {
        EditReviewView()
            .environmentObject({
                let vm = OCRViewModel()
                vm.ocrPages = [
                    OCRPage(photoId: UUID(), suggestedFilename: "Daily Reflection", text: "Today was great!"),
                    OCRPage(photoId: UUID(), suggestedFilename: "Meeting Notes", text: "Discussed project timeline")
                ]
                return vm
            }())
    }
}
