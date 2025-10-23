# Quick Start Guide

## Immediate Next Steps

### 1. Create Xcode Project (5 minutes)

```bash
# Open Xcode and create a new project:
# - File > New > Project
# - Choose "iOS App"
# - Product Name: OCRApp
# - Interface: SwiftUI
# - Language: Swift
# - Save in: /Users/conmeara/code/ocr-app/
```

**Important**: When Xcode creates the project, it will create a new `OCRApp` folder. You'll need to replace the auto-generated files with the files from this directory.

### 2. Add Files to Xcode Project

1. In Xcode, delete the auto-generated `ContentView.swift` and `OCRApp.swift`
2. Drag the following folders from Finder into your Xcode project:
   - `Models/`
   - `Services/`
   - `ViewModels/`
   - `Views/`
   - `OCRApp.swift`
3. When prompted, select:
   - ✅ Copy items if needed
   - ✅ Create groups
   - ✅ Add to target: OCRApp

### 3. Configure Info.plist

1. In Xcode, locate the auto-generated `Info.plist`
2. Replace it with the `Info.plist` from this directory
3. Or manually add these keys:
   - `NSCameraUsageDescription`
   - `NSPhotoLibraryUsageDescription`
   - `UISupportsDocumentBrowser`
   - `LSSupportsOpeningDocumentsInPlace`

### 4. Add Your Nanonets API Key

Open `Services/NanonetsService.swift` and add your API key:

```swift
private let apiKey: String = "YOUR_NANONETS_API_KEY"
private let ocrEndpoint = "https://app.nanonets.com/api/v2/OCR/Model/YOUR_MODEL_ID/LabelFile/"
```

Get your API key from: https://nanonets.com

### 5. Build and Run

1. Select a simulator or device (iOS 17+)
2. Press ⌘R to build and run
3. Grant camera and photo permissions when prompted

## File Organization

All Swift files are organized in a clean architecture:

```
OCRApp/
├── OCRApp.swift              ← Main app entry point
├── Models/                   ← Data models
│   ├── Constants.swift
│   ├── CapturedPhoto.swift
│   ├── OCRPage.swift
│   └── ExportFormat.swift
├── Services/                 ← Business logic
│   ├── NanonetsService.swift
│   ├── FileService.swift
│   └── ClipboardService.swift
├── ViewModels/              ← State management
│   └── OCRViewModel.swift
└── Views/                   ← UI components
    ├── CaptureView.swift
    ├── PhotoGridView.swift
    ├── ProcessingView.swift
    ├── EditReviewView.swift
    ├── ResultsView.swift
    └── Components/
        └── PageCardView.swift
```

## Testing Without API Key

If you want to test the UI without setting up Nanonets:

1. Comment out the API call in `NanonetsService.swift`
2. Return mock data:

```swift
func processImage(_ image: UIImage) async throws -> (text: String, suggestedFilename: String) {
    // Simulate processing delay
    try await Task.sleep(nanoseconds: 1_000_000_000)

    // Return mock data
    return ("This is mock OCR text from your image.", "Mock Document")
}
```

## Key Features to Test

1. **Multi-Photo Capture**: Take 3-5 photos in a row
2. **Photo Review**: Delete and add more photos
3. **OCR Processing**: Watch the progress animation
4. **Edit Review**: Edit filenames and text
5. **Format Selection**: Toggle between Markdown and Plain Text
6. **Copy**: Test clipboard functionality
7. **Save**: Select your Documents folder
8. **Share**: Use AirDrop or Messages

## Troubleshooting

**Build Errors?**
- Make sure all files are added to the OCRApp target
- Check that SwiftUI is properly imported
- Verify iOS deployment target is 17.0+

**Simulator Issues?**
- Camera won't work on simulator - use photo library instead
- Or test on a real device

**API Errors?**
- Double-check API key format
- Verify internet connection
- Check Nanonets account status

## Next Steps

Once the app works:

1. Customize the UI colors in `Constants.swift`
2. Enhance filename detection with an LLM
3. Add additional export formats
4. Implement cloud sync

---

For detailed documentation, see `README.md`
