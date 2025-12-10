import 'package:flutter/material.dart';
import 'screens/categories_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'services/meal_api_service.dart';
import 'screens/meal_detail_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> openRandomMealFromNotification() async {
  final apiService = MealApiService();

  try {
    final randomMeal = await apiService.getRandomMeal();

    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => MealDetailScreen(
          mealId: randomMeal.id,
        ),
      ),
    );
  } catch (e) {
    print('Error opening random meal from notification: $e');
  }
}

void _setupFCMListeners() {
  FirebaseMessaging.instance.getInitialMessage().then((message) {
    if (message != null) {
      _handleFCMMessage(message);
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    _handleFCMMessage(message);
  });
}

void _handleFCMMessage(RemoteMessage message) {
  final action = message.data['action'];
  print('FCM data: ${message.data}');

  if (action == 'open_random_meal') {
    openRandomMealFromNotification();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  final token = await FirebaseMessaging.instance.getToken();
  print('FCM token: $token');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFFFF7043), // nice warm orange
      brightness: Brightness.light,
    );

    return MaterialApp(
      title: 'Meal Recipes',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: const Color(0xFFF9FAFB),
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 2,
          centerTitle: true,
          titleTextStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        cardTheme: const CardThemeData(
          color: Colors.white,
          elevation: 3,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
          ),
        ),
      ),
      home: const CategoriesScreen(),
    );
  }
}
