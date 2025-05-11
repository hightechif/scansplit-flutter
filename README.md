# ScanSplit - Smart Bill Splitting App

![ScanSplit App Preview](assets/images/app_preview.png)

Effortlessly split bills with friends using AI-powered receipt scanning. Capture, analyze, and divide expenses in seconds.

---

## ✨ Key Features

- 🧾 **Smart Receipt Scanning**: AI extracts items, prices, and totals automatically
- 👥 **Group Management**: Create permanent or temporary expense groups
- ⚖️ **Custom Splits**: Assign items unevenly with drag-and-drop interface
- 💸 **Balance Tracking**: Real-time debt calculations with settlement suggestions
- 🔄 **Sync Across Devices**: Changes update instantly for all group members
- 🔒 **Privacy Focused**: Your receipt data never leaves your device

---

## 🛠️ Tech Stack

| Component | Technology |
|-----------|------------|
| Frontend | Flutter 3.13 |
| Backend | Golang 1.21 |
| OCR Engine | Google ML Kit (On-Device) |
| Database | PostgreSQL 15 |
| Authentication | Firebase Auth |
| File Storage | Google Cloud Storage |

---

## 🧩 Key Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| google_mlkit_text_recognition | ^0.13.0 | On-device OCR processing |
| riverpod | ^2.4.9 | State management |
| camera | ^0.10.5 | Receipt image capture |
| go_router | ^12.0.1 | Navigation routing |
| hive | ^2.2.3 | Local caching |

---

## 🚀 Development Setup

```bash
# 1. Clone repository
git clone https://github.com/yourusername/scansplit.git
cd scansplit

# 2. Install dependencies
flutter pub get

# 3. Setup environment variables
cp .env.example .env
# Edit with your API keys

# 4. Run development server
flutter run -d chrome
```

---

## 🏗️ Project Architecture

```text
lib/
├── core/               # Framework configurations
│   ├── constants/      # App-wide constants
│   ├── theme/          # UI theming
│   └── utilities/      # Helper functions
│
├── data/               # Data layer
│   ├── models/         # Data classes
│   ├── repositories/   # Business logic
│   └── datasources/    # API clients
│
├── features/           # Feature modules
│   ├── auth/           # Authentication
│   ├── dashboard/      # Main app screen  
│   ├── receipt/        # Receipt processing
│   └── splits/         # Bill splitting
│
└── widgets/            # Reusable components
    ├── receipt_card.dart
    └── split_selector.dart
```

---

## 🧪 Testing Matrix

| Test Type | Coverage | Location |
|-----------|----------|----------|
| Unit Tests | 85% | test/unit/ |
| Widget Tests | 100% | test/widget/ | 
| Integration | Core Flows | test/integration/ |

Run all tests:
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/
open coverage/index.html
```

---

## 🏗️ Build & Deployment

### Android
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ipa --export-method development
```

---

## 🔄 CI/CD Pipeline

```yaml
name: ScanSplit CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test

  build-android:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - run: flutter build appbundle --release
      - uses: actions/upload-artifact@v3
        with:
          name: app-bundle
          path: build/app/outputs/bundle/release/app-release.aab
```

---

## 📜 License

```text
MIT License
Copyright (c) 2025 Ridhan Fadhilah

Permission is hereby granted... [standard MIT terms]
```

Full license text available at [LICENSE.md](LICENSE.md)

---

## 📧 Contact

For support or security issues:  
**Email**: ridhanfadhilah@gmail.com