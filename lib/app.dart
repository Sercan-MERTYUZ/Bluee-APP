import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'features/home/presentation/pages/home_page.dart';

class RemindersApp extends StatelessWidget {
  const RemindersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reminder',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0B10),
        // ignore: prefer_const_constructors
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF7C3AED),
          secondary: const Color(0xFFA78BFA),
          surface: const Color(0xFF1A1A25),
          error: const Color(0xFFEF4444),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF12121A).withValues(alpha: 0.8),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: const TextStyle(
            color: Color(0xFFEDEDF3),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: const IconThemeData(color: Color(0xFFEDEDF3)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1A1A25),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2D2D3A), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2D2D3A), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 2),
          ),
          hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 16),
          labelStyle: const TextStyle(color: Color(0xFF9CA3AF)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: const Color(0xFF7C3AED),
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7C3AED),
            foregroundColor: const Color(0xFFEDEDF3),
            elevation: 4,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF7C3AED),
            side: const BorderSide(color: Color(0xFF7C3AED), width: 1.5),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const Color(0xFF7C3AED);
            }
            return const Color(0xFF2D2D3A);
          }),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: Color(0xFFEDEDF3), fontWeight: FontWeight.bold),
          displayMedium: TextStyle(color: Color(0xFFEDEDF3), fontWeight: FontWeight.bold),
          titleLarge: TextStyle(color: Color(0xFFEDEDF3), fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(color: Color(0xFFEDEDF3), fontSize: 16),
          bodyMedium: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
          bodySmall: TextStyle(color: Color(0xFF6B7280), fontSize: 12),
        ),
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: const HomePage(),
    );
  }
}
