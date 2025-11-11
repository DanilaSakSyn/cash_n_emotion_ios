import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../constants/app_colors.dart';
import '../services/storage_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      icon: CupertinoIcons.money_dollar_circle_fill,
      title: 'Track Your Finances',
      description:
          'Keep track of all your income and expenses in one place. Never lose sight of where your money goes.',
      emoji: '💰',
    ),
    OnboardingPage(
      icon: CupertinoIcons.smiley_fill,
      title: 'Connect Emotions',
      description:
          'Record how you feel about each transaction. Understand the emotional impact of your spending and earning habits.',
      emoji: '😊',
    ),
    OnboardingPage(
      icon: CupertinoIcons.chart_bar_fill,
      title: 'Gain Insights',
      description:
          'View detailed statistics and understand your financial behavior patterns over time.',
      emoji: '📊',
    ),
    OnboardingPage(
      icon: CupertinoIcons.add_circled_solid,
      title: 'Easy to Use',
      description:
          'Simply tap the + button to add a transaction, choose a category, select your emotion, and you\'re done!',
      emoji: '✨',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  Future<void> _completeOnboarding() async {
    await StorageService().setFirstLaunchComplete();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.transparent,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.getBackgroundGradient(isDark),
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip Button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (_currentPage < _pages.length - 1)
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        onPressed: _skipOnboarding,
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            color: isDark
                                ? const Color(0xFFE1BEE7)
                                : AppColors.lightPrimary,
                            fontSize: 16,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Page View
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _buildPage(_pages[index], isDark);
                  },
                ),
              ),

              // Page Indicator
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => _buildPageIndicator(index, isDark),
                  ),
                ),
              ),

              // Next/Get Started Button
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: _nextPage,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [const Color(0xFF9C27B0), const Color(0xFF7B2CBF)]
                            : [
                                AppColors.lightGradient1,
                                AppColors.lightPrimary,
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
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
                    child: Center(
                      child: Text(
                        _currentPage < _pages.length - 1
                            ? 'Next'
                            : 'Get Started',
                        style: const TextStyle(
                          color: AppColors.lightCard,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon/Emoji Container
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF9C27B0), const Color(0xFF7B2CBF)]
                    : [AppColors.lightGradient1, AppColors.lightPrimary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? const Color(0xFF9C27B0).withOpacity(0.4)
                      : AppColors.lightShadow,
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(page.emoji, style: const TextStyle(fontSize: 80)),
                const SizedBox(height: 10),
                Icon(page.icon, size: 60, color: AppColors.lightCard),
              ],
            ),
          ),
          const SizedBox(height: 60),

          // Title
          Text(
            page.title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDark ? const Color(0xFFE1BEE7) : AppColors.lightText1,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Description
          Text(
            page.description,
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: isDark ? AppColors.darkText2 : AppColors.lightPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(int index, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: _currentPage == index ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        gradient: _currentPage == index
            ? LinearGradient(
                colors: isDark
                    ? [const Color(0xFF9C27B0), const Color(0xFF7B2CBF)]
                    : [AppColors.lightGradient1, AppColors.lightPrimary],
              )
            : null,
        color: _currentPage == index
            ? null
            : (isDark ? const Color(0xFF3A2A5A) : AppColors.lightPrimary)
                  .withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingPage {
  final IconData icon;
  final String title;
  final String description;
  final String emoji;

  OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
    required this.emoji,
  });
}
