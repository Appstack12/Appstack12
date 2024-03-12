import 'package:fit_for_life/model/user_profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfileProvider extends StateNotifier<UserProfile> {
  UserProfileProvider() : super(UserProfile());

  Future<void> onSaveUserProfile(Map<String, dynamic> data) async {
    final userData = UserProfile.fromJson(data);
    state = userData;
  }
}

final userProfileProvider =
    StateNotifierProvider<UserProfileProvider, UserProfile>(
  (ref) => UserProfileProvider(),
);
