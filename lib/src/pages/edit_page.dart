import 'package:burnout/src/user_preferences/user_preferences.dart';
import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  String? _nombre;
  bool _guardando = false;


  TextEditingController? _textController;
  final _prefs = new UserPreferences();

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff141F6D),
        title: Text('Editar Información'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: <Widget>[
            _titleEdit(),
            _editName(),
            SizedBox(height: 24.0,),
            _botonSubmit()
          ],
        ),
      ),
    );
  }

  Widget _titleEdit() {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      width: double.infinity,
      child: Text('Configuraciones',
        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
      )
    );
  }

  Widget _editName() {
    return Container(
      child: TextField(
        controller: _textController,
        decoration: InputDecoration(
          labelText: 'Nombre',
          helperText: 'Nombre de usuario'
        ),
        onChanged: (value){
          
        },
      ),
    );
  }

  Widget _botonSubmit() {
    final ButtonStyle btnStyle = ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      backgroundColor: Color(0xff141F6D),
      minimumSize: Size(double.infinity, 40.0)
    );
    return ElevatedButton.icon(
      label: Text('Guardar'),
      style: btnStyle,
      icon: Icon(Icons.save),
      onPressed: !_guardando ? _submit : null,
    );
  }

  void _submit() async {
    _prefs.nombre = (_textController?.value.text).toString();
    setState(() {
      _guardando = true;
    });
    print(_prefs.nombre);
    mostrarSnackbar('Guardado');
    Navigator.pop(context);

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
}