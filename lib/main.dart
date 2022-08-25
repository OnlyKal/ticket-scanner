











import 'dart:async';
import 'dart:io';
import 'package:scanner_haaho/scan.pos.dart';
import 'package:flutter/material.dart';
import 'package:scanner_haaho/user.login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = PostHttpOverrides();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Haaho',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(title: 'HAAHO SCANNER'),
        '/pda': (context) => const PosScanner(),
        '/signin': (context) => const UserLogin(),
      },
    );
  }
}

const color = Color.fromARGB(255, 130, 91, 8);
appBar(context, title) {
  return AppBar(
    title: Text(title),
    backgroundColor: color,
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var data;
   final double _logoSize = 100;
  Future getSession() async {
    final session = await SharedPreferences.getInstance();
    data = {
      'id': session.getString('id').toString(),
      'token': session.getString('user_token'),
      'fullname': session.getString('user_names'),
      'phone': session.getString('user_phone'),
    };

    Timer(
        const Duration(seconds: 3),
        () => {
  
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => data['token'] == null
                    ? const UserLogin()
                    : const PosScanner()))
        });
  }

  @override
  void initState() {
    getSession();
    super.initState();
  }

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
            child: SizedBox(
          height: MediaQuery.of(context).size.height * 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  AnimatedSize(
                    curve: Curves.easeIn,
                    duration: const Duration(seconds: 3),
                    child: Container(
                      height: _logoSize,
                      width: _logoSize,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          image: const DecorationImage(
                            image: AssetImage(
                              'assets/haaho.png',
                            ),
                            fit: BoxFit.cover,
                          )),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  // const Text(
                  //   'Haaho Events System - Scanner Tickets ',
                  //   style: TextStyle(
                  //       fontWeight: FontWeight.w400, color: Colors.white),
                  // ),
                ],
              ),
            ],
          ),
        )));
  }
}
