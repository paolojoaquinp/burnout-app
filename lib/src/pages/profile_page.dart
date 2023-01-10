import 'package:burnout/src/user_preferences/user_preferences.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _prefs = new UserPreferences();

  @override
  Widget build(BuildContext context) {
    final heightProfile = MediaQuery.of(context).size.height;
    final widthProfile = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _fondoProfile(),
          SafeArea(
            child: Column(
              children: <Widget>[
                _headerProfile(heightProfile),
                _dataProfile(context, heightProfile),
              ],
            ),
          ),
    
        ]
      ),
      floatingActionButton: _editButton(context,widthProfile),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _headerProfile(double heightDevice) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: heightDevice * 0.25,
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _profilePic()
        ],
      ),
    );
  }

  Widget _profilePic() {
    return Container(
      width: 80.0,
      height: 80.0,
      alignment: Alignment.center,
      child: Text((_prefs.nombre.length > 0) ? _prefs.nombre[0] : '',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 28.0,
          color: Colors.white
        )
      ),
      decoration: BoxDecoration(
        color: Color.fromRGBO(68, 121, 255, 1),
        borderRadius: BorderRadius.circular(10.0)
      ),
    );
  }

  Widget _dataProfile(BuildContext context, double heightProfile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Nombre',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0
            ),
          ),
          Text(_prefs.nombre,
            style: TextStyle(fontSize: 24.0),
          ),
          SizedBox(height: 20.0,),
          TextButton(
            onPressed: (){
              Navigator.pushNamed(context, 'list-results');
            },
            child: Row(
              children: <Widget>[
                Text('Ver mis examenes',
                  style: TextStyle(color: Colors.black87),
                ),
                SizedBox(width: 4.0,),
                Icon(Icons.more_horiz_rounded,size: 20.0,)
              ],
            ),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(0.0)
            ),
          ),
        ],
      ),
    );
  }

  Widget _fondoProfile() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Color.fromRGBO(68, 121, 255, 0.4),
    );
  }

  Widget _editButton(BuildContext context, double widthDevice) {
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: Color(0xff286053),    
      minimumSize: Size(widthDevice * 0.9, 46),
      padding: EdgeInsets.symmetric(horizontal: 26),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(6.0)),
      ),
    );
    return ElevatedButton(
      style: raisedButtonStyle,
      onPressed: () {
        Navigator.pushNamed(context, 'edit');
      },
      child: Text('Editar información',
        style: TextStyle(color: Color(0xff3DD598))
      ),
    );
  }
}