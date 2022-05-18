import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:new_startup/models/user_model.dart';
import 'package:new_startup/repository/hive_repository.dart';

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
  final hiveRepository = ref.watch(hiveRepositoryProvider);

  return SignInStateNotifier(hiveRepository);
});

class SignInStateNotifier extends StateNotifier<AuthState> {
  SignInStateNotifier(HiveRepository hiveRepository, [AuthState? bool])
      : _hiveRepository = hiveRepository,
        super(const AuthState.initial());

  final HiveRepository _hiveRepository;

  void singIn(String userName) async {
    state = const AuthState.loading();
    try {
      DatabaseReference databaseRef =
          FirebaseDatabase.instance.ref('users/$userName');
      final DataSnapshot snapshot = await databaseRef.get();

      if (!snapshot.exists) {
        await databaseRef.set(CountModel(count: 0).toJson());
      }

      _hiveRepository
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
  final hiveRepository = ref.watch(hiveRepositoryProvider);

  return SignOutStateNotifier(hiveRepository);
});

class SignOutStateNotifier extends StateNotifier<bool?> {
  SignOutStateNotifier(HiveRepository hiveRepository, [bool? bool])
      : _hiveRepository = hiveRepository,
        super(hiveRepository.retrieveSigningStatus());

  final HiveRepository _hiveRepository;

  void signOut() {
    try {
      _hiveRepository.clearPrefs();

      state = true;
    } catch (e) {
      Logger().e(e.toString());

      rethrow;
    }
  }

  void signIn() {
    try {
      state = false;
    } catch (e) {
      Logger().e(e.toString());

      rethrow;
    }
  }
}
