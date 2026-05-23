import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/status_bar.dart';
import 'widgets/page_dot_indicator.dart';
import 'pages/calendar_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/photos_page.dart';
import 'core/theme.dart';

void main() {
  runApp(
    ProviderScope(
      child: const FamilyHub(),
    ),
  );
}

class FamilyHub extends StatelessWidget {
  const FamilyHub({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FamilyHub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 48),
            child: PageView(
              controller: _pageController,
              onPageChanged: (i) => setState(() => _currentPage = i),
              children: const [
                CalendarPage(),
                TasksPage(),
                PhotosPage(),
              ],
            ),
          ),
          Positioned(
            top: 0, left: 0, right: 0,
            child: StatusBar(
              onTapCalendar: () => _pageController.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
              onTapTasks: () => _pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
              onTapPhotos: () => _pageController.animateToPage(2, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
            ),
          ),
          Positioned(
            bottom: 16, left: 0, right: 0,
            child: PageDotIndicator(
              currentPage: _currentPage,
              pageCount: 3,
              onTap: (i) => _pageController.animateToPage(i, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
            ),
          ),
        ],
      ),
    );
  }
}
