
# Firebase Analytics Module for Flutter

A clean and extensible Firebase Analytics module built for Flutter apps using dependency injection and event abstraction. This package helps you track user behavior, screen views, and custom events in a scalable and testable way.

---

## ✨ Features

- ✅ Clean architecture (models, services, helpers, extensions)
- ✅ Easy-to-use event extensions
- ✅ No analytics logic in the UI
- ✅ Automatic user context injection (ID, email, role…)
- ✅ Custom and screen view event abstraction
- ✅ Dependency Injection ready (via `getIt`)
- ✅ Error-safe logging using Crashlytics
- ✅ Lightweight and easily customizable
- ✅ Type-safe parameter handling
- ✅ Easy to extend for any custom use case
- ℹ️ Note: Crashlytics and GetIt are optional. You can replace them with any other error logger or DI framework.


---

## 📦 Installation

In your `pubspec.yaml`:

```yaml
dependencies:
  firebase_core: ^3.13.0
  firebase_analytics: ^11.5.0
````

---

## 🔧 Setup

### 1. Initialize Firebase

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupDependencies(); // Register your dependencies (or use your own DI method)
  runApp(MyApp());
}
```

---

### 2. Dependency Injection (GetIt)

```dart
final getIt = GetIt.instance;

void setupDependencies() {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  getIt.registerSingleton<PrefManager>(PrefManager(sharedPreferences));
  getIt.registerSingleton<FirebaseCrashlytics>(FirebaseCrashlytics.instance);
  getIt.registerLazySingleton<AnalyticsHelper>(AnalyticsHelper.new);
  getIt.registerLazySingleton<IAnalyticsService>(FirebaseAnalyticsService.new);
}
```

---

### 3. Use Navigator Observer

```dart
MaterialApp(
  navigatorObservers: [
    NavigationService.routeObserver,
    (getIt<IAnalyticsService>() as FirebaseAnalyticsService).observer,
  ],
  home: MyHomePage(),
);
```

---

## 🚀 Usage Examples

### Log a login event:

```dart
await getIt<IAnalyticsService>().logLogin(method: 'social_login');
```

---

### Log a custom event:

```dart
await getIt<IAnalyticsService>().logUpdateProfile(parameters: {
  'field_changed': 'username',
});
```

---

### Log a screen view manually:

```dart
await getIt<IAnalyticsService>().radarAROpenView(
  screenClass: 'RadarScreen',
  parameters: {'source': 'dashboard'},
);
```

---

### Set user context manually:

```dart
await getIt<IAnalyticsService>().setUserContext(UserContext(
  userId: 'user_123',
  userName: 'Sayed Moataz',
  userEmail: 'sayedmoataz9@gmail.com',
  userPhone: '+201147880178',
  userRole: 'admin',
));
```

## 📁 Project Structure

```
lib/
├── services 
│   └── analytics/
│       ├── analytics_helper.dart
│       ├── analytics_services.dart
│       └── analytics_extensions.dart
├── models/
│   └── user_context.dart
├── di.dart
└── main.dart
```

---

## 🛠️ Extend the Module

You can add more events in the `AnalyticsServiceExtensions`:

```dart
extension AnalyticsServiceExtensions on IAnalyticsService {
  Future<void> logPurchase({required double amount}) async {
    final helper = getIt<AnalyticsHelper>();
    await logEvent(
      helper.createCustomEvent(
        eventName: 'purchase_made',
        parameters: {'amount': amount},
      ),
    );
  }
}
```

---
## 🧩 Customization Notes

This module is designed to be flexible and easy to adapt to your project:

- **Crashlytics Logging**  
  The `CrashlyticsLogger.logMessage(...)` calls are project-specific.  
  You can:
  - Replace them with your own logger
  - Remove them entirely

- **Dependency Injection**  
  Although `getIt` is used here for DI, you're free to:
  - Use any other DI solution (like Riverpod, Provider, injectable, etc.)
  - Inject dependencies manually based on your app architecture

These components are decoupled from the core logic to allow maximum flexibility.

