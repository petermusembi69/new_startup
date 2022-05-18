import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:new_startup/provider/counter_provider.dart';
import 'package:new_startup/provider/auth_provider.dart';
import 'package:new_startup/repository/hive_repository.dart';
import 'package:new_startup/ui/decision.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterStateProvider);
    final signOutState = ref.watch(signOutStateProvider);
    final hiveRepository = ref.watch(hiveRepositoryProvider);

    final userName = hiveRepository.retrieveUserModel() != null
        ? hiveRepository.retrieveUserModel()!.name + '\'s'
        : '';
        
    if (signOutState == null || signOutState) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const DecisionPage(),
          ),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('$userName Counter App'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              ref.read(signOutStateProvider.notifier).signOut();
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(counterStateProvider.notifier).increment(),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
