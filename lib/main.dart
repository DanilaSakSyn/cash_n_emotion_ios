import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:drop_cost_ios/app/providers/theme_provider.dart';
import 'package:drop_cost_ios/app/providers/transaction_provider.dart';
import 'package:drop_cost_ios/core/services/sdk_initializer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'package:flutter/cupertino.dart';
import 'core/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initTrackingAppTransparency();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SdkInitializer.prefs = await SharedPreferences.getInstance();
  await SdkInitializer.loadRuntimeStorageToDevice();
  var isFirstStart = !SdkInitializer.hasValue("isFirstStart");
  var isOrganic = SdkInitializer.getValue("Organic");
  print('add af2 $isFirstStart $isOrganic');
  if (isFirstStart) SdkInitializer.initAppsFlyer();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
      ],
      child: const App(),
    ),
  );
}

Future<void> initTrackingAppTransparency() async {
  try {
    final TrackingStatus status =
        await AppTrackingTransparency.requestTrackingAuthorization();
    print('App Tracking Transparency status: $status');
    int timeout = 0;
    while (status == TrackingStatus.notDetermined && timeout < 10) {
      final TrackingStatus newStatus =
          await AppTrackingTransparency.requestTrackingAuthorization();
      await Future.delayed(const Duration(milliseconds: 200));
      timeout++;
    }
  } catch (e) {
    print('Error requesting App Tracking Transparency authorization: $e');
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
