import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogoutProvider extends StateNotifier<bool> {
  LogoutProvider() : super(false);

  Future<void> onLogout(bool value) async {
    state = value;
  }
}

final logoutProvider = StateNotifierProvider<LogoutProvider, bool>(
  (ref) => LogoutProvider(),
);
