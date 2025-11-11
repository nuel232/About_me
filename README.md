# Flutter Portfolio App - Cross Platform (Web & Mobile)

A beautiful, animated portfolio application built with Flutter that works seamlessly on web, iOS, and Android. Matches the design of your React portfolio with enhanced animations.

## ✨ Features

- 🎨 **Stunning Animations**: Wave background, morphing profile borders, smooth transitions
- 📱 **Fully Responsive**: Works perfectly on mobile, tablet, and desktop
- 🌓 **Dark/Light Mode**: Toggle between themes with smooth transitions
- 🎯 **Bento Grid Layout**: Modern project showcase
- 📧 **Multi-Step Contact Form**: Engaging user experience
- ⚡ **Performance Optimized**: Smooth 60fps animations
- 🌐 **Web Ready**: Deploy to any web hosting platform
- 📲 **Mobile Ready**: Build for iOS and Android

## 🚀 Quick Start

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- For web: Chrome browser
- For mobile: Android Studio/Xcode

### Installation

1. **Clone or create your project**
```bash
flutter create portfolio_app
cd portfolio_app
```

2. **Replace the files with the provided code**
   - Copy `pubspec.yaml`
   - Create the folder structure
   - Copy all `.dart` files to their respective locations

3. **Install dependencies**
```bash
flutter pub get
```

4. **Enable web support** (if not already enabled)
```bash
flutter config --enable-web
```

5. **Run on your preferred platform**

For Web:
```bash
flutter run -d chrome
```

For Mobile (Android):
```bash
flutter run -d android
```

For Mobile (iOS):
```bash
flutter run -d ios
```

## 📁 Project Structure

```
lib/
├── main.dart                          # App entry point
├── Theme/
│   └── theme_provider.dart            # Theme management
    └── Light_mode.dart
    └── dark_mode.dart
├── screens/
│   └── home_screen.dart               # Main screen
└── widgets/
    ├── animated_profile_image.dart    # Morphing profile animation
    ├── custom_navbar.dart             # Navigation bar
    ├── hero_section.dart              # Hero section with waves
    ├── projects_section.dart          # Projects bento grid
    ├── about_section.dart             # About with skills
    ├── testimonials_section.dart      # Testimonials showcase
    ├── contact_section.dart           # Contact form
    ├── waves_background.dart          # Wave animation
    └── footer.dart                    # Footer component

assets/
├── images/
│   └── profile.jpg                    # Your profile image
└── CV.pdf                             # Your resume
```

## 🎨 Customization

### 1. Personal Information

Edit the text content in each widget file:

**Hero Section** (`widgets/hero_section.dart`):
```dart
Text('Kelechi')  // Change your name
```

**About Section** (`widgets/about_section.dart`):
- Update education, experience, skills, and services

**Contact Section** (`widgets/contact_section.dart`):
- Update email and social links

### 2. Add Your Profile Image

1. Create `assets/images/` folder
2. Add your `profile.jpg` image
3. Update `pubspec.yaml` if needed

### 3. Add Your CV

1. Add `CV.pdf` to `assets/` folder
2. Update the path in About section

### 4. Colors & Theme

Edit `main.dart` to change primary colors:
```dart
primaryColor: const Color(0xFF3B82F6),  // Blue
secondary: const Color(0xFF14B8A6),     // Teal
```

## 🌐 Web Deployment

### Deploy to Firebase Hosting

1. **Install Firebase CLI**
```bash
npm install -g firebase-tools
```

2. **Build for web**
```bash
flutter build web
```

3. **Initialize Firebase**
```bash
firebase init hosting
```

4. **Deploy**
```bash
firebase deploy
```

### Deploy to GitHub Pages

1. **Build for web**
```bash
flutter build web --base-href "/your-repo-name/"
```

2. **Copy build files**
```bash
cp -r build/web/* docs/
```

3. **Push to GitHub**
```bash
git add .
git commit -m "Deploy to GitHub Pages"
git push
```

4. **Enable GitHub Pages** in repository settings

### Deploy to Netlify

1. **Build for web**
```bash
flutter build web
```

2. **Drag & drop** the `build/web` folder to Netlify

Or use Netlify CLI:
```bash
netlify deploy --prod --dir=build/web
```

### Deploy to Vercel

1. **Install Vercel CLI**
```bash
npm i -g vercel
```

2. **Build for web**
```bash
flutter build web
```

3. **Deploy**
```bash
vercel --prod build/web
```

## 📱 Mobile Deployment

### Android

1. **Build APK**
```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

2. **Build App Bundle** (for Google Play)
```bash
flutter build appbundle
```

### iOS

1. **Open in Xcode**
```bash
open ios/Runner.xcworkspace
```

2. **Configure signing**
3. **Build for release**
```bash
flutter build ios --release
```

## 🎯 Performance Optimization

### Web Optimization

1. **Use CanvasKit for better graphics**
```bash
flutter build web --web-renderer canvaskit
```

2. **Use HTML renderer for lighter build**
```bash
flutter build web --web-renderer html
```

3. **Enable tree shaking**
```bash
flutter build web --tree-shake-icons
```

### Mobile Optimization

1. **Reduce app size**
```bash
flutter build apk --split-per-abi
```

2. **Enable obfuscation**
```bash
flutter build apk --obfuscate --split-debug-info=/<directory>
```

## 🐛 Troubleshooting

### Issue: Wave animation lagging

**Solution**: Reduce wave density in `waves_background.dart`:
```dart
xGap: 15.0,  // Increase from 10.0
yGap: 40.0,  // Increase from 32.0
```

### Issue: Profile image not showing

**Solution**: Check `pubspec.yaml` has:
```yaml
flutter:
  assets:
    - assets/images/
```

Run: `flutter pub get`

### Issue: Web build fails

**Solution**: 
```bash
flutter clean
flutter pub get
flutter build web
```

### Issue: Font issues on web

**Solution**: Add Google Fonts to web/index.html:
```html
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
```

## 📚 Dependencies Used

- `google_fonts` - Beautiful typography
- `animated_text_kit` - Text animations
- `flutter_staggered_animations` - Staggered list animations
- `animations` - Page transitions
- `provider` - State management
- `url_launcher` - Open URLs and emails
- `flutter_screenutil` - Responsive sizing
- `responsive_builder` - Responsive layouts
- `font_awesome_flutter` - Social icons

## 🔥 Animation Features

- ✅ Wave background with mouse interaction (web)
- ✅ Morphing profile border
- ✅ Gradient text effects
- ✅ Hover animations on cards
- ✅ Staggered list animations
- ✅ Smooth page transitions
- ✅ Button press animations
- ✅ Progress bar animations
- ✅ Fade in/out effects
- ✅ Scale transformations
- ✅ Slide animations

## 🎬 Next Steps

1. Add your profile image and CV
2. Customize all content
3. Test on different screen sizes
4. Build for your target platform
5. Deploy to your hosting service

## 📝 License

MIT License - Feel free to use this for your portfolio!

## 🤝 Support

If you need help:
1. Check Flutter documentation
2. Search GitHub issues
3. Ask on Stack Overflow with `flutter` tag

---

**Built with ❤️ using Flutter**# About_me
