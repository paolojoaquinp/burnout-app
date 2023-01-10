import 'package:shared_preferences/shared_preferences.dart';

/*
  Recordar instalar el paquete de:
    shared_preferences:
  Inicializar en el main
    final prefs = new PreferenciasUsuario();
    await prefs.initPrefs();
    
    Recuerden que el main() debe de ser async {...
*/

class UserPreferences {

  static final UserPreferences _instancia = new UserPreferences._internal();

  factory UserPreferences() {
    return _instancia;
  }

  UserPreferences._internal();

  SharedPreferences? _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  // GET y SET del nombre
  String get nombre {
    return _prefs?.getString('nombre') ?? '';
  }

  set nombre( String value ) {
    _prefs?.setString('nombre', value);
  }
  

  // GET y SET de la última página
  int get paginaActual {
    return _prefs?.getInt('paginaActual') ?? 0;
  }

  set paginaActual(int value ) {
    _prefs?.setInt('paginaActual', value);
  }


  // GET y SET de la ruta por default
  String get deafultRoute {
    return _prefs?.getString('deafultRoute') ?? 'on-boarding';
  }

  set deafultRoute(String value ) {
    _prefs?.setString('deafultRoute', value);
  }
}
