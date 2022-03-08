import 'package:flutter/material.dart';
import 'package:forecast/utils/colors.dart';
class SplashScreen extends StatelessWidget {
  const SplashScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: primaryColor,
      body: Center(child: CircularProgressIndicator(color: Colors.white,),),
    );
  }
}
