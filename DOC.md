FIX BUILD
$env:PUB_CACHE="D:\FlutterCache\.pub-cache"
flutter clean
flutter pub get
flutter build apk --release
