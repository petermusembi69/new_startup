import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:new_startup/models/user_model.dart';
import 'package:new_startup/utils/constants.dart';


final hiveRepositoryProvider = Provider((ref) => HiveRepository());

class HiveRepository {
  Future<void> initBoxes() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserModelAdapter());
    await Hive.openBox<dynamic>(AppConfig.instance!.values.authBox);
  }

  bool? retrieveSigningStatus() {
    final _box = Hive.box<dynamic>(AppConfig.instance!.values.authBox);
    return _box.get('sign_in_status') as bool?;
  }

  void persistSigningStatus(bool signInStatus) {
    Hive.box<dynamic>(AppConfig.instance!.values.authBox)
        .put('sign_in_status', signInStatus);
  }

  UserModel? retrieveUserModel() {
    final _box = Hive.box<dynamic>(AppConfig.instance!.values.authBox);
    final _userData = _box.get('user_model') as UserModel?;
    return _userData;
  }

  void persistUserModel(UserModel storeData) {
    Hive.box<dynamic>(AppConfig.instance!.values.authBox)
        .put('user_model', storeData);
  }

  void clearUserModel() {
    Hive.box<dynamic>(AppConfig.instance!.values.authBox).delete('user_model');
  }

  void clearPrefs() {
    Hive.box<dynamic>(AppConfig.instance!.values.authBox).deleteAll(<dynamic>[
      'sign_in_status',
      'user_model',
    ]);
  }
}
