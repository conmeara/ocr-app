//
//  CaptureView.swift
//  OCRApp
//
//  Camera capture view with Liquid Glass UI
//

import SwiftUI
import PhotosUI

struct CaptureView: View {
    @EnvironmentObject var viewModel: OCRViewModel
    @State private var showCamera = false
    @State private var showPhotoPicker = false
    @State private var selectedItem: PhotosPickerItem?

    var body: some View {
        ZStack {
            // Background
            Color.black.ignoresSafeArea()

            VStack(spacing: Constants.standardPadding) {
                Spacer()

                // Title
                VStack(spacing: 8) {
                    Image(systemName: "doc.text.viewfinder")
                        .font(.system(size: 60))
                        .foregroundStyle(.white)

                    Text("OCR Scanner")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)

                    Text("Scan your handwritten notes and journals")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .padding(.bottom, 40)

                Spacer()

                // Action buttons with glass effect
                VStack(spacing: Constants.glassSpacing) {
                    // Camera button
                    Button(action: {
                        showCamera = true
                    }) {
                        HStack {
                            Image(systemName: "camera")
                                .font(.title2)
                            Text("Take Photo")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: Constants.actionButtonHeight)
                    }
                    .buttonStyle(.glass)
                    .glassEffect(.regular, in: .rect(cornerRadius: Constants.actionButtonCornerRadius))

                    // Photo library button
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        HStack {
                            Image(systemName: "photo.on.rectangle")
                                .font(.title2)
                            Text("Choose from Library")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: Constants.actionButtonHeight)
                    }
                    .buttonStyle(.glass)
                    .glassEffect(.regular, in: .rect(cornerRadius: Constants.actionButtonCornerRadius))

                    // Continue button (only show if photos captured)
                    if !viewModel.capturedPhotos.isEmpty {
                        Button(action: {
                            viewModel.navigateToPhotoGrid()
                        }) {
                            HStack {
                                Text("\(viewModel.capturedPhotos.count) photo\(viewModel.capturedPhotos.count == 1 ? "" : "s") captured")
                                    .font(.headline)
                                Image(systemName: "arrow.right")
                                    .font(.title2)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: Constants.actionButtonHeight)
                        }
                        .buttonStyle(.glass)
                        .glassEffect(.regular, in: .rect(cornerRadius: Constants.actionButtonCornerRadius))
                    }
                }
                .padding(.horizontal, Constants.safeAreaPadding)
                .padding(.bottom, Constants.safeAreaPadding)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showCamera) {
            CameraPickerView { image in
                viewModel.addPhoto(image)
            }
        }
        .onChange(of: selectedItem) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    viewModel.addPhoto(image)
                }
            }
        }
    }
}

// MARK: - Camera Picker

struct CameraPickerView: UIViewControllerRepresentable {
    let onImageCaptured: (UIImage) -> Void

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraPickerView

        init(_ parent: CameraPickerView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.onImageCaptured(image)
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

#Preview {
    NavigationStack {
        CaptureView()
            .environmentObject(OCRViewModel())
    }
}
