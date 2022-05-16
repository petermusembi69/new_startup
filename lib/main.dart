import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_startup/services/hive_service.dart';
import 'package:new_startup/ui/decision.dart';
import 'package:new_startup/utils/constants.dart';

void main() async {
  AppConfig(
    values: AppValues(
      authBox: 'newStartApp',
    ),
  );

  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();

  await HiveServiceImpl().initBoxes();

  runApp(
    ProviderScope(
      child: MaterialApp(
        title: 'Counter App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
            ),
          ),
        ),
        home: 
        const DecisionPage(),
      ),
    ),
  );
}
