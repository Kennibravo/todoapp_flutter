import 'package:async/async.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/providers/user_provider.dart';
import 'package:todoapp/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return AuthGate();
  }
}

class AuthGate extends StatefulWidget {
  AuthGate({Key? key}) : super(key: key);
  static const clientId =
      "793185555376-pkenuk5mtohuvh97bg3jcmiun0q76seq.apps.googleusercontent.com";

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  AsyncMemoizer? _memoizer;

  @override
  void initState() {
    _memoizer = AsyncMemoizer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final userProvider = Provider.of<UserProvider>(context);

        // User is not signed in
        if (!snapshot.hasData) {
          return SignInScreen(
              footerBuilder: (context, _) {
                return Row(
                  children: [
                    const Text('Don\'t have an account?'),
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/registerScreen'),
                      child: const Text('Register'),
                    )
                  ],
                );
              },
              showAuthActionSwitch: false,
              providerConfigs: const [
                EmailProviderConfiguration(),
                GoogleProviderConfiguration(
                  clientId: AuthGate.clientId,
                )
              ]);
        }

        return FutureBuilder(
          future: _memoizer!.runOnce(() async {
            await userProvider.getAndSetUserDetails();
          }),
          builder: ((context, snapshot) {
            return HomeScreen();
          }),
        );

        // return HomeScreen();
      },
    );
  }
}
