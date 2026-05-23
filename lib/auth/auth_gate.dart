import 'package:flutter/material.dart';
import '../main.dart' as app;

/// AuthGate — skips Google Sign-In for testing.
/// In production this gates access until Google Sign-In succeeds.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return const app.FamilyHub();
  }
}
