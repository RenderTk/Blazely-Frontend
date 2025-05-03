import 'package:flutter_riverpod/flutter_riverpod.dart';

class IsLoggedInProviderNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void setIsLoggedIn(bool value) {
    state = value;
  }

  void setIsNotLoggedIn() {
    state = false;
  }
}

final isLoggedInProvider = NotifierProvider<IsLoggedInProviderNotifier, bool>(
  () => IsLoggedInProviderNotifier(),
);
