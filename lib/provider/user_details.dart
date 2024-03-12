import 'package:fit_for_life/model/user_details.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserDetailsProvider extends StateNotifier<UserDetails> {
  UserDetailsProvider() : super(UserDetails());

  Future<void> onSaveUserDetails(Map<String, dynamic> data) async {
    final userData = UserDetails.fromJson(data);
    state = userData;
  }
}

final userDetailsProvider = StateNotifierProvider<UserDetailsProvider, UserDetails>(
  (ref) => UserDetailsProvider(),
);
