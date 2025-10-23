//
//  PhotoGridView.swift
//  OCRApp
//
//  Photo review grid with Liquid Glass UI
//

import SwiftUI

struct PhotoGridView: View {
    @EnvironmentObject var viewModel: OCRViewModel

    private let columns = [
        GridItem(.adaptive(minimum: Constants.photoGridItemMinSize, maximum: Constants.photoGridItemMaxSize), spacing: Constants.photoGridSpacing)
    ]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                // Grid of photos
                ScrollView {
                    LazyVGrid(columns: columns, spacing: Constants.photoGridSpacing) {
                        ForEach(viewModel.capturedPhotos) { photo in
                            PhotoThumbnailView(photo: photo) {
                                viewModel.removePhoto(photo)
                            }
                        }
                    }
                    .padding(Constants.standardPadding)
                }

                // Bottom action bar
                VStack(spacing: Constants.standardPadding) {
                    Text("\(viewModel.capturedPhotos.count) photo\(viewModel.capturedPhotos.count == 1 ? "" : "s")")
                        .font(.headline)
                        .foregroundStyle(.white)

                    HStack(spacing: Constants.standardPadding) {
                        // Add more button
                        Button(action: {
                            viewModel.goBack()
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                Text("Add More")
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: Constants.actionButtonHeight)
                        }
                        .buttonStyle(.glass)
                        .glassEffect(.regular, in: .rect(cornerRadius: Constants.actionButtonCornerRadius))

                        // Process button
                        Button(action: {
                            Task {
                                viewModel.navigateToProcessing()
                                await viewModel.processPhotos()
                            }
                        }) {
                            HStack {
                                Text("Process")
                                Image(systemName: "arrow.right")
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: Constants.actionButtonHeight)
                        }
                        .buttonStyle(.glass)
                        .glassEffect(.regular, in: .rect(cornerRadius: Constants.actionButtonCornerRadius))
                        .disabled(viewModel.capturedPhotos.isEmpty)
                    }
                }
                .padding(Constants.standardPadding)
                .background(Material.ultraThickMaterial)
            }
        }
        .navigationTitle("Review Photos")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(role: .destructive) {
                    viewModel.clearPhotos()
                    viewModel.goBack()
                } label: {
                    Text("Clear All")
                        .foregroundStyle(.red)
                }
            }
        }
    }
}

// MARK: - Photo Thumbnail

struct PhotoThumbnailView: View {
    let photo: CapturedPhoto
    let onDelete: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image(uiImage: photo.image)
                .resizable()
                .aspectRatio(1, contentMode: .fill)
                .frame(minWidth: Constants.photoGridItemMinSize, maxWidth: Constants.photoGridItemMaxSize)
                .frame(height: Constants.photoGridItemMinSize)
                .clipped()
                .cornerRadius(Constants.cornerRadius)
                .glassEffect(.regular, in: .rect(cornerRadius: Constants.cornerRadius))

            // Delete button
            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .background(
                        Circle()
                            .fill(.black.opacity(0.3))
                            .frame(width: 30, height: 30)
                    )
            }
            .padding(8)
        }
    }
}

#Preview {
    NavigationStack {
        PhotoGridView()
            .environmentObject(OCRViewModel())
    }
}
