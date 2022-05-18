import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:new_startup/models/user_model.dart';
import 'package:new_startup/repository/hive_repository.dart';

final counterStateProvider =
    StateNotifierProvider.autoDispose<CounterStateNotifier, int>((ref) {
  final hiveRepository = ref.watch(hiveRepositoryProvider);

  return CounterStateNotifier(hiveRepository);
});

class CounterStateNotifier extends StateNotifier<int> {
  CounterStateNotifier(HiveRepository hiveRepository, [int? counter])
      : _hiveRepository = hiveRepository,
        super(counter ?? hiveRepository.retrieveUserModel()!.count.count);

  final HiveRepository _hiveRepository;

  void increment() async {
    final currentState = state;
    try {
      final userName = _hiveRepository.retrieveUserModel()!.name;

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
