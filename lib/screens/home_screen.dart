import 'package:blazely/providers/google_auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final googleAuthNotifier = ref.watch(googleAuthProvider.notifier);

    return Center(
      child: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            googleAuthNotifier.googleSignOut();
          },
          label: Text("Logout from google"),
          icon: Icon(Icons.logout),
        ),
      ),
    );
  }
}
