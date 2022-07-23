import 'package:flutter/material.dart';
import 'package:scanner_haaho/main.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({Key? key}) : super(key: key);

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  TextEditingController txtusername = TextEditingController();
  TextEditingController txtpassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
          child: SizedBox(
        height: height,
        width: width,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top * 4,
              ),
              Row(
                children: [
                  Container(
                    height: 46,
                    width: 46,
                    decoration: BoxDecoration(
                        image: const DecorationImage(
                            image: AssetImage('assets/haaho.png')),
                        borderRadius: BorderRadius.circular(12),
                        color: color),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Haaho Scanner',
                        style: TextStyle(
                            fontSize: 23, fontWeight: FontWeight.w800),
                      ),
                      Text(
                        'Welcome to Haaho applicaton',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color: color),
                      )
                    ],
                  ),
                ],
              ),

              // ...

              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: height * 0.06,
                  ),
                  const Text(
                    'Set your credintials below !',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: height * 0.06,
                  ),
                  TextFormField(
                    controller: txtusername,
                    decoration: const InputDecoration(
                      labelText: 'Set your username',
                      hintText: 'Username',
                      prefixIcon: Icon(Icons.person),
                      fillColor: color,
                      focusColor: color,
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: color)),
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: color)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: color)),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  TextField(
                    controller: txtusername,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Set your password',
                      hintText: 'Username',
                      prefixIcon: Icon(Icons.lock),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: color)),
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: color)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: color)),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  SizedBox(
                      width: width,
                      height: 53,
                      child: OutlinedButton(
                        onPressed: null,
                        child: const Text(
                          'Sign In',style: TextStyle(color: Colors.white,fontSize: 16),
                        ),style: OutlinedButton.styleFrom(backgroundColor: color),
                      
                      ))
                ],
              ))
            ],
          ),
        ),
      )),
    );
  }
}
