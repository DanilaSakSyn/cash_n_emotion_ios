import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../constants/app_colors.dart';
import '../services/storage_service.dart';
import 'dashboard_tab.dart';
import 'transactions_tab.dart';
import 'statistics_tab.dart';
import 'settings_tab.dart';
import 'onboarding_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    final storageService = StorageService();
    final isFirstLaunch = await storageService.isFirstLaunch();

    if (isFirstLaunch && mounted) {
      // Wait a bit for the screen to build
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        await showCupertinoModalPopup(
          context: context,
          barrierDismissible: false,
          builder: (context) => const OnboardingScreen(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: AppColors.getNavBarColor(isDark),
        activeColor: CupertinoColors.white,
        inactiveColor: isDark ? AppColors.darkText2 : const Color(0xFFE1BEE7),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.square_grid_2x2),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.list_bullet),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chart_bar),
            label: 'Statistics',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: 'Settings',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return const DashboardTab();
          case 1:
            return const TransactionsTab();
          case 2:
            return const StatisticsTab();
          case 3:
            return const SettingsTab();
          default:
            return const DashboardTab();
        }
      },
    );
  }
}
