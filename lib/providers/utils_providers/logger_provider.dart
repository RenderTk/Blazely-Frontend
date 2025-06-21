import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

final loggerProvider = Provider<Logger>((ref) {
  return logger;
});

Logger logger = Logger(
  printer: PrettyPrinter(
    methodCount: 3, // Show 1 level of stack trace
    colors: true, // Enable colored output
    printEmojis: true, // Include emojis
    dateTimeFormat: DateTimeFormat.dateAndTime, // Add timestamps
  ),
);
