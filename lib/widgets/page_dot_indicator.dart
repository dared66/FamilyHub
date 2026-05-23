import 'package:flutter/material.dart';

/// A row of tappable dots indicating the current page.
class PageDotIndicator extends StatelessWidget {
  final int currentPage;
  final int pageCount;
  final ValueChanged<int>? onTap;

  const PageDotIndicator({
    super.key,
    required this.currentPage,
    required this.pageCount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pageCount, (i) {
        final isActive = i == currentPage;
        return SizedBox(
          width: 32,
          height: 32,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onTap?.call(i),
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isActive ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: isActive ? const Color(0xFF1A73E8) : Colors.grey.shade500,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
