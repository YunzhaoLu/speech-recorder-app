# How to Build APK Using GitHub Actions

## Option 1: Create a GitHub Repository (Recommended)

### Step 1: Create a new repository on GitHub

1. Go to https://github.com/new
2. Repository name: `speech-recorder-app`
3. Public or Private (either works)
4. Click "Create repository"
5. Click "Add file" → "Create new file"
6. Name the file `README.md` and paste this content:
```markdown
# Voice Recorder App

A simple Flutter application for recording audio on Android.
```
7. Click "Commit changes"
8. Click "Copy URL" for your repository

### Step 2: Connect your local repo to GitHub

```bash
cd /Users/asachan/.openclaw/workspace/speech_recorder_app

# Rename branch to main
git branch -M main

# Add remote
git remote add origin https://github.com/YOUR_USERNAME/speech-recorder-app.git

# Add all files
git add .

# Commit
git commit -m "Initial commit"

# Push to GitHub
git push -u origin main
```

Replace `YOUR_USERNAME` with your actual GitHub username.

### Step 3: Enable GitHub Actions (Optional)

1. Go to your repository on GitHub
2. Click "Actions" tab
3. Click "I understand my workflows, go ahead and enable them"

### Step 4: Wait for build to complete

The build will automatically start when you push. Check:
- GitHub Actions tab
- Status: "Build Android APK" workflow

### Step 5: Download APK

1. Go to "Actions" tab
2. Click the latest workflow run
3. Scroll to "Build APK" step
4. Click "app-release.apk" to download

That's it! No Android Studio needed.

---

## Option 2: Use Another CI/CD Service

### Firebase App Distribution (Easier)

1. Create Firebase project: https://console.firebase.google.com/
2. Add Android app
3. Get SHA-1 fingerprint from device
4. Add Firebase to your Flutter project
5. Use Firebase CLI to upload APK

### AppCenter

1. Create free account: https://appcenter.ms/
2. Create new project
3. Connect GitHub repository
4. Build automatically happens

---

## Need Help?

If you encounter issues:
- Check the GitHub Actions logs
- Make sure all files are committed
- Ensure Flutter version matches
