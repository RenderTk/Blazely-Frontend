import 'package:blazely/providers/logged_in_provider.dart';
import 'package:blazely/providers/token_provider.dart';
import 'package:blazely/screens/home_screen.dart';
import 'package:blazely/screens/log_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

const softWhite = Color(0xFFFFFCF7); // Replace with 0xFFFAF5F0 for warmer tone
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
    onPrimary: softWhite,
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
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color.fromARGB(255, 28, 210, 216),
    foregroundColor: Colors.white,
    shape: StadiumBorder(),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: Color.fromARGB(255, 28, 210, 216),
      foregroundColor: Colors.white,
      shape: StadiumBorder(),
    ),
  ),
  cardTheme: CardTheme(
    color: Colors.white, // Or a slightly off-white like Color(0xFFF9F9F9)
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25),
      side: BorderSide(color: Colors.grey.shade200), // optional subtle border
    ),
    elevation: 3, // Add a small shadow to lift the card
    margin: const EdgeInsets.all(8),
  ),
);

//const softBlack = Color(0xFF2C2C2C);
const softBlack = Color.fromARGB(255, 24, 24, 24);
final darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: softBlack,
  appBarTheme: const AppBarTheme(
    backgroundColor: softBlack,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  colorScheme: const ColorScheme.dark(
    primary: Colors.white,
    onPrimary: softBlack,
    secondary: Colors.grey,
    onSecondary: Colors.white,
    surface: softBlack,
    onSurface: Colors.white,
  ),
  textTheme: GoogleFonts.fredokaTextTheme().apply(
    bodyColor: Colors.white,
    displayColor: Colors.white,
  ),
  iconTheme: const IconThemeData(color: Colors.white),
  dividerColor: Colors.grey.shade700,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.blueAccent,
    foregroundColor: Colors.white,
    shape: StadiumBorder(),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: Colors.blueAccent,
      foregroundColor: Colors.white,
      shape: StadiumBorder(),
    ),
  ),
  cardTheme: CardTheme(
    color: const Color.fromARGB(79, 82, 81, 81),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25),
      side: BorderSide(color: Colors.grey.shade800), // subtle border
    ),
    elevation: 3, // adds soft shadow
    margin: const EdgeInsets.all(8),
  ),
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final token = ref.watch(tokenAsyncProvider);
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return token.when(
      data: (token) {
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
      error:
          (error, stackTrace) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Blazely',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.system,
            home: Scaffold(body: const LogInScreen()),
          ),
      loading:
          () => MaterialApp(
            home: Scaffold(
              backgroundColor: isDarkMode ? softBlack : softWhite,
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
          ),
    );
  }
}
