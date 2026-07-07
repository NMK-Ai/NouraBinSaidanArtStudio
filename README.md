# Noura Bin Saidan Art Studio — iOS App

تطبيق تعريفي وثقافي وتجاري احترافي للفنانة السعودية **نورة بن سعيدان** واستوديوها للفنون، مبني بـ **SwiftUI** ومعمارية **MVVM**.

A premium, art-forward iOS app for Saudi artist **Noura Bin Saidan** and her art studio, built with **SwiftUI** and **MVVM**.

---

## ✨ الميزات (Features)

- **SwiftUI** + **iOS 17+** + **MVVM** architecture.
- دعم كامل للعربية والإنجليزية مع **RTL** تبديل لحظي بدون إعادة تشغيل.
- **Dark Mode** كامل (الألوان تتكيّف تلقائياً).
- محتوى مفصول عن الواجهة عبر **ملفات JSON محلية** قابلة للربط بـ API لاحقاً.
- تصميم بصري **Premium** مستوحى من الجداريات النجدية والطين والذهب والهوية السعودية المعاصرة.
- صور الأعمال **توليدية مكانية (Generative)** لتجنّب أي انتهاك لحقوق الصور.
- كل معلومة **موثّقة بمصدر** قابل للنقر داخل التطبيق.

---

## 📁 هيكلة المشروع (Project Structure)

```
NouraBinSaidanArtStudio/
├── NouraBinSaidanArtStudio.xcodeproj   # مشروع Xcode (مُولّد بـ xcodegen)
├── project.yml                          # تعريف المشروع لـ xcodegen
├── RESEARCH.md                          # بحث + مصادر + قائمة بحاجة تحقق
├── README.md                            # هذا الملف
├── NEEDS_REVIEW.md                      # قائمة الأشياء التي تحتاج مراجعة من الفنانة/فريقها
└── NouraBinSaidanArtStudio/
    ├── NouraBinSaidanApp.swift          # نقطة الدخول (@main)
    ├── Models/
    │   └── NouraModels.swift            # Codable structs لكل الـ JSON
    ├── ViewModels/
    │   └── ViewModels.swift             # ContentViewModel (MVVM)
    ├── Services/
    │   └── DataService.swift            # JSON loader + Localization + LinkOpener
    ├── Theme/
    │   └── Theme.swift                  # Palette + AppTheme + مُعدِّلات
    ├── Views/
    │   ├── RootView.swift               # TabView + NavigationStack + Routing + More menu
    │   ├── SplashView.swift             # شاشة البداية بحركة فنية
    │   ├── HomeView.swift               # الرئيسية
    │   ├── AboutView.swift              # عن نورة
    │   ├── TimelineView.swift           # الخط الزمني
    │   ├── AwardsView.swift             # الجوائز والإنجازات
    │   ├── GalleryView.swift            # معرض الأعمال + التفاصيل
    │   ├── StudioView.swift             # الاستوديو
    │   ├── ProductsView.swift           # المتجر
    │   ├── ServicesView.swift           # الخدمات والورش
    │   ├── NewsMediaView.swift          # الأخبار والإعلام
    │   ├── ContactView.swift            # التواصل + الحسابات + النموذج
    │   └── SharedComponents.swift       # مكوّنات مشتركة
    ├── Resources/
    │   ├── Assets.xcassets              # AppIcon + AccentColor
    │   ├── ar.lproj/Localizable.strings  # ترجمة عربية
    │   └── en.lproj/Localizable.strings  # ترجمة إنجليزية
    └── Data/                            # ← ملفات JSON (8 ملفات)
        ├── noura_profile.json
        ├── timeline.json
        ├── awards.json
        ├── artworks.json
        ├── products.json
        ├── services.json
        ├── social_links.json
        └── sources.json
```

---

## 🚀 التشغيل (How to Run)

### المتطلبات (Requirements)
- macOS مع **Xcode 26.x** (أو Xcode 16+).
- iOS **17.0+** كـ deployment target.
- `brew install xcodegen` (لإعادة توليد المشروع عند التعديل على البنية).

### خطوات التشغيل (Steps)

**الطريقة 1 — عبر Xcode GUI:**
```bash
open NouraBinSaidanArtStudio.xcodeproj
```
ثم اختر iPhone simulator واضغط ▶︎ Run.

**الطريقة 2 — عبر سطر الأوامر:**
```bash
export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer

# بناء
xcodebuild \
  -project NouraBinSaidanArtStudio.xcodeproj \
  -scheme NouraBinSaidanArtStudio \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro Max' \
  -configuration Debug \
  build CODE_SIGNING_ALLOWED=NO

# تثبيت وتشغيل على simulator مُشغّل
xcrun simctl install booted <path-to-built>.app
xcrun simctl launch booted com.nourabinsaidan.studio
```

> ملاحظة: إذا كان `xcode-select` يشير إلى CommandLineTools، استخدم
> `export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer` بدل `sudo xcode-select -s`.

### إعادة توليد المشروع (Regenerate after structural changes)
إذا أضفت/حذفت ملفات Swift أو JSON على مستوى المجلدات:
```bash
cd NouraBinSaidanArtStudio
xcodegen generate
```

---

## 🎨 لوحة الألوان (Color Palette)

| اللون | Hex | الاستخدام |
|---|---|---|
| Bourbon | `#7A4332` | أساسي — جدران الطين |
| Terracotta | `#C46A4A` | أساسي ثانوي |
| Gold (Saffron) | `#D4A24E` | لمسات ذهبية / CTA |
| Olive | `#6B7142` | تأكيد موثوقية |
| Sage | `#9CA88E` | مساعد |
| Cocoa | `#4A3B31` | خلفيات داكنة |
| Indigo | `#3B4A6B` | تنويع |

---

## 🧱 البنية التقنية (Technical Notes)

- **MVVM**: `ContentViewModel` (@MainActor ObservableObject) يحمّل كل البيانات مرة واحدة ويُمرَّر عبر `@EnvironmentObject`.
- **Data Layer**: `DataService.shared` يقرأ JSON من الـ bundle مع caching آمن خيطياً (concurrent queue + barrier).
- **Localization**: `LocalizationManager` يحفظ اللغة في `@AppStorage` ويُطبّق RTL عبر `\.layoutDirection` و `\.locale` في الـ environment.
- **Routing**: `NavigationStack` + `navigationDestination(for: AppRoute.self)` لتنقّل آمن ومُنتظم.
- **قابلية التوسّع**: استبدال `DataService` بطبقة API لاحقاً لا يتطلب تغيير الـ ViewModels/Views لأن البنية معتمدة على الـ Models.

### للربط بـ API لاحقاً
استبدل أجسام الـ `decode` في `DataService` بنداءات `URLSession` تعيد نفس الـ `Codable` types — الـ UI لا يتغيّر.

---

## 🔍 منهجية التحقق (Verification Methodology)

راجع ملف [`RESEARCH.md`](./RESEARCH.md) للحصول على:
- كل معلومة مع مصدرها الرسمي.
- جدول زمني موثّق.
- قائمة الجوائز مع روابط الإثبات.
- قائمة المنتجات والأسعار.
- قائمة الحسابات الرسمية.
- **قائمة «بحاجة تحقق»** — معلومات لم تُتحقق وتُرسل للفنانة/فريقها.

### النقاط الحرجة المؤكّدة بمصادر رسمية:
1. **وسام الفنون والآداب الفرنسي برتبة فارس** — وكالة الأنباء السعودية (SPA)، الشرق الأوسط، مؤسسة الدرعية البينالية، وتغريدة السفير الفرنسي.
2. **لقاء تيم كوك (Apple CEO)** — تغريدة Tim Cook الرسمية (9 ديسمبر 2024) + مقال ITP.net + حساب الفنانة.

---

## ⚠️ حقوق الصور (Image Rights)

التطبيق **لا يستخدم أي صورة فوتوغرافية** لأعمال الفنانة. بدلاً من ذلك، عناصر `MuralPlaceholder` تولّد **فناً أصلياً بالكود** (Canvas/SwiftUI Shapes) مستوحى من الزهرة النجدية والأقواس، بلوحة الألوان الرسمية. هذا يحترم حقوق الصور بالكامل. عند توفر تراخيص صور رسمية، تُستبدل الـ placeholders بسهولة في `MuralPlaceholder`.

---

## 📋 المهام المتبقية (Roadmap / Expandable)

- [ ] ربط المتجر بـ API رسمي عند توفّره (حالياً روابط خارجية لـ nsartstore.com).
- [ ] نظام حجوزات ورش داخلي عند توفّر API (حالياً رابط WhatsApp).
- [ ] إضافة صور الأعمال الرسمية بعد تأمين حقوقها.
- [ ] إشعارات للورش والفعاليات الجديدة.
- [ ] دعم iPad (حالياً iPhone).

---

## 📜 الترخيص والإسناد (License)

هذا المشروع قالب تطبيقي للفنانة نورة بن سعيدان. المحتوى التوثيقي مأخوذ من مصادر عامة موثّقة في `RESEARCH.md`. الكود البرمجي والتصميم البصري التوليدي أصلي وعمل فريق التطوير.

© Noura Bin Saidan Art Studio — App MVP.
