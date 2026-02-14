# Quick APK Build - No Android Studio

## Method 1: Install Android SDK via Homebrew (Easiest)

### Step 1: Install Android command line tools

```bash
brew install --cask android-studio

# OR just the command line tools:
brew install --cask android-commandlinetools
```

### Step 2: Set environment variables

Add these to your shell config (`~/.zshrc` or `~/.bash_profile`):

```bash
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/tools
```

Then reload:
```bash
source ~/.zshrc
```

### Step 3: Accept licenses and build

```bash
cd /Users/asachan/.openclaw/workspace/speech_recorder_app

# Accept Android licenses
flutter doctor --android-licenses

# Build APK
flutter build apk --release
```

APK location: `build/app/outputs/flutter-apk/app-release.apk`

---

## Method 2: Use GitHub Actions (No local Android SDK needed)

See `GITHUB_BUILD.md` — upload your code to GitHub, build happens in the cloud.

---

## Method 3: Use an Online Flutter Builder

**BuddyBuild** (Free tier available)
- Upload code
- Get APK link

**APKMirror** (For testing only)

**QBuild** (Free, but slow)

---

## Why This Happens

Flutter builds native Android apps (APK) using the Android SDK. The SDK is included with Android Studio, but you can also install just the command line tools without the full IDE.

---

## Troubleshooting

**"No Android SDK found"**:
- Install Android Studio or run `flutter doctor --android-licenses`
- Set ANDROID_HOME environment variable

**Permission denied**:
- Run `flutter doctor` to check
- Accept all licenses with `flutter doctor --android-licenses`

**Build fails**:
- Check Flutter version: `flutter --version`
- Run `flutter pub get` to install dependencies
- Delete `build/` folder and try again
