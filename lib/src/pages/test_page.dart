import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double widthDevice = MediaQuery.of(context).size.width;

    return Stack(
      children: <Widget>[
        _fondoTest(),
        _bodyTest(widthDevice, context)
      ],
    );
  }
  
  Widget _fondoTest() {
    final gradiente = Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: FractionalOffset(0.2,00),
          end: FractionalOffset(1.0,0.9),
          colors: [
            Color(0xff000116),
            Color(0xff141F6D),
          ]
        )
      ),
    );
    return gradiente;
  }
  
  Widget _bodyTest(double widthDevice, BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.only(left: 24.0,right: 24.0, top: 80.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: widthDevice * 0.7,
              margin: EdgeInsets.only(bottom: 34.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Empezar cuestionario',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 38.0,
                    ),
                  ),
                  SizedBox(height: 40.0,),
                  Text('Son 15 preguntas de seleccion multiple que pueden ser respondidas en una media de 5 min.',
                    style: TextStyle(
                      color: Color(0xff96A7AF),
                      fontSize: 20.0,
                    ),
                  ),
                ],
              ),
            ),
            _startButton(context),
          ],
        ),
      ),
    );
  }
  
  Widget _startButton(BuildContext context) {
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: Color(0xff3ED598),    
      minimumSize: Size(double.infinity, 46),
      padding: EdgeInsets.symmetric(horizontal: 26),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
    );
    return ElevatedButton(
      style: raisedButtonStyle,
      onPressed: () {
        Navigator.pushNamed(context, 'question');
      },
      child: Text('Presiona para comenzar el test'),
    );
  }
}