import 'package:flutter/material.dart';
import 'package:chaseapp/src/modules/register/view/pages/register_page.dart';
import 'package:chaseapp/src/modules/signin/view/pages/signin_page.dart';

class AuthenticatePage extends StatefulWidget {
  @override
  _AuthenticatePageState createState() => _AuthenticatePageState();
}

class _AuthenticatePageState extends State<AuthenticatePage> {
  bool _showSignIn = true;

  void _toggleView() {
    setState(() {
      _showSignIn = !_showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSignIn) {
      return SignInPage();
    } else {
      return RegisterPage(toggleView: _toggleView);
    }
  }
}
