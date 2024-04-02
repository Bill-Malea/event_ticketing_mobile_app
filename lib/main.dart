import 'package:event_ticketing_mobile_app/provider/nav_bar.dart';
import 'package:event_ticketing_mobile_app/screens/homescreen/homepage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
      key: ObjectKey(DateTime.now().toString()),
      providers: [
        ChangeNotifierProvider(
          create: (context) => NavProvider(),
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
