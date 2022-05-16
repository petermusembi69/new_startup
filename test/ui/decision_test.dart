// // A Counter implemented and tested using Flutter

// // We declared a provider globally, and we will use it in two tests, to see
// // if the state correctly resets to `0` between tests.

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:new_startup/provider/sign_in_provider.dart';
// import 'package:new_startup/ui/decision.dart';

// final counterProvider = StateProvider((ref) => 0);

// // Renders the current state and a button that allows incrementing the state
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Counter App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const DecisionPage(),
//     );
//   }
// }

// void main() {
//   testWidgets('Show log in screen is unauthenticated', (tester) async {
//     await tester.pumpWidget(const ProviderScope(child: DecisionPage()));

//     // The default value is `0`, as declared in our provider
//     expect(find.text('Counter App'), findsNothing);
//     expect(find.text('Sign In'), findsOneWidget);
//   });

// }
