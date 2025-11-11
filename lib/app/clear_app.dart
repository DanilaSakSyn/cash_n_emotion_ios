import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'screens/main_screen.dart';

class ClearApp extends StatelessWidget {
  const ClearApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return CupertinoApp(
          debugShowCheckedModeBanner: false,
          title: 'Cash N Emotion',
          theme: themeProvider.currentTheme,
          home: const MainScreen(),
        );
      },
    );
  }
}
