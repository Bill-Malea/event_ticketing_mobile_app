import 'package:event_ticketing_mobile_app/provider/signup_pages.dart';
import 'package:event_ticketing_mobile_app/screens/Login/widgets/Login.dart';
import 'package:event_ticketing_mobile_app/screens/Login/widgets/Signup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
  final dynamic route;

  const SignupPage({super.key, required this.route});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    final selectedPage =
        Provider.of<LoginNavigationProvider>(context).selectedpage;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: _getPageWidget(
            selectedPage,
          ),
        ),
      ),
    );
  }

  Widget _getPageWidget(
    int selectedPage,
  ) {
    switch (selectedPage) {
      case 0:
        return LoginWidget(
          route: widget.route,
        );
      case 1:
        return const RegisterWidget(route: widget.route);

      default:
        return Container();
    }
  }
}
