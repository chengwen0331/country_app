import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'countryapp.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness:Brightness.light,
        primarySwatch: Colors.amber,
      ),
      home: const SplashPage()
    );
  }
}

  class SplashPage extends StatefulWidget {
    const SplashPage({super.key});

    @override
    State<SplashPage> createState() => _SplashPageState();
  }

  class _SplashPageState extends State<SplashPage> {

    @override
    void initState() {
      super.initState();
      Timer(
          const Duration(seconds: 3),
          () {
            Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (content) => const CountryApp()));}
      );
    }

    @override
    Widget build(BuildContext context){
      return Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height:double.infinity,
            width:double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.red,
                  Colors.yellow
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              )
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[
                Image.asset('assets/app_logo.png', scale: 1.5,),
                const SizedBox(height:16),
                Text(
                  'COUNTRY INFO SEARCHING APP',
                  style:GoogleFonts.arvo(
                    fontSize: 15, 
                    fontStyle: FontStyle.italic,
                    textStyle: const TextStyle(
                      letterSpacing: 0.5, 
                      color: Colors.black,
                      decoration: TextDecoration.none
                    )
                  ),
                ),
                Container(
                  height:100,
                  alignment: Alignment.bottomCenter,
                  child: const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                )
              ],
            )
          ),
        ],
      );
    }
  }
