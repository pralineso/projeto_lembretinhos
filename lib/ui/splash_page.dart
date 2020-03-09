import 'package:flutter/cupertino.dart';
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
      backgroundColor: Colors.deepPurple[600],
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Lembretinhos",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white, ),

            ),
            Container(
                width: 400,
                height: 400,
                child: FlareActor("assets/BobMinion.flr", animation: "Dance"),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 5)).then((_){
      _showHomepage();
    });
  }

  void _showHomepage(){
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
  }
}
