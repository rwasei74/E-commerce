# e-coomerce

أساس متجر Flutter بشاشة عربية متجاوبة وMaterial 3.

## التشغيل

```sh
flutter pub get
flutter run -d chrome
```

للهاتف: flutter devices ثم flutter run -d DEVICE_ID.
ملفات Android وiOS والويب جاهزة. بناء iOS يتطلب macOS وXcode.

## البنية

- lib/main.dart: نقطة التشغيل.
- lib/app/app.dart: إعداد التطبيق.
- lib/core/theme/app_theme.dart: المظهر.
- lib/features/home/presentation/home_screen.dart: الشاشة الرئيسية.

الكتالوج فارغ حتى ربط المنتجات. لا يوجد خادم أو تسجيل دخول أو سلة أو دفع في هذا الأساس.

## التحقق

```sh
flutter analyze
flutter build web
```
