import 'package:app/widgets/auth/signin.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Signin()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 18,
          children: [
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(50),
              child: Image.asset('profile.jpg', width: 80, height: 80),
            ),
            Text("Toko Jokowi", style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
