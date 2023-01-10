import 'package:burnout/src/user_preferences/user_preferences.dart';
import 'package:flutter/material.dart';

class SetNamePage extends StatefulWidget {
  const SetNamePage({super.key});

  @override
  State<SetNamePage> createState() => _SetNamePageState();
}

class _SetNamePageState extends State<SetNamePage> {
  TextEditingController? _textController;
  final _prefs = new UserPreferences();
  bool _guardando = false;
  bool rigthPath = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textController = new TextEditingController(
      text: _prefs.nombre,
    );
  }

  @override
  Widget build(BuildContext context) {
  final double widthDevice = MediaQuery.of(context).size.width;
  return Scaffold(
    body: Stack(
        children: <Widget>[
          _fondoTest(),
          _bodyTest(widthDevice, context)
        ],
      ),
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
                  Text('Hola!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 38.0,
                      fontFamily: 'Roboto',
                      decoration: TextDecoration.none
                    ),
                  ),
                  SizedBox(height: 40.0,),
                  Text('Nos gutaria conocerte más',
                    style: TextStyle(
                      color: Color(0xff96A7AF),
                      fontSize: 20.0,
                      fontFamily: 'Roboto',
                      decoration: TextDecoration.none
                    ),
                  ),
                ],
              ),
            ),
            _editName(context),
            _submitButton(context),
          ],
        ),
      ),
    );
  }

  Widget _submitButton(BuildContext context) {
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: Color(0xff3ED598),    
      minimumSize: Size(double.infinity, 46),
      padding: EdgeInsets.symmetric(horizontal: 26),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
    );
    return ElevatedButton.icon(
      style: raisedButtonStyle,
      onPressed: (!_guardando && rigthPath) ? _submit : null,
      label: Text('Guardar'),
      icon: Icon(Icons.save),
    );
  }
  
  void _submit() async {
    _prefs.nombre = (_textController?.value.text).toString();
    setState(() {
      _guardando = true;
    });
    print(_prefs.nombre);
    mostrarSnackbar('Nombre guardado');
    _prefs.deafultRoute = 'home';
    print(_prefs.deafultRoute);
    Navigator.pushReplacementNamed(context,'home');

  }
  
  void mostrarSnackbar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    );


    setState(() {
      _guardando = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  } 

  Widget _editName(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        hintColor: Colors.white,
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.white)
        )
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 20.0),
        child: TextField(
          style: TextStyle(
            color: Colors.white
          ),
          controller: _textController,
          decoration: InputDecoration(
            labelText: 'Cual es tu Nombre?',
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              //  when the TextFormField in unfocused 
            ) ,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              //  when the TextFormField in focused 
            ) ,
          ),
          onChanged: (value){
            if(value.length > 0) {
              setState(() {
                rigthPath = true;
              });
            } else {
              setState(() {
                rigthPath = false;
              });
            }
          },
        ),
      ),
    );
  }
} 