import 'package:flutter/material.dart';

/// Photos page — ambient slideshow from Google Photos.
///
/// Shows full-screen photos with auto-advance, cross-fade,
/// tap to step/pause. Skeleton for V2.
class PhotosPage extends StatelessWidget {
  const PhotosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF121212),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.photo_library, size: 64, color: Colors.white70),
            SizedBox(height: 16),
            Text(
              'FAMILYHUB',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Connect Google Photos for slideshow',
              style: TextStyle(color: Colors.white60, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
