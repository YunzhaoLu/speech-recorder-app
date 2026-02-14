# GitHub Actions Setup - Step by Step

## Step 1: Create GitHub Repository

1. Go to: https://github.com/new
2. Repository name: `speech-recorder-app`
3. Make it **Public** or **Private** (either works)
4. Click **"Create repository"**
5. You'll see a page with repository info

## Step 2: Get your GitHub username

Look at the URL:
```
https://github.com/YOUR_USERNAME/speech-recorder-app
```

Or check your profile page:
```
https://github.com/YOUR_USERNAME
```

Your username is after `github.com/`.

## Step 3: Initialize git and connect to GitHub

Run these commands in the terminal:

```bash
cd /Users/asachan/.openclaw/workspace/speech_recorder_app

# Initialize git (if not already)
git init

# Rename branch to main
git branch -M main

# Add all files
git add .

# Commit
git commit -m "Initial commit"

# Push to GitHub (replace YOUR_USERNAME below)
git remote add origin https://github.com/YOUR_USERNAME/speech-recorder-app.git
git push -u origin main
```

Replace `YOUR_USERNAME` with your actual GitHub username.

## Step 4: Enable GitHub Actions

1. Go to your repository on GitHub
2. Click the **"Actions"** tab (in the top menu)
3. Click **"I understand my workflows, go ahead and enable them"**

## Step 5: Wait for build to complete

1. The workflow will start automatically
2. Click on the workflow run
3. Scroll down to "Build APK" step
4. Once complete, click **app-release.apk** to download

That's it! No Android Studio needed.
