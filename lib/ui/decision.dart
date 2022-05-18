import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:new_startup/provider/auth_provider.dart';
import 'package:new_startup/ui/home_page.dart';
import 'package:new_startup/ui/sign_in_page.dart';

class DecisionPage extends HookConsumerWidget {
  const DecisionPage({
    Key? key,
  }) : super(key: key);

  void _redirectToPage(BuildContext context, {required Widget page}) {
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 1000),
            pageBuilder: (context, animation, secondaryAnimation) =>
                FadeTransition(opacity: animation, child: page),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeData = Theme.of(context);
    return HookConsumer(
      builder: (context, ref, child) {
        final signOutProvider = ref.watch(signOutStateProvider);

        if (signOutProvider == null || signOutProvider) {
          _redirectToPage(
            context,
            page: const SignInPage(),
          );
        } else {
          _redirectToPage(
            context,
            page: const HomePage(),
          );
        }
        return Scaffold(
          body: Center(
            child: Text(
              '',
              style: themeData.textTheme.headline6!.copyWith(
                color: Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }
}
