import 'package:blazely/providers/google_auth_provider.dart';
import 'package:blazely/utils/snackbar_helper.dart';
import 'package:blazely/widgets/buttons/google_ripple_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogInScreen extends ConsumerWidget {
  const LogInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final googleAuthNotifier = ref.watch(googleAuthProvider.notifier);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          children: [
            Image.asset(
              "assets/images/blazely_logo.png",
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 50),
            Text(
              "Hey There, Welcome to Blazely",
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 20),
            ClipOval(
              child: Image.asset(
                "assets/images/working_guy.png",
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 50),
            Text(
              "Login to your account to continue",
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            SizedBox(height: 60),
            GoogleRippleButton(
              onPressed: () async {
                bool value = await googleAuthNotifier.googleSignIn();
                if (value == false) {
                  if (context.mounted) {
                    SnackbarHelper.showCustomSnackbar(
                      context: context,
                      message: 'Login Failed, try again later.',
                      type: SnackbarType.error,
                    );
                  }
                }
              },
            ),
            Spacer(),
            SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Made with ",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Icon(Icons.favorite, color: Colors.red),
                  Text(
                    " by Tropix.dev",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
