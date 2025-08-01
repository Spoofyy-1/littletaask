# LittleTask Deployment Guide

## 🚀 Quick Setup

### 1. Push to GitHub

```bash
# Initialize git repository
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: LittleTask v1.0.0"

# Add your GitHub repository as remote
git remote add origin git@github.com:Spoofyy-1/littletaask.git

# Push to GitHub
git branch -M main
git push -u origin main
```

### 2. Deploy Website on Vercel

1. **Go to [vercel.com](https://vercel.com) and sign up/login**
2. **Connect your GitHub account**
3. **Import your repository:**
   - Click "New Project"
   - Select `Spoofyy-1/littletaask`
   - Framework Preset: "Other"
   - Root Directory: `./website`
   - Build Command: Leave empty
   - Output Directory: Leave empty
4. **Deploy!**

Your website will be live at: `https://littletaask.vercel.app`

### 3. Create First Release

```bash
# Create and push a tag for v1.0.0
git tag v1.0.0
git push origin v1.0.0
```

This will trigger GitHub Actions to:
- ✅ Build the LittleTask app
- ✅ Create a DMG file
- ✅ Create a GitHub release
- ✅ Make the download button work!

## 🔧 Configuration Files

### Vercel Configuration (`vercel.json`)
- ✅ Configured to serve from `website/` directory
- ✅ Proper caching headers
- ✅ Static file serving

### GitHub Actions (`.github/workflows/build.yml`)
- ✅ Builds on macOS
- ✅ Creates DMG automatically
- ✅ Uploads to GitHub releases

## 📱 Features Added

### ✅ Keyboard Shortcuts
- **⌘R**: Record/Stop
- **⌘P**: Play/Stop  
- **⌘⌫**: Clear recording

### ✅ Working Download Button
- Downloads from GitHub releases
- Shows progress feedback
- Handles errors gracefully

## 🎯 Next Steps

1. **Push to GitHub** (see commands above)
2. **Deploy on Vercel** (follow steps above)
3. **Create first release** with `git tag v1.0.0`
4. **Test the download button** on your live website!

## 🔄 Future Updates

To release a new version:

```bash
# Make your changes
git add .
git commit -m "Update: New feature"
git push

# Create new version tag
git tag v1.1.0
git push origin v1.1.0
```

This will automatically:
- Build new DMG
- Create GitHub release
- Update download links
- Keep website in sync 