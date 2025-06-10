import 'package:intl/intl.dart';

class DateTimeFormats {
  static final DateFormat apiDate = DateFormat('yyyy-MM-dd');
  static final DateFormat apiDateTime = DateFormat('yyyy-MM-dd HH:mm:ss');
  static final DateFormat userDate = DateFormat.yMMMd(); // Jun 8, 2025
  static final DateFormat userDateTime =
      DateFormat.yMMMd().add_jm(); // Jun 8, 2025 2:00 PM

  // From API format to DateTime
  static DateTime? tryParseApiDate(String? input) {
    if (input == null) return null;
    try {
      return apiDate.parseStrict(input);
    } catch (_) {
      return null;
    }
  }

  static DateTime? tryParseApiDateTime(String? input) {
    if (input == null) return null;
    try {
      return apiDateTime.parseStrict(input);
    } catch (_) {
      return null;
    }
  }

  // From user-friendly format to DateTime
  static DateTime? tryParseUserDate(String? input) {
    if (input == null) return null;
    try {
      return userDate.parseStrict(input);
    } catch (_) {
      return null;
    }
  }

  static DateTime? tryParseUserDateTime(String? input) {
    if (input == null) return null;
    try {
      return userDateTime.parseStrict(input);
    } catch (_) {
      return null;
    }
  }

  // Optional: Formatters
  static String formatApiDate(DateTime date) => apiDate.format(date);
  static String formatApiDateTime(DateTime date) => apiDateTime.format(date);
  static String formatUserDate(DateTime date) => userDate.format(date);
  static String formatUserDateTime(DateTime date) => userDateTime.format(date);
}
