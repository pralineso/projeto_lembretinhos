import 'package:flutter/material.dart';
import 'package:projeto_lembretinhos/ui/home_page.dart';
import 'package:flare_flutter/flare_actor.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       // title: Text("Lembretinhos", style: TextStyle( fontSize: 24)),
        backgroundColor: Colors.deepPurpleAccent,
      ),
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
