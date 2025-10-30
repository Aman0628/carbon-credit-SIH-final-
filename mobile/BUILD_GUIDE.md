# Carbon Credit Trading App - Build Guide

## 🚀 Successfully Built Platforms

### ✅ Android APK (Mobile)
- **Location**: `build/app/outputs/flutter-apk/app-release.apk`
- **Size**: 50.6 MB
- **Ready for**: Installation on Android devices, Google Play Store upload

### ✅ Web Application
- **Location**: `build/web/`
- **Ready for**: Web hosting, deployment to Firebase, Netlify, or any web server
- **Entry point**: `build/web/index.html`

### ❌ Windows Desktop
- **Status**: Failed due to path length limitations
- **Issue**: Windows 260 character path limit exceeded
- **Solution**: Move project to shorter path (e.g., `C:\carbon-app\`) and rebuild

## 📱 Installation Instructions

### Android APK Installation:
1. Transfer `app-release.apk` to your Android device
2. Enable "Install from Unknown Sources" in Settings
3. Tap the APK file to install
4. Launch "Carbon Credit App" from your app drawer

### Web Deployment:
1. Upload entire `build/web/` folder to your web server
2. Access via `https://yourdomain.com/index.html`
3. Or use services like:
   - Firebase Hosting: `firebase deploy`
   - Netlify: Drag & drop the web folder
   - GitHub Pages: Push to repository

## 🔧 Build Commands Used

```bash
# Get dependencies
flutter pub get

# Build Android APK
flutter build apk --release

# Build Web
flutter build web --release

# Build Windows (failed - path too long)
flutter build windows --release
```

## 📊 App Features Included

- ✅ EXC Token Trading System (replaced INR)
- ✅ Carbon Credit Marketplace
- ✅ Buyer & Seller Dashboards
- ✅ Wallet Management
- ✅ Portfolio Tracking
- ✅ Order Management
- ✅ Live Price Charts
- ✅ KYC/MRV Certificate System

## 🌐 Deployment Options

### For Mobile:
- **Google Play Store**: Upload `app-release.apk`
- **Direct Distribution**: Share APK file
- **Enterprise**: Use MDM solutions

### For Web:
- **Firebase Hosting**: `firebase init hosting && firebase deploy`
- **Netlify**: Drag & drop deployment
- **Vercel**: Connect GitHub repository
- **AWS S3**: Static website hosting
- **GitHub Pages**: Push to gh-pages branch

## 🔒 Security Notes

- APK is signed with debug key (for production, use release signing)
- Web build includes tree-shaking for optimized size
- All sensitive data should use environment variables in production

## 📞 Support

For deployment issues or questions, refer to:
- Flutter documentation: https://docs.flutter.dev/deployment
- Platform-specific guides in Flutter docs
