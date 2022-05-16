import 'package:hive_flutter/hive_flutter.dart';
import 'package:new_startup/models/user_model.dart';
import 'package:new_startup/utils/constants.dart';

abstract class HiveService {
  Future initBoxes();
  void clearPrefs();

  void persistSigningStatus(bool token);
  bool? retrieveSigningStatus();

  void persistUserModel(UserModel userData);
  void clearUserModel();
  UserModel? retrieveUserModel();
}

class HiveServiceImpl implements HiveService {
  @override
  Future<void> initBoxes() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserModelAdapter());
    await Hive.openBox<dynamic>(AppConfig.instance!.values.authBox);
  }

  @override
  bool? retrieveSigningStatus() {
    final _box = Hive.box<dynamic>(AppConfig.instance!.values.authBox);
    return _box.get('sign_in_status') as bool?;
  }

  @override
  void persistSigningStatus(bool signInStatus) {
    Hive.box<dynamic>(AppConfig.instance!.values.authBox)
        .put('sign_in_status', signInStatus);
  }

  @override
  UserModel? retrieveUserModel() {
    final _box = Hive.box<dynamic>(AppConfig.instance!.values.authBox);
    final _userData = _box.get('user_model') as UserModel?;
    return _userData;
  }

  @override
  void persistUserModel(UserModel storeData) {
    Hive.box<dynamic>(AppConfig.instance!.values.authBox)
        .put('user_model', storeData);
  }

  @override
  void clearUserModel() {
    Hive.box<dynamic>(AppConfig.instance!.values.authBox).delete('user_model');
  }

  @override
  void clearPrefs() {
    Hive.box<dynamic>(AppConfig.instance!.values.authBox).deleteAll(<dynamic>[
      'sign_in_status',
      'user_model',
    ]);
  }
}
