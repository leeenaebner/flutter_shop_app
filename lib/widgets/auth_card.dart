import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/auth_screen.dart';

class AuthCard extends StatefulWidget {
  const AuthCard({Key? key}) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'pw': '',
  };

  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _showErrorDialog(BuildContext context, String msg) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text("An error occured"),
              content: Text(msg),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text("Ok"),
                ),
              ],
            ));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(
          context,
          listen: false,
        ).login(_authData['email']!, _authData['pw']!);
      } else {
        await Provider.of<Auth>(
          context,
          listen: false,
        ).signup(_authData['email']!, _authData['pw']!);
      }
    } on HttpException catch (error) {
      var errorMessage = "Authentication failed";

      if (error.toString().contains("EMAIL_EXISTS")) {
        errorMessage = "Email address already exists. Try another one.";
      } else if (error.toString().contains("INVALID_EMAIL")) {
        errorMessage = "Something seems to be wrong with the email.";
      } else if (error.toString().contains("EMAIL_NOT_FOUND")) {
        errorMessage = "Could not find a user with this email.";
      } else if (error.toString().contains("INVALID_PASSWORD")) {
        errorMessage = "Invalid password.";
      }

      _showErrorDialog(context, errorMessage);
    } catch (error) {
      const errorMessage = "Could not authenticate, please try again later.";
      _showErrorDialog(context, errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 8,
      child: Container(
        height: _authMode == AuthMode.Signup ? 320 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val!.isEmpty || !val.contains('@')) {
                      return 'Invalid E-Mail address';
                    }
                  },
                  onSaved: (val) {
                    _authData['email'] = val!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  controller: _passwordController,
                  obscureText: true,
                  validator: (val) {
                    if (val!.isEmpty || val.length < 6) {
                      return 'Password is too short';
                    }
                  },
                  onSaved: (val) {
                    _authData['pw'] = val!;
                  },
                ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        ? (val) {
                            if (val! != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                          }
                        : null,
                    onSaved: (val) {
                      _authData['pw'] = val!;
                    },
                  ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          padding:
                              EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                          primary: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          textStyle: TextStyle(color: Colors.white),
                        ),
                        child: Text(
                            _authMode == AuthMode.Signup ? "Signup" : "Login"),
                      ),
                      TextButton(
                        onPressed: _switchAuthMode,
                        style: ElevatedButton.styleFrom(
                          padding:
                              EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          textStyle: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        child: Text(
                            _authMode == AuthMode.Signup ? "Login" : "Signup"),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
