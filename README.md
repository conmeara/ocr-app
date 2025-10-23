# OCR Scanner App

A modern iOS 26 app with Liquid Glass UI for scanning handwritten notes, journals, and whiteboard sessions using OCR technology.

## Features

- **Multi-Photo Capture**: Take or select multiple photos in one session
- **Smart OCR Processing**: Powered by Nanonets OCR2-3B model for accurate text extraction
- **Intelligent Filename Detection**: Automatically extracts titles from your handwriting
- **Batch Export**: Save multiple pages as separate files (perfect for Obsidian journals!)
- **Flexible Formats**: Export as Markdown or Plain Text
- **Multiple Export Options**:
  - Copy to clipboard
  - Save to folder (batch save)
  - Share via iOS share sheet
- **Liquid Glass UI**: Beautiful iOS 26 design with glassmorphic effects
- **Edit Before Export**: Review and edit filenames and text before saving

## Perfect for

- Daily journal entries (save each day as a separate file)
- Meeting notes
- Whiteboard sessions
- Handwritten documents
- Obsidian vault management

## Requirements

- iOS 26.0+ (backward compatible to iOS 17)
- Xcode 16.0+
- Swift 5.9+
- Nanonets API account and API key

## Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/conmeara/ocr-app.git
cd ocr-app
```

### 2. Configure Nanonets API

1. Sign up for a Nanonets account at [https://nanonets.com](https://nanonets.com)
2. Get your API key from the dashboard
3. Open `ocr-app/ocr-app/Services/NanonetsService.swift`
4. Add your API key:

```swift
private let apiKey: String = "YOUR_API_KEY_HERE"
```

5. Update the model ID in the endpoint:

```swift
private let ocrEndpoint = "https://app.nanonets.com/api/v2/OCR/Model/YOUR_MODEL_ID/LabelFile/"
```

### 3. Open in Xcode

1. **Double-click** on `ocr-app/ocr-app/ocr-app.xcodeproj` to open the project in Xcode

2. The project structure will look like:
   ```
   ocr-app (project)
   ├── ocr-app (folder)
   │   ├── Models/
   │   ├── Services/
   │   ├── ViewModels/
   │   ├── Views/
   │   └── OCRApp.swift
   └── Assets.xcassets
   ```

### 4. Add Privacy Permissions

In Xcode:
1. Select the project in the navigator
2. Select the "ocr-app" target
3. Go to the "Info" tab
4. Add these keys under "Custom iOS Target Properties":
   - **Privacy - Camera Usage Description**: "We need access to your camera to capture photos of your handwritten notes and journals for OCR processing."
   - **Privacy - Photo Library Usage Description**: "We need access to your photo library to select images for OCR processing."

### 5. Build and Run

1. Select your target device (iPhone simulator or real device with iOS 17+)
2. Press **⌘R** or click the Run button
3. Grant camera and photo library permissions when prompted

## Project Structure

```
OCRApp/
├── Models/
│   ├── Constants.swift          # Liquid Glass UI styling constants
│   ├── CapturedPhoto.swift      # Photo data model
│   ├── OCRPage.swift            # Processed page model
│   └── ExportFormat.swift       # Export format options
├── Services/
│   ├── NanonetsService.swift   # OCR API integration
│   ├── FileService.swift       # Multi-file saving
│   └── ClipboardService.swift  # Clipboard operations
├── ViewModels/
│   └── OCRViewModel.swift      # Main app state management
├── Views/
│   ├── CaptureView.swift       # Photo capture screen
│   ├── PhotoGridView.swift     # Photo review grid
│   ├── ProcessingView.swift    # OCR processing screen
│   ├── EditReviewView.swift    # Edit filenames/text
│   ├── ResultsView.swift       # Export options
│   └── Components/
│       └── PageCardView.swift  # Reusable page card
├── OCRApp.swift                # App entry point
└── Info.plist                  # App permissions

```

## Usage

### Basic Workflow

1. **Capture Photos**
   - Tap "Take Photo" to use camera
   - Or "Choose from Library" to select existing photos
   - Take multiple photos (e.g., a week's worth of journal pages)

2. **Review Photos**
   - View all captured photos in a grid
   - Delete any unwanted photos
   - Add more photos if needed
   - Tap "Process" when ready

3. **OCR Processing**
   - App processes each photo with OCR
   - Extracts text from your handwriting
   - Suggests filenames based on content

4. **Edit & Review**
   - Review each page's extracted text
   - Edit filenames and text as needed
   - Delete any pages you don't want to save

5. **Export**
   - Choose format: Markdown or Plain Text
   - **Copy All**: Copy all pages to clipboard
   - **Save to Folder**: Select a folder (like your Obsidian vault)
   - **Share**: Use iOS share sheet for AirDrop, Messages, etc.

### Obsidian Workflow Example

1. Scan your week's journal pages (7 photos)
2. Process with OCR
3. Edit filenames to dates: "2025-10-16.md", "2025-10-17.md", etc.
4. Choose Markdown format
5. Save to your Obsidian vault folder
6. Each day becomes a separate note!

## Liquid Glass UI

This app showcases iOS 26's Liquid Glass design system:

- `.glassEffect()` modifiers for frosted glass backgrounds
- `.buttonStyle(.glass)` for glassmorphic buttons
- `Material.ultraThickMaterial` backgrounds
- Smooth animations and transitions
- Consistent spacing and corner radii

## API Integration

The app uses the Nanonets OCR API:

- **Endpoint**: OCR2-3B model
- **Features**:
  - Handwriting recognition
  - Text extraction
  - Batch processing
- **Filename Detection**: Uses heuristics to extract titles from text (can be enhanced with LLM integration)

## Customization

### Adjust UI Constants

Edit `Models/Constants.swift` to customize:
- Corner radii
- Spacing
- Button sizes
- Glass effect parameters

### Improve Filename Detection

The current filename detection uses simple heuristics. To enhance:

1. Integrate with an LLM API (OpenAI, Anthropic, etc.)
2. Update `NanonetsService.extractFilename()` to call the LLM
3. Provide a prompt like: "Extract a concise title from this text for use as a filename"

### Add More Export Formats

1. Add new case to `ExportFormat` enum
2. Implement format method
3. UI automatically updates

## Troubleshooting

### OCR Not Working

- Check API key is correct in `NanonetsService.swift`
- Verify internet connection
- Check Nanonets account status and quota

### Camera Not Available

- Ensure Info.plist permissions are configured
- Check device camera permissions in Settings
- Test on physical device (simulator has limited camera)

### Files Not Saving

- Ensure you selected a valid folder
- Check app has file system permissions
- Try saving to iCloud Drive folder

## Future Enhancements

- [ ] On-device OCR for offline use
- [ ] Cloud sync for processed documents
- [ ] Multiple language support
- [ ] Auto-detect dates in handwriting
- [ ] Custom export templates
- [ ] Batch rename with patterns
- [ ] Integration with more note-taking apps

## License

This project is provided as-is for educational and personal use.

## Credits

- Built with SwiftUI and iOS 26 Liquid Glass UI
- OCR powered by Nanonets
- Inspired by Apple's Landmarks sample app

## Support

For issues or questions:
1. Check the troubleshooting section
2. Review Nanonets API documentation
3. Verify all setup steps were completed

---

**Happy Scanning!** 📱✨
