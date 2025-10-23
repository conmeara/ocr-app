//
//  ResultsView.swift
//  OCRApp
//
//  Final results view with export options and Liquid Glass UI
//

import SwiftUI
import UniformTypeIdentifiers

struct ResultsView: View {
    @EnvironmentObject var viewModel: OCRViewModel
    @State private var showFilePicker = false
    @State private var showShareSheet = false
    @State private var shareItems: [Any] = []
    @State private var showCopyConfirmation = false
    @State private var showSaveSuccess = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: Constants.standardPadding) {
                // Success header
                VStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.green)

                    Text("Processing Complete")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)

                    Text("\(viewModel.ocrPages.count) page\(viewModel.ocrPages.count == 1 ? "" : "s") extracted")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.7))
                }
                .padding(.top, 40)

                // Format picker
                VStack(alignment: .leading, spacing: 12) {
                    Text("Export Format")
                        .font(.headline)
                        .foregroundStyle(.white)

                    HStack(spacing: Constants.standardPadding) {
                        ForEach(ExportFormat.allCases, id: \.self) { format in
                            FormatButton(
                                format: format,
                                isSelected: viewModel.selectedFormat == format
                            ) {
                                viewModel.selectedFormat = format
                            }
                        }
                    }
                }
                .padding(.horizontal, Constants.standardPadding)
                .padding(.top, 20)

                Spacer()

                // Pages preview
                ScrollView {
                    LazyVStack(spacing: Constants.standardPadding) {
                        ForEach(viewModel.ocrPages) { page in
                            PageCardView(page: page, isEditable: false)
                        }
                    }
                    .padding(Constants.standardPadding)
                }

                Spacer()

                // Action buttons
                VStack(spacing: Constants.glassSpacing) {
                    // Copy button
                    Button(action: {
                        viewModel.copyAllPages()
                        showCopyConfirmation = true
                    }) {
                        HStack {
                            Image(systemName: "doc.on.doc")
                            Text("Copy All")
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: Constants.actionButtonHeight)
                    }
                    .buttonStyle(.glass)
                    .glassEffect(.regular, in: .rect(cornerRadius: Constants.actionButtonCornerRadius))

                    // Save button
                    Button(action: {
                        showFilePicker = true
                    }) {
                        HStack {
                            Image(systemName: "folder")
                            Text("Save to Folder")
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: Constants.actionButtonHeight)
                    }
                    .buttonStyle(.glass)
                    .glassEffect(.regular, in: .rect(cornerRadius: Constants.actionButtonCornerRadius))

                    // Share button
                    Button(action: {
                        prepareShare()
                    }) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share")
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: Constants.actionButtonHeight)
                    }
                    .buttonStyle(.glass)
                    .glassEffect(.regular, in: .rect(cornerRadius: Constants.actionButtonCornerRadius))

                    // Start over button
                    Button(action: {
                        viewModel.resetToCapture()
                    }) {
                        HStack {
                            Image(systemName: "arrow.counterclockwise")
                            Text("Start Over")
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: Constants.actionButtonHeight)
                    }
                    .buttonStyle(.glass)
                    .glassEffect(.regular, in: .rect(cornerRadius: Constants.actionButtonCornerRadius))
                }
                .padding(.horizontal, Constants.standardPadding)
                .padding(.bottom, Constants.safeAreaPadding)
            }
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showFilePicker) {
            DocumentPicker { url in
                saveToFolder(url)
            }
        }
        .sheet(isPresented: $showShareSheet) {
            if !shareItems.isEmpty {
                ShareSheet(items: shareItems)
            }
        }
        .overlay {
            if showCopyConfirmation {
                CopyConfirmationBanner()
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showCopyConfirmation = false
                            }
                        }
                    }
            }
        }
        .overlay {
            if showSaveSuccess {
                SaveSuccessBanner()
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showSaveSuccess = false
                            }
                        }
                    }
            }
        }
    }

    private func prepareShare() {
        do {
            let urls = try viewModel.createTemporaryFiles()
            shareItems = urls
            showShareSheet = true
        } catch {
            viewModel.errorMessage = error.localizedDescription
            viewModel.showError = true
        }
    }

    private func saveToFolder(_ url: URL) {
        do {
            try viewModel.saveToFolder(folderURL: url)
            withAnimation {
                showSaveSuccess = true
            }
        } catch {
            viewModel.errorMessage = error.localizedDescription
            viewModel.showError = true
        }
    }
}

// MARK: - Format Button

struct FormatButton: View {
    let format: ExportFormat
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: format.icon)
                    .font(.title2)
                Text(format.rawValue)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .foregroundStyle(isSelected ? .white : .white.opacity(0.6))
            .background(isSelected ? Material.regularMaterial : Material.thinMaterial)
            .cornerRadius(Constants.cornerRadius)
            .overlay {
                if isSelected {
                    RoundedRectangle(cornerRadius: Constants.cornerRadius)
                        .stroke(.white, lineWidth: 2)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Confirmation Banners

struct CopyConfirmationBanner: View {
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                Text("Copied to clipboard")
                    .font(.headline)
                    .foregroundStyle(.white)
            }
            .padding()
            .background(Material.thickMaterial)
            .cornerRadius(Constants.cornerRadius)
            .glassEffect(.regular, in: .rect(cornerRadius: Constants.cornerRadius))
            .padding()

            Spacer()
        }
    }
}

struct SaveSuccessBanner: View {
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                Text("Files saved successfully")
                    .font(.headline)
                    .foregroundStyle(.white)
            }
            .padding()
            .background(Material.thickMaterial)
            .cornerRadius(Constants.cornerRadius)
            .glassEffect(.regular, in: .rect(cornerRadius: Constants.cornerRadius))
            .padding()

            Spacer()
        }
    }
}

// MARK: - Document Picker

struct DocumentPicker: UIViewControllerRepresentable {
    let onFolderSelected: (URL) -> Void

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.folder])
        picker.allowsMultipleSelection = false
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPicker

        init(_ parent: DocumentPicker) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            parent.onFolderSelected(url)
        }
    }
}

// MARK: - Share Sheet

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    NavigationStack {
        ResultsView()
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
