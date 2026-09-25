import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takroom/providers/user_provider.dart';
import 'package:takroom/theme/app_theme.dart';
import 'package:takroom/views/splash_screen_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'LazyRoom',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: SplashScreen(),
      ),
    );
  }
}
