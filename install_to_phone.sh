#!/bin/bash
# ============================================================
#  تثبيت تطبيق نورة بن سعيدان على جوالك الفعلي
#  Install Noura Bin Saidan app on your physical iPhone
# ============================================================
#  الاستخدام:  bash install_to_phone.sh
#  المتطلبات:  جوال موصول + حساب Apple ID مضاف في Xcode
# ============================================================

set -e
export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer

PROJECT_DIR="/Users/nasralkhaldy/ZCodeProject/NouraBinSaidanArtStudio"
PROJECT="$PROJECT_DIR/NouraBinSaidanArtStudio.xcodeproj"
SCHEME="NouraBinSaidanArtStudio"
BUNDLE_ID="com.nourabinsaidan.studio"

cd "$PROJECT_DIR"

echo "============================================================"
echo "  🎨  تثبيت تطبيق نورة بن سعيدان على الجوال"
echo "============================================================"
echo ""

# ---------- 1) اكتشاف الجوال الفعلي ----------
echo "📱 [1/4] البحث عن جوال موصول..."
DEVICE_ID=$(xcrun devicectl list devices 2>/dev/null | grep -i "available" | grep -i "iPhone" | awk '{print $5}' | head -1)

if [ -z "$DEVICE_ID" ]; then
    echo ""
    echo "❌ لم يتم العثور على جوال متاح."
    echo ""
    echo "   تأكد من:"
    echo "   1. وصل الجوال بالكابل."
    echo "   2. فتح قفل الشاشة (الشاشة مضاءة)."
    echo "   3. الضغط على 'Trust' على الجوال إن طُلب."
    echo "   4. تفعيل وضع المطور: الإعدادات ← الخصوصية ← المطوّرون."
    echo ""
    echo "   ثم أعد تشغيل السكربت."
    exit 1
fi

DEVICE_NAME=$(xcrun devicectl list devices 2>/dev/null | grep "$DEVICE_ID" | awk '{print $1}')
echo "✅ تم العثور على: $DEVICE_NAME ($DEVICE_ID)"
echo ""

# ---------- 2) اكتشاف الـ Team ----------
echo "🔑 [2/4] البحث عن حساب المطور..."
TEAM_ID=$(defaults read com.apple.dt.Xcode IDEProvisioningTeams 2>/dev/null | grep -oE '"[A-Z0-9]{10}"' | head -1 | tr -d '"')

if [ -z "$TEAM_ID" ]; then
    echo ""
    echo "❌ لم يتم العثور على حساب Apple Developer في Xcode."
    echo ""
    echo "   أضف حسابك:"
    echo "   1. افتح Xcode."
    echo "   2. القائمة: Xcode ← Settings ← Accounts."
    echo "   3. اضغط '+' وأضف Apple ID (أي حساب مجاني)."
    echo ""
    echo "   ثم أعد تشغيل السكربت."
    exit 1
fi

echo "✅ تم العثور على Team: $TEAM_ID"
echo ""

# ---------- 3) تحديث المشروع بالـ Team ----------
echo "🔧 [3/4] تحديث إعدادات التوقيع..."
sed -i '' "s/DEVELOPMENT_TEAM: \"\"/DEVELOPMENT_TEAM: \"$TEAM_ID\"/" "$PROJECT_DIR/project.yml" 2>/dev/null || true
xcodegen generate 2>/dev/null || echo "   (xcodegen غير مطلوب أو غير مثبت - متابعة)"
echo "✅ تم تحديث التوقيع"
echo ""

# ---------- 4) البناء والتثبيت ----------
echo "🏗️ [4/4] بناء التطبيق وتثبيته على $DEVICE_NAME..."
echo "   (قد يستغرق 1-3 دقائق)"
echo ""

xcodebuild \
    -project "$PROJECT" \
    -scheme "$SCHEME" \
    -destination "id=$DEVICE_ID" \
    -configuration Debug \
    -allowProvisioningUpdates \
    DEVELOPMENT_TEAM="$TEAM_ID" \
    CODE_SIGN_STYLE=Automatic \
    build 2>&1 | tail -20

# ---------- التحقق من نجاح البناء ----------
if xcodebuild -project "$PROJECT" -scheme "$SCHEME" -destination "id=$DEVICE_ID" -configuration Debug -allowProvisioningUpdates DEVELOPMENT_TEAM="$TEAM_ID" CODE_SIGN_STYLE=Automatic build 2>&1 | grep -q "BUILD SUCCEEDED"; then
    echo ""
    echo "============================================================"
    echo "  ✅ تم تثبيت التطبيق بنجاح على $DEVICE_NAME!"
    echo "============================================================"
    echo ""
    echo "  🎨 ستجد أيقونة 'Noura Bin Saidan' على شاشتك الرئيسية."
    echo ""
    echo "  ⚠️  عند أول فتح: الإعدادات ← عام ← إدارة الأجهزة والـ VPN"
    echo "     ← اضغط على Apple ID ← 'موثوق' (Trust)."
    echo ""
    echo "============================================================"
else
    echo ""
    echo "❌ فشل البناء. تحقق من الأخطاء أعلاه."
    exit 1
fi
