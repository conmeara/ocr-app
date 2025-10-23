//
//  ProcessingView.swift
//  OCRApp
//
//  OCR processing view with Liquid Glass UI
//

import SwiftUI

struct ProcessingView: View {
    @EnvironmentObject var viewModel: OCRViewModel
    @State private var rotationAngle: Double = 0

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 40) {
                Spacer()

                // Animated icon
                ZStack {
                    Circle()
                        .fill(Material.regularMaterial)
                        .frame(width: 120, height: 120)
                        .glassEffect(.regular, in: .circle)

                    Image(systemName: "doc.text.magnifyingglass")
                        .font(.system(size: 50))
                        .foregroundStyle(.white)
                        .rotationEffect(.degrees(rotationAngle))
                }
                .onAppear {
                    withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                        rotationAngle = 360
                    }
                }

                // Progress text
                VStack(spacing: 12) {
                    Text("Processing Images")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)

                    Text("Extracting text from your photos...")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.7))
                }

                // Progress bar
                VStack(spacing: 8) {
                    ProgressView(value: viewModel.processingProgress)
                        .progressViewStyle(.linear)
                        .tint(.white)
                        .scaleEffect(y: 2)

                    Text("\(Int(viewModel.processingProgress * 100))%")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.7))
                }
                .padding(.horizontal, 40)

                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        ProcessingView()
            .environmentObject(OCRViewModel())
    }
}
