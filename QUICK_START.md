# Quick Start Guide

Get the app running in 5 minutes!

## Step 1: Clone the Repository

```bash
git clone https://github.com/conmeara/ocr-app.git
cd ocr-app
```

## Step 2: Open in Xcode

```bash
open ocr-app.xcodeproj
```

Or **double-click** `ocr-app.xcodeproj` in Finder.

## Step 3: Add Privacy Permissions

In Xcode:
1. Select the project in the navigator
2. Select the "ocr-app" target
3. Go to the **Info** tab
4. Click **+** under "Custom iOS Target Properties"
5. Add these two keys:

| Key | Value |
|-----|-------|
| Privacy - Camera Usage Description | `We need access to your camera to capture photos of your handwritten notes and journals for OCR processing.` |
| Privacy - Photo Library Usage Description | `We need access to your photo library to select images for OCR processing.` |

## Step 4: Add Your Nanonets API Key

Open `ocr-app/Services/NanonetsService.swift` and add your API key:

```swift
private let apiKey: String = "YOUR_NANONETS_API_KEY"
private let ocrEndpoint = "https://app.nanonets.com/api/v2/OCR/Model/YOUR_MODEL_ID/LabelFile/"
```

Get your API key from: https://nanonets.com

## Step 5: Build and Run

1. Select a simulator or device (iOS 17+)
2. Press **⌘R** to build and run
3. Grant camera and photo permissions when prompted
4. Start scanning! 📸

## Project Structure

```
ocr-app/
├── ocr-app.xcodeproj/       ← Double-click to open
├── ocr-app/                 ← Source code
│   ├── Models/
│   ├── Services/            ← Add API key here
│   ├── ViewModels/
│   ├── Views/
│   └── OCRApp.swift
├── samples/                 ← Liquid Glass UI reference
├── README.md
├── QUICK_START.md          ← You are here!
└── PROJECT_SUMMARY.md
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
