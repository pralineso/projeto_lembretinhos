import 'package:flutter/material.dart';
import 'package:projeto_lembretinhos/ui/home_page.dart';
import 'package:flare_flutter/flare_actor.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 200,
          height: 200,
          child: FlareActor("assets/AnimacaoS2.flr", animation: "pulse"),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 10)).then((_){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
    });


  }
}
