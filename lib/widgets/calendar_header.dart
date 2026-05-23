import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarHeader extends StatelessWidget {
  final DateTime currentDate;
  final String viewMode;
  final ValueChanged<String> onViewModeChanged;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const CalendarHeader({
    Key? key,
    required this.currentDate,
    required this.viewMode,
    required this.onViewModeChanged,
    required this.onPrevious,
    required this.onNext,
  }) : super(key: key);

  String _getTitleText() {
    switch (viewMode) {
      case 'day':
        return DateFormat('EEEE, MMMM d, yyyy').format(currentDate);
      case 'week':
      case 'month':
        return DateFormat('MMMM yyyy').format(currentDate);
      case 'upcoming':
        return 'Upcoming Events';
      default:
        return DateFormat('MMMM yyyy').format(currentDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: Navigation buttons and title
          Row(
            children: [
              // Previous button
              IconButton(
                onPressed: onPrevious,
                icon: Icon(Icons.chevron_left),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.white.withOpacity(0.7),
                  ),
                  shape: MaterialStateProperty.all(
                    CircleBorder(),
                  ),
                  elevation: MaterialStateProperty.all(2),
                ),
              ),
              
              // Title card
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                constraints: const BoxConstraints(
                  minWidth: 200,
                ),
                child: Text(
                  _getTitleText(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // Next button
              IconButton(
                onPressed: onNext,
                icon: Icon(Icons.chevron_right),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.white.withOpacity(0.7),
                  ),
                  shape: MaterialStateProperty.all(
                    CircleBorder(),
                  ),
                  elevation: MaterialStateProperty.all(2),
                ),
              ),
            ],
          ),

          // Right side: View mode pills
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                _buildViewModePill('upcoming', 'Upcoming'),
                _buildViewModePill('day', 'Day'),
                _buildViewModePill('week', 'Week'),
                _buildViewModePill('month', 'Month'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewModePill(String mode, String label) {
    bool isActive = viewMode == mode;
    
    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: isActive 
            ? Colors.white 
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onViewModeChanged(mode),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              label,
              style: TextStyle(
                fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
                color: isActive ? Colors.black : Colors.grey[700],
              ),
            ),
          ),
        ),
      ),
    );
  }
}