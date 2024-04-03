import 'package:event_ticketing_mobile_app/firebase_options.dart';
import 'package:event_ticketing_mobile_app/provider/auth.dart';
import 'package:event_ticketing_mobile_app/provider/mpesa.dart';
import 'package:event_ticketing_mobile_app/provider/nav_bar.dart';
import 'package:event_ticketing_mobile_app/provider/signup_pages.dart';
import 'package:event_ticketing_mobile_app/screens/homescreen/homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiProvider(
      key: ObjectKey(DateTime.now().toString()),
      providers: [
        ChangeNotifierProvider(
          create: (context) => LoginNavigationProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => NavProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PaymentProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => FbAuthProvider(),
        ),
      ],
      child: const UserApp()));
}

class UserApp extends StatelessWidget {
  const UserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ticket Sales App',
      theme: ThemeData(
        primaryColor: Colors.green,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.black),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<Widget> pages = [
    const HomePage(),
  ];
  @override
  Widget build(BuildContext context) {
    final selectedpage = Provider.of<NavProvider>(context).selectetab;
    return Scaffold(
      appBar: selectedpage == 1 ? null : AppBar(),
      body: Center(child: pages.elementAt(selectedpage)),
    );
  }
}
