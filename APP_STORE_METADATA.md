# App Store Metadata — Noura Bin Saidan Art Studio

> This file contains all metadata needed for App Store Connect submission.
> Copy these values into App Store Connect when uploading.

---

## App Information

| Field | Value |
|---|---|
| **Name** | Noura Bin Saidan |
| **Subtitle** | فنون وهوية ثقافية |
| **Bundle ID** | com.nourabinsaidan.studio |
| **SKU** | nourabinsaidan_studio_2026 |
| **Primary Language** | Arabic (اللغة الأساسية) |
| **Primary Category** | Lifestyle |
| **Secondary Category** | Entertainment |
| **Content Rights** | Does not contain third-party content *(see note)* |

---

## Description

### Arabic (Primary)
```
استكشف عالم الفنانة السعودية نورة بن سعيدان واستوديوها للفنون.

تطبيق "استوديو نورة بن سعيدان للفنون" يأخذك في رحلة بصرية عبر مسيرة أولى فنانات الجداريات السعوديات، من جداريات بوليفارد الرياض إلى التكريم الدولي بوسام الفنون والآداب الفرنسي.

المميزات:
• سيرة الفنانة ومسيرتها الفنية
• خط زمني تفاعلي لأهم المحطات
• الجوائز والإنجازات الموثّقة
• معرض الأعمال والجداريات
• منتجات وورش الاستوديو
• خدمات الحجز والتدريب
• آخر الأخبار والمقابلات
• روابط الحسابات الرسمية

يدعم التطبيق اللغتين العربية والإنجليزية بالكامل، مع الوضع النهاري والليلي، وتصميم فني مستوحى من الهوية السعودية المعاصرة.
```

### English
```
Explore the world of Saudi artist Noura Bin Saidan and her art studio.

The "Noura Bin Saidan Art Studio" app takes you on a visual journey through the career of one of Saudi Arabia's first female muralists — from the murals of Riyadh Boulevard to international recognition with the French Order of Arts and Letters.

Features:
• Artist biography and artistic journey
• Interactive timeline of key milestones
• Verified awards and achievements
• Gallery of artworks and murals
• Studio products and workshops
• Booking and training services
• Latest news and interviews
• Official social media links

The app fully supports Arabic and English, with day/night modes and an artistic design inspired by contemporary Saudi identity.
```

---

## Keywords

### Arabic
```
نورة بن سعيدان,فن,جداريات,غرافيتي,استوديو فنون,فنانة سعودية,ورش فنية,بوليفارد,الرياض,فن عام
```

### English
```
Noura Bin Saidan,art,murals,graffiti,art studio,Saudi artist,workshops,Riyadh,public art,Boulevard
```

---

## What's New (Release Notes)

### Arabic
```
الإصدار الأول 1.0
• تطبيق تعريفي وثقافي شامل للفنانة نورة بن سعيدان
• دعم كامل للعربية والإنجليزية
• الوضع النهاري والليلي
```

### English
```
Version 1.0 — Initial Release
• Comprehensive intro app for artist Noura Bin Saidan
• Full Arabic & English support
• Day and night modes
```

---

## App Privacy (App Store Connect → App Privacy)

| Data Type | Collected? | Purpose | Linked to User? |
|---|---|---|---|
| Name | Only if user sends via contact form | Customer Support | Yes |
| Email | Only if user sends via contact form | Customer Support | Yes |
| Location | **No** | — | — |
| Identifiers | **No** | — | — |
| Usage Data | **No** | — | — |
| Diagnostics | **No** | — | — |

**Privacy Policy URL:** *(Must be hosted publicly — e.g., GitHub Pages link)*

---

## Screenshots Needed

### Required sizes for App Store:
| Device | Size | Count |
|---|---|---|
| iPhone 6.7" (Pro Max) | 1290 × 2796 | 3-10 screenshots |
| iPhone 6.5" | 1242 × 2688 | 3-10 screenshots |
| iPad 12.9" (if iPad supported) | 2048 × 2732 | 3-10 screenshots |

**Recommended screenshots to capture:**
1. Home screen (with Al Arabiya mural)
2. About Noura (with portrait)
3. Awards (French medal + Tim Cook)
4. Gallery (artworks grid)
5. Products (with images)
6. Timeline
7. Studio (with location image)

---

## Age Rating

| Content | Answer |
|---|---|
| Cartoon Violence | None |
| Realistic Violence | None |
| Profanity | None |
| Horror | None |
| Medical Info | None |
| Alcohol/Tobacco | None |
| Gambling | None |
| Unrestricted Web Access | **Yes** *(links open browser)* |
| Gambling with contests | No |

**Resulting Rating:** 4+

---

## ⚠️ Pre-Submission Checklist

- [ ] **Image rights:** Replace press-sourced images with officially licensed ones, OR obtain written permission from Noura Bin Saidan Studio to use press images in the app.
- [ ] **Privacy Policy:** Host PRIVACY_POLICY.md on a public URL (e.g., GitHub Pages: `https://nmk-ai.github.io/NouraBinSaidanArtStudio/privacy-policy`)
- [ ] **Screenshots:** Capture App Store-sized screenshots
- [ ] **App Review Notes:** Mention "Content provided by and used with permission of Noura Bin Saidan Studio"
- [ ] **Bundle ID registered:** Ensure `com.nourabinsaidan.studio` is registered in your Apple Developer portal
- [ ] **Archive built** with Distribution certificate (not Development)
- [ ] **App Store Connect record** created for this bundle ID

---

## Build & Upload Steps (for the developer)

```bash
# 1. Set your team in project.yml
#    Replace DEVELOPMENT_TEAM: "" with your Team ID

# 2. Regenerate project
cd NouraBinSaidanArtStudio
xcodegen generate

# 3. Archive (creates .xcarchive)
xcodebuild archive \
  -project NouraBinSaidanArtStudio.xcodeproj \
  -scheme NouraBinSaidanArtStudio \
  -archivePath build/NouraBinSaidanArtStudio.xcarchive \
  -destination "generic/platform=iOS" \
  -allowProvisioningUpdates

# 4. Export IPA for App Store
xcodebuild -exportArchive \
  -archivePath build/NouraBinSaidanArtStudio.xcarchive \
  -exportPath build/ipa \
  -exportOptionsPlist ExportOptions.plist \
  -allowProvisioningUpdates

# 5. Upload to App Store Connect via Xcode Organizer
#    Open Xcode → Window → Organizer → Distribute App → App Store Connect
```
