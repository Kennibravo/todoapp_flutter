import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/providers/user_provider.dart';
import 'package:todoapp/screens/home_screen.dart';
import 'package:todoapp/utils/helper.dart';

class RegisterDataScreen extends StatefulWidget {
  const RegisterDataScreen({Key? key}) : super(key: key);

  @override
  _RegisterDataScreenState createState() => _RegisterDataScreenState();
}

class _RegisterDataScreenState extends State<RegisterDataScreen> {
  final _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  bool? usernameError;
  bool? checkingUsernameAvailable;

  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: mediaQuery.padding.top + 20,
          bottom: mediaQuery.padding.bottom,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Please tell us more about you to help us create your profile.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40),

                  const FlutterLogo(size: 100),
                  const SizedBox(height: 40),
                  Column(
                    children: [
                      TextFormField(
                        onChanged: (value) async {
                          setState(() {
                            checkingUsernameAvailable = true;
                          });

                          final usernameCheck =
                              await Helper.usernameExists(value);

                          setState(() {
                            usernameError = usernameCheck;
                            checkingUsernameAvailable = false;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Username is required.';
                          }

                          if (usernameError!) {
                            return 'Username already exists.';
                          }

                          return null;
                        },
                        style: const TextStyle(fontSize: 40),
                        autofocus: true,
                        controller: usernameController,
                        decoration: InputDecoration(
                          suffixIcon: checkingUsernameAvailable == true
                              ? const CircularProgressIndicator()
                              : null,
                          label: const Text('Username'),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'First name is required.';
                                }

                                return null;
                              },
                              style: const TextStyle(fontSize: 40),
                              autofocus: true,
                              controller: firstnameController,
                              decoration: const InputDecoration(
                                label: Text('First name'),
                                // border: InputBorder.none,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Last name is required.';
                                }

                                return null;
                              },
                              style: const TextStyle(fontSize: 40),
                              autofocus: true,
                              controller: lastnameController,
                              decoration: const InputDecoration(
                                label: Text('Last name'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  SizedBox(
                    width: mediaQuery.size.width * 0.7,
                    child: ElevatedButton.icon(
                      onPressed: checkingUsernameAvailable == true
                          ? null
                          : () async {
                              setState(() {
                                _isLoading = true;
                              });

                              if (_formKey.currentState!.validate()) {
                                try {
                                  await updateUserDetails();
                                  setState(() {
                                    _isLoading = false;
                                    Navigator.of(context)
                                        .pushNamed('/homeScreen');
                                  });
                                } catch (e) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              } else {
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            },
                      icon: const Icon(Icons.save),
                      label: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text(
                              'Save details',
                              style: TextStyle(fontSize: 15),
                            ),
                    ),
                  ),
                  // const SizedBox(height: 1),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> updateUserDetails() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;

    firestore.collection('users').doc(auth.currentUser!.uid).set({
      'username': usernameController.text,
      'created_at': DateTime.now(),
      'first_name': firstnameController.text,
      'last_name': lastnameController.text
    });

    final userProvider = Provider.of<UserProvider>(context);
    await userProvider.getAndSetUserDetails();
  }
}
