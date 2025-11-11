import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/theme_provider.dart';
import '../constants/app_colors.dart';
import 'onboarding_screen.dart';

// App Constants
class AppConstants {
  static const String appVersion = '1.0';
  static const String buildNumber = '1';
  static const String developerName = 'Sai Ho YU';
  static const String developerEmail = 'uvufizeci03@gmail.com';
  static const String privacyPolicyUrl =
      'https://cashnemotion.com/privacy-policy.html';
  static const String appDescription =
      'Track your transactions with emotions and gain insights into your financial behavior.';
}

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $urlString');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          'Settings',
          style: TextStyle(
            color: isDark ? AppColors.lightCard : AppColors.lightText1,
          ),
        ),
        backgroundColor: AppColors.getNavBarColor(isDark),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.getBackgroundGradient(isDark),
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: ListView(
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [const Color(0xFF9C27B0), const Color(0xFF7B2CBF)]
                          : [AppColors.lightGradient1, AppColors.lightPrimary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? const Color(0xFF9C27B0).withOpacity(0.4)
                            : AppColors.lightShadow,
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Icon(
                    isDark
                        ? CupertinoIcons.moon_stars
                        : CupertinoIcons.sun_max_fill,
                    size: 40,
                    color: AppColors.lightCard,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'App Settings',
                  style: TextStyle(
                    fontSize: 16,
                    color:
                        isDark ? const Color(0xFFE1BEE7) : AppColors.lightText1,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Theme Section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF2A1A4A), const Color(0xFF3A2A5A)]
                        : [AppColors.lightCard, AppColors.lightCardBg],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? const Color(0xFF9C27B0).withOpacity(0.2)
                          : AppColors.lightShadow,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Theme Header
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: isDark
                                    ? [
                                        const Color(0xFF9C27B0),
                                        const Color(0xFF7B2CBF),
                                      ]
                                    : [
                                        AppColors.lightGradient1,
                                        AppColors.lightPrimary,
                                      ],
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              CupertinoIcons.paintbrush,
                              color: AppColors.lightCard,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Theme',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? const Color(0xFFE1BEE7)
                                  : AppColors.lightText1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Divider
                    Container(
                      height: 1,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            isDark
                                ? const Color(0xFF9C27B0).withOpacity(0.3)
                                : const Color(0xFFD4C5E0),
                            isDark
                                ? const Color(0xFF7B2CBF).withOpacity(0.3)
                                : const Color(0xFFC5B3D9),
                          ],
                        ),
                      ),
                    ),
                    // Light Theme Option
                    GestureDetector(
                      onTap: () => themeProvider.setTheme(false),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        color: CupertinoColors.transparent,
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.sun_max,
                              color: isDark
                                  ? const Color(0xFFE1BEE7)
                                  : AppColors.lightPrimary,
                              size: 24,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                'Light Mode',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: isDark
                                      ? const Color(0xFFE1BEE7)
                                      : AppColors.lightText1,
                                ),
                              ),
                            ),
                            if (!isDark)
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.lightGradient1,
                                      AppColors.lightPrimary,
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  CupertinoIcons.check_mark,
                                  color: AppColors.lightCard,
                                  size: 16,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    // Dark Theme Option
                    GestureDetector(
                      onTap: () => themeProvider.setTheme(true),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        color: CupertinoColors.transparent,
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.moon,
                              color: isDark
                                  ? const Color(0xFFE1BEE7)
                                  : AppColors.lightPrimary,
                              size: 24,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                'Dark Mode',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: isDark
                                      ? const Color(0xFFE1BEE7)
                                      : AppColors.lightText1,
                                ),
                              ),
                            ),
                            if (isDark)
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF9C27B0),
                                      Color(0xFF7B2CBF),
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  CupertinoIcons.check_mark,
                                  color: AppColors.lightCard,
                                  size: 16,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Help & Tutorial Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Help & Support',
                  style: TextStyle(
                    fontSize: 16,
                    color:
                        isDark ? const Color(0xFFE1BEE7) : AppColors.lightText1,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF2A1A4A), const Color(0xFF3A2A5A)]
                        : [AppColors.lightCard, AppColors.lightCardBg],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? const Color(0xFF9C27B0).withOpacity(0.2)
                          : AppColors.lightShadow,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CupertinoButton(
                  padding: const EdgeInsets.all(16),
                  onPressed: () {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (context) => const OnboardingScreen(),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.book_circle,
                        color: isDark
                            ? const Color(0xFFE1BEE7)
                            : AppColors.lightPrimary,
                        size: 24,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'View Tutorial',
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark
                                ? const Color(0xFFE1BEE7)
                                : AppColors.lightText1,
                          ),
                        ),
                      ),
                      Icon(
                        CupertinoIcons.chevron_right,
                        color: isDark
                            ? const Color(0xFFCE93D8)
                            : AppColors.lightPrimary,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Privacy & Legal Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Privacy & Legal',
                  style: TextStyle(
                    fontSize: 16,
                    color:
                        isDark ? const Color(0xFFE1BEE7) : AppColors.lightText1,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF2A1A4A), const Color(0xFF3A2A5A)]
                        : [AppColors.lightCard, AppColors.lightCardBg],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? const Color(0xFF9C27B0).withOpacity(0.2)
                          : AppColors.lightShadow,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CupertinoButton(
                  padding: const EdgeInsets.all(16),
                  onPressed: () => _launchUrl(AppConstants.privacyPolicyUrl),
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.doc_text,
                        color: isDark
                            ? const Color(0xFFE1BEE7)
                            : AppColors.lightPrimary,
                        size: 24,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Privacy Policy',
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark
                                ? const Color(0xFFE1BEE7)
                                : AppColors.lightText1,
                          ),
                        ),
                      ),
                      Icon(
                        CupertinoIcons.chevron_right,
                        color: isDark
                            ? const Color(0xFFCE93D8)
                            : AppColors.lightPrimary,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // About Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'About',
                  style: TextStyle(
                    fontSize: 16,
                    color:
                        isDark ? const Color(0xFFE1BEE7) : AppColors.lightText1,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF2A1A4A), const Color(0xFF3A2A5A)]
                        : [AppColors.lightCard, AppColors.lightCardBg],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? const Color(0xFF9C27B0).withOpacity(0.2)
                          : AppColors.lightShadow,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // App Info
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isDark
                                  ? [
                                      const Color(0xFF9C27B0),
                                      const Color(0xFF7B2CBF),
                                    ]
                                  : [
                                      AppColors.lightGradient1,
                                      AppColors.lightPrimary,
                                    ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            CupertinoIcons.money_dollar_circle,
                            color: AppColors.lightCard,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Cash N Emotion',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? const Color(0xFFE1BEE7)
                                      : AppColors.lightText1,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Version ${AppConstants.appVersion} (${AppConstants.buildNumber})',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDark
                                      ? const Color(0xFFCE93D8)
                                      : AppColors.lightPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            isDark
                                ? const Color(0xFF9C27B0).withOpacity(0.3)
                                : const Color(0xFFD4C5E0),
                            isDark
                                ? const Color(0xFF7B2CBF).withOpacity(0.3)
                                : const Color(0xFFC5B3D9),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Description
                    Text(
                      AppConstants.appDescription,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: isDark
                            ? const Color(0xFFCE93D8)
                            : AppColors.lightPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            isDark
                                ? const Color(0xFF9C27B0).withOpacity(0.3)
                                : const Color(0xFFD4C5E0),
                            isDark
                                ? const Color(0xFF7B2CBF).withOpacity(0.3)
                                : const Color(0xFFC5B3D9),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Developer Info
                    Row(
                      children: [
                        Icon(
                          CupertinoIcons.person_2,
                          color: isDark
                              ? const Color(0xFFE1BEE7)
                              : AppColors.lightPrimary,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Developed by',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? const Color(0xFFCE93D8)
                                      : AppColors.lightPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                AppConstants.developerName,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? const Color(0xFFE1BEE7)
                                      : AppColors.lightText1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          CupertinoIcons.mail,
                          color: isDark
                              ? const Color(0xFFE1BEE7)
                              : AppColors.lightPrimary,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Contact',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? const Color(0xFFCE93D8)
                                      : AppColors.lightPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                AppConstants.developerEmail,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? const Color(0xFFE1BEE7)
                                      : AppColors.lightText1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Preview Icon
            ],
          ),
        ),
      ),
    );
  }
}
