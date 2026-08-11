import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:provider/provider.dart';
import 'package:bookbank/Widgets/navigation_bar.dart';
import 'package:bookbank/core/theme/app_theme.dart';
import 'package:bookbank/features/menu/editGroup/providers/group_settings_provider.dart';
import 'package:bookbank/features/notebook/providers/note_provider.dart';
import 'package:bookbank/core/localization/localization_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => GroupSettingsProvider()),
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ChangeNotifierProvider(create: (_) => NoteProvider()),
            ChangeNotifierProvider(create: (_) => LocalizationProvider()),
          ],
          child: Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeProvider.isDarkMode
                    ? ThemeMode.dark
                    : ThemeMode.light,
                home: const HomePage(),
                builder: (context, widget) {
                  return ResponsiveBreakpoints.builder(
                    breakpoints: const [
                      Breakpoint(start: 0, end: 450, name: MOBILE),
                      Breakpoint(start: 451, end: 800, name: TABLET),
                      Breakpoint(start: 801, end: 1920, name: DESKTOP),
                      Breakpoint(start: 1921, end: double.infinity, name: '4K'),
                    ],
                    child: widget!,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
