import 'package:fit_for_life/model/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProvider extends StateNotifier<dynamic> {
  UserProvider() : super({});

  Future<void> onSaveUserData(Map<String, dynamic> data) async {
    final userData = User.fromJson(data);

    state = userData;
  }
}

final userProvider = StateNotifierProvider<UserProvider, dynamic>(
  (ref) => UserProvider(),
);
