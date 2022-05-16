import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:new_startup/provider/auth_provider.dart';
import 'package:new_startup/ui/home_page.dart';

class SignInPage extends HookConsumerWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textEditingController = useTextEditingController();

    ref.listen<AuthState>(
      signInStateProvider,
      (previous, next) {
        if (next == const AuthState.failure()) {
          showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
                child: dialogBox(context, 'Error Signing In'),
              );
            },
          );
        }
        if (next == const AuthState.loaded()) {
          ref.read(signOutStateProvider.notifier).signIn();

          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        }
      },
    );

    final formFieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        width: 1.5,
        style: BorderStyle.solid,
        color: Colors.black38,
      ),
    );

    return Scaffold(
      body: Center(
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(30.0),
                child: Text(
                  'Sign in',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 30),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: textEditingController,
                  keyboardType: TextInputType.text,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                  decoration: InputDecoration(
                    label: const Text(
                      'User Name',
                    ),
                    labelStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Colors.black54,
                        ),
                    errorStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                    border: formFieldBorder,
                    focusedBorder: formFieldBorder,
                    enabledBorder: formFieldBorder,
                    disabledBorder: formFieldBorder,
                    filled: true,
                    contentPadding: const EdgeInsets.all(16),
                    fillColor: Colors.transparent,
                  ),
                ),
              ),
              HookConsumer(
                builder: (context, ref, child) {
                  return Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: MaterialButton(
                      elevation: 1,
                      onPressed: () {
                        ref.read(signInStateProvider.notifier).singIn(
                              textEditingController.text,
                            );
                      },
                      color: Colors.cyan,
                      minWidth: double.infinity,
                      padding: const EdgeInsets.all(10),
                      height: 50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: ref.watch(signInStateProvider).when(
                            initial: () => const Text(
                              'Sign in',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            loading: () => const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                                backgroundColor: Colors.cyan,
                              ),
                            ),
                            loaded: () => const Text(
                              'Sign in',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            failure: () => const Text(
                              'Sign in',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget dialogBox(BuildContext context, String message) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 20,
            bottom: 20,
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Icon(
                    CupertinoIcons.exclamationmark_circle,
                    color: Colors.cyan,
                    size: 80,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    message,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                InkWell(
                  onTap: () async {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      elevation: 0,
                      highlightElevation: 0,
                      focusColor: Colors.transparent,
                      color: Colors.transparent,
                      highlightColor: Colors.transparent,
                      minWidth: MediaQuery.of(context).size.width * .4,
                      padding: const EdgeInsets.all(10),
                      height: 50,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.cyan.withOpacity(0.3),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Close',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.cyan,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
