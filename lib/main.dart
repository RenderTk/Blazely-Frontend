import 'package:blazely/providers/logged_in_provider.dart';
import 'package:blazely/providers/token_provider.dart';
import 'package:blazely/screens/home_screen.dart';
import 'package:blazely/screens/log_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

const softWhite = Color(0xFFFFFCF7); // Replace with 0xFFFAF5F0 for warmer tone

const scaffoldBackgroundColorLight = softWhite;
final lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: softWhite,
  appBarTheme: AppBarTheme(
    backgroundColor: softWhite,
    foregroundColor: Colors.black,
    elevation: 0,
  ),
  colorScheme: const ColorScheme.light(
    primary: Colors.black,
    onPrimary: Colors.white,
    secondary: Colors.grey,
    onSecondary: Colors.black,
    surface: softWhite,
    onSurface: Colors.black,
  ),
  textTheme: GoogleFonts.fredokaTextTheme().apply(
    bodyColor: Colors.black,
    displayColor: Colors.black,
  ),
  iconTheme: const IconThemeData(color: Colors.black),
  dividerColor: Colors.grey.shade300,
);

const scaffoldBackgroundColorDark = Color(0xFF1E1E1E);
final darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: scaffoldBackgroundColorDark,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1E1E1E),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  colorScheme: const ColorScheme.dark(
    primary: Colors.white,
    onPrimary: Colors.black,
    secondary: Colors.grey,
    onSecondary: Colors.white,
    surface: Color(0xFF2C2C2C),
    onSurface: Colors.white,
  ),
  textTheme: GoogleFonts.fredokaTextTheme().apply(
    bodyColor: Colors.white,
    displayColor: Colors.white,
  ),
  iconTheme: const IconThemeData(color: Colors.white),
  dividerColor: Colors.grey.shade700,
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  Future<void> _loadToken(WidgetRef ref) async {
    final tokenNotifier = ref.read(tokenProviderNotifier.notifier);
    await tokenNotifier.loadTokenFromLocalSecureStorage();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: _loadToken(ref),
      builder: (context, snapshot) {
        final isDarkMode =
            MediaQuery.of(context).platformBrightness == Brightness.dark;

        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              backgroundColor:
                  isDarkMode
                      ? scaffoldBackgroundColorDark
                      : scaffoldBackgroundColorLight,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/blazely_logo.png",
                      height: 300,
                      width: 300,
                      fit: BoxFit.cover,
                    ),
                    CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(height: 20),
                    Text("Initializing..."),
                  ],
                ),
              ),
            ),
          );
        }

        final isLoggedIn = ref.watch(isLoggedInProvider);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Blazely',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.system,
          home: Scaffold(
            body: isLoggedIn ? const HomeScreen() : const LogInScreen(),
          ),
        );
      },
    );
  }
}
