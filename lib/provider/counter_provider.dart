import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:new_startup/models/user_model.dart';
import 'package:new_startup/services/hive_service.dart';

final counterProvider =
    FutureProvider.family<void, CountModel>((ref, countModel) async {});

final counterStateProvider =
    StateNotifierProvider.autoDispose<CounterStateNotifier, int>((ref) {
  return CounterStateNotifier();
});

class CounterStateNotifier extends StateNotifier<int> {
  CounterStateNotifier([int? counter])
      : super(counter ?? HiveServiceImpl().retrieveUserModel()!.count.count);

  void increment() async {
    final currentState = state;
    try {
      final userName = HiveServiceImpl().retrieveUserModel()!.name;

      DatabaseReference databaseRef =
          FirebaseDatabase.instance.ref("users/$userName");
      await databaseRef.update(CountModel(count: currentState + 1).toJson());
      state += 1;
    } catch (e) {
      Logger().e(e.toString());

      rethrow;
    }
  }
}
