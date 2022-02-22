import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:todoapp/screens/home_screen.dart';
import 'package:todoapp/screens/register_data_screen.dart';
import 'package:todoapp/utils/helper.dart';

class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({Key? key}) : super(key: key);

  @override
  _RegisterUserScreenState createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  @override
  Widget build(BuildContext context) {
    return AuthGate();
  }
}

class AuthGate extends StatelessWidget {
  AuthGate({Key? key}) : super(key: key);
  static const clientId =
      "793185555376-pkenuk5mtohuvh97bg3jcmiun0q76seq.apps.googleusercontent.com";

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // User is not signed in
        if (!snapshot.hasData) {
          return RegisterScreen(
              footerBuilder: (context, _) {
                return Row(
                  children: [
                    const Text('Already have an account?'),
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/loginScreen'),
                      child: const Text('Login'),
                    )
                  ],
                );
              },
              showAuthActionSwitch: false,
              providerConfigs: const [
                EmailProviderConfiguration(),
                GoogleProviderConfiguration(
                  clientId: clientId,
                )
              ]);
        }

        // Render your application if authenticated
        return const RegisterDataScreen();
      },
    );
  }
}
