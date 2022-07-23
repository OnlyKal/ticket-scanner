import 'dart:io';
import 'package:scanner_haaho/pdf.dart';
import 'package:scanner_haaho/scan.pos.dart';
import 'package:scanner_haaho/user.login.dart';
import 'scan.camera.dart';
import 'package:flutter/material.dart';

class PostHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = PostHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Haaho',
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      //   focusColor: color,
      // ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/x': (context) => const MyHomePage(title: 'Haaho Scanner Ticket'),
        // '/camera': (context) => const Camera(),
        '/pos': (context) => const PosScanner(),
        '/':((context) => const UserLogin())
      },
      // home: const MyHomePage(title: 'Haaho Scanner Ticket'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: SizedBox(
      height: MediaQuery.of(context).size.height * 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    image: const DecorationImage(
                      image: AssetImage(
                        'assets/haaho.png',
                      ),
                      fit: BoxFit.cover,
                    )),
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                'Haaho Scanner Ticket',
                style: TextStyle(
                    fontSize: 24.0, color: color, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                'Scan a ticket to check validity to the current Event',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              OutlinedButton(
                onPressed: () => Navigator.pushNamed(context, '/pos'),
                child: const Text(
                  'Scan QR CODE',
                  style: TextStyle(color: Colors.white),
                ),
                style: OutlinedButton.styleFrom(backgroundColor: color),
              ),
              const SizedBox(
                height: 20,
              ),
              // OutlinedButton(
              //   onPressed: () => Navigator.pushNamed(context, '/camera'),
              //   child: const Text(
              //     'Scann QR Code Phone Camera',
              //     style: TextStyle(color: Colors.white),
              //   ),
              //   style: OutlinedButton.styleFrom(backgroundColor: color),
              // ),
            ],
          ),
          const Text(
            'TOGREE COMPANY@2022',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    )));
  }
}

