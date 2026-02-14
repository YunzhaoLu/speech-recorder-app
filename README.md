# Voice Recorder App

A simple Flutter application for recording audio on Android.

## Features

- ✅ Record audio from microphone
- ✅ View all recordings with timestamps
- ✅ Playback recordings
- ✅ Delete recordings
- ✅ Share recordings (UI ready, cloud integration pending)
- ✅ Export APK for installation on Android devices

## Tech Stack

- Flutter 3.11+
- `record` - Audio recording
- `audioplayers` - Audio playback
- `path_provider` - File system access
- `permission_handler` - Permission management

## Getting Started

### Prerequisites

1. Flutter SDK installed (>= 3.11.0)
2. Android Studio installed with Android SDK
3. A physical Android device or emulator

### Setup

```bash
# Navigate to the project directory
cd speech_recorder_app

# Install dependencies
flutter pub get

# Run on device/emulator
flutter run
```

### Build APK

```bash
# Release APK
flutter build apk --release

# Debug APK
flutter build apk --debug
```

The APK will be generated in:
```
build/app/outputs/flutter-apk/app-release.apk
```

## Installation

1. Transfer the APK to your Android device
2. Enable "Install from unknown sources" in device settings
3. Install the APK
4. Grant microphone permission when prompted

## Usage

1. **Record**: Tap the green microphone button to start recording
2. **Stop**: Tap the red stop button to finish recording
3. **Playback**: Tap the play button to play a recording
4. **Share**: Tap the share icon to open sharing options (cloud upload coming soon)
5. **Delete**: Tap the delete icon to remove a recording

## Project Structure

```
speech_recorder_app/
├── lib/
│   ├── main.dart           # Main application UI
│   └── recorder.dart       # Audio recording logic
├── android/                # Android platform code
├── ios/                    # iOS platform code
├── pubspec.yaml           # Dependencies
└── README.md              # This file
```

## Future Enhancements

- [ ] Cloud storage integration (Aliyun OSS, AWS S3, Cloudinary)
- [ ] Text-to-speech summaries
- [ ] Export to different audio formats (MP3, WAV)
- [ ] Cloud backup
- [ ] Multi-language support
- [ ] Recording quality settings
- [ ] Organize recordings into folders

## Notes

- All recordings are stored in the app's private directory on the device
- File format: M4A (MP4 audio)
- App uses the device's microphone permission
- No data is uploaded to cloud (pending feature)

## License

Private project
