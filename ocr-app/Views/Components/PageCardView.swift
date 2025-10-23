//
//  PageCardView.swift
//  OCRApp
//
//  Reusable page card component with Liquid Glass UI
//

import SwiftUI

struct PageCardView: View {
    let page: OCRPage
    let isEditable: Bool
    let onUpdate: ((String, String) -> Void)?
    let onDelete: (() -> Void)?

    @State private var filename: String
    @State private var text: String
    @State private var isExpanded = false

    init(page: OCRPage, isEditable: Bool = false, onUpdate: ((String, String) -> Void)? = nil, onDelete: (() -> Void)? = nil) {
        self.page = page
        self.isEditable = isEditable
        self.onUpdate = onUpdate
        self.onDelete = onDelete
        _filename = State(initialValue: page.suggestedFilename)
        _text = State(initialValue: page.text)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Constants.pageCardSpacing) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    if isEditable {
                        TextField("Filename", text: $filename)
                            .font(.headline)
                            .textFieldStyle(.plain)
                            .foregroundStyle(.white)
                            .onChange(of: filename) { _, newValue in
                                onUpdate?(newValue, text)
                            }
                    } else {
                        Text(filename)
                            .font(.headline)
                            .foregroundStyle(.white)
                    }

                    Text("\(text.count) characters")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.6))
                }

                Spacer()

                // Action buttons
                HStack(spacing: 8) {
                    Button(action: {
                        withAnimation {
                            isExpanded.toggle()
                        }
                    }) {
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(.system(size: 16))
                            .foregroundStyle(.white)
                            .frame(width: Constants.smallButtonSize, height: Constants.smallButtonSize)
                    }
                    .buttonStyle(.glass)

                    if let onDelete = onDelete {
                        Button(action: onDelete) {
                            Image(systemName: "trash")
                                .font(.system(size: 16))
                                .foregroundStyle(.red)
                                .frame(width: Constants.smallButtonSize, height: Constants.smallButtonSize)
                        }
                        .buttonStyle(.glass)
                    }
                }
            }

            // Text preview or editor
            if isExpanded {
                if isEditable {
                    TextEditor(text: $text)
                        .font(.body)
                        .foregroundStyle(.white)
                        .scrollContentBackground(.hidden)
                        .background(Material.thin)
                        .cornerRadius(8)
                        .frame(minHeight: 200)
                        .onChange(of: text) { _, newValue in
                            onUpdate?(filename, newValue)
                        }
                } else {
                    ScrollView {
                        Text(text)
                            .font(.body)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(height: 200)
                }
            } else {
                Text(text)
                    .font(.body)
                    .foregroundStyle(.white.opacity(0.8))
                    .lineLimit(3)
            }
        }
        .padding(Constants.pageCardPadding)
        .background(Material.regularMaterial)
        .cornerRadius(Constants.cornerRadius)
        .glassEffect(.regular, in: .rect(cornerRadius: Constants.cornerRadius))
    }
}

#Preview {
    ZStack {
        Color.black
        PageCardView(
            page: OCRPage(
                photoId: UUID(),
                suggestedFilename: "Daily Reflection",
                text: "Today was a great day. I learned a lot about SwiftUI and the new Liquid Glass UI patterns."
            ),
            isEditable: true,
            onUpdate: { _, _ in }
        )
        .padding()
    }
}
