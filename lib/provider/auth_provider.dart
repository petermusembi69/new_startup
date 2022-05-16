import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:new_startup/models/user_model.dart';
import 'package:new_startup/services/hive_service.dart';

part 'auth_provider.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const AuthState._();
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.loaded() = _Loaded;
  const factory AuthState.failure() = _Failure;
}

final signInStateProvider =
    StateNotifierProvider<SignInStateNotifier, AuthState>((ref) {
  return SignInStateNotifier();
});

class SignInStateNotifier extends StateNotifier<AuthState> {
  SignInStateNotifier([AuthState? bool]) : super(const AuthState.initial());

  void singIn(String userName) async {
    state = const AuthState.loading();
    try {
      DatabaseReference databaseRef =
          FirebaseDatabase.instance.ref('users/$userName');
      final DataSnapshot snapshot = await databaseRef.get();

      if (!snapshot.exists) {
        await databaseRef.set(CountModel(count: 0).toJson());
      }

      HiveServiceImpl()
        ..persistUserModel(
          UserModel(
            name: userName,
            count: CountModel(
              count: snapshot.exists
                  ? CountModel.fromJson(jsonDecode(jsonEncode(snapshot.value)))
                      .count
                  : 0,
            ),
          ),
        )
        ..persistSigningStatus(true);

      state = const AuthState.loaded();
    } catch (e) {
      state = const AuthState.failure();

      Logger().e(e.toString());

      rethrow;
    }
  }
}

final signOutStateProvider =
    StateNotifierProvider<SignOutStateNotifier, bool?>((ref) {
  return SignOutStateNotifier();
});

class SignOutStateNotifier extends StateNotifier<bool?> {
  SignOutStateNotifier([bool? bool])
      : super(HiveServiceImpl().retrieveSigningStatus());

  void signOut() {
    try {
      HiveServiceImpl().clearPrefs();
      state = false;
    } catch (e) {
      Logger().e(e.toString());

      rethrow;
    }
  }

  void signIn() {
    try {
      state = true;
    } catch (e) {
      Logger().e(e.toString());

      rethrow;
    }
  }
}
