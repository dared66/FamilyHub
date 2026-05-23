import 'package:flutter/material.dart';

/// A clean event card widget with glass effect styling.
class EventCard extends StatelessWidget {
  /// The title of the event
  final String title;

  /// The time of the event (formatted like "10:00 AM")
  final String time;

  /// The date of the event (formatted like "May 15, 2026")
  final String date;

  /// Color for the left accent bar
  final Color color;

  /// Callback when the card is tapped
  final VoidCallback? onTap;

  const EventCard({
    super.key,
    required this.title,
    required this.time,
    required this.date,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E).withOpacity(0.85),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: const Color(0xFF2A2A2A),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Left colored bar (4px wide)
              Container(
                width: 4.0,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(4.0),
                    right: Radius.circular(4.0),
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
              // Content area
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title in bold
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4.0),
                    // Time below title
                    Text(
                      time,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13.0,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    // Date below time
                    Text(
                      date,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 11.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}