import 'package:burnout/src/pages/profile_page.dart';
import 'package:burnout/src/pages/test_page.dart';
import 'package:burnout/src/providers/db_provider.dart';
import 'package:burnout/src/user_preferences/user_preferences.dart';
import 'package:burnout/src/utils/utils.dart' as utils;
import 'package:burnout/src/widgets/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _prefs = new UserPreferences();
  
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es');
  }
  @override
  Widget build(BuildContext context) {
    final double heightDevice = MediaQuery.of(context).size.height;
    final double heightBottomNavBar = heightDevice * 0.08;
    
    return Scaffold(
      body: _callPage(currentIndex, heightDevice),
      bottomNavigationBar: SizedBox(
        height: heightBottomNavBar,
        child: _bottomNavigationBar(context)  
      ),
    );
  }
  Widget _callPage(int currentPage, double heightDevice) {
    switch (currentPage) {
      case 0:
        return _homePage(heightDevice);
      case 1:
        return TestPage();
      case 2:
        return ProfilePage();
      default:
        return _homePage(heightDevice);
    }
  }

  Widget _homePage(double heightDevice) {
    return Stack(
        children: <Widget>[
          _fondoApp(),
          Column(
            children: <Widget>[
              _headerHomePage(heightDevice),
              _bodyHomePage(heightDevice),
            ],
          ),
        ],
      );
  }

  Widget _headerHomePage(double heightDevice) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.0,vertical: heightDevice * 0.02), // 2%
        color: Colors.white,
        width: double.infinity,
        height: heightDevice * 0.3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CircleAvatar(
                  child: Image(
                    image: AssetImage('assets/icon-burnout.png')
                  )
                ),
                CircleAvatar(
                  child: Text((_prefs.nombre.length > 0) ? _prefs.nombre[0] : ''),
                ),
              ],
            ),
            SizedBox(height: 15.0,),
            Text('Hola ${(_prefs.nombre.length > 0) ? _prefs.nombre.split(' ').first : ''}!',
              style: TextStyle(fontSize: 22.0),
            ),
            SizedBox(height: 5.0,),
            Text('Como te sientes hoy?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26.0
              ),
            ),
            _testButton(context, heightDevice)
          ],
        ),
      ),
    );
  }

  Widget _testButton(BuildContext context, double heightDevice) {
    final width = MediaQuery.of(context).size.width;  
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: Color(0xff3ED598),
      minimumSize: Size(width, heightDevice * 0.045),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
    );
    return ElevatedButton(
      style: raisedButtonStyle,
      onPressed: () {
        Navigator.pushNamed(context, 'question');
      },
      child: Container(
        width: width,
        child: Text('Click para averiguar!',
        textAlign: TextAlign.center,)
      ),
    );
  }

  Widget _bodyHomePage(double heightDevice) {
    final heightBody = heightDevice * 0.58;
    return Container(
      color: Colors.transparent,
      width: double.infinity,
      height: heightBody,
      padding: EdgeInsets.only(right: 24.0, left: 24.0, top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          FutureBuilder(
            future: utils.analyticsYesterday(),
            builder: (BuildContext context, AsyncSnapshot<bool?> snapshot) {
              if(!snapshot.hasData) {
                /* final isBurnout = snapshot.data as bool; */
                final isBurnout = true;
                return CardWidget(
                  heightDevice: heightBody,
                  iconCard: isBurnout ? 'burnout-icon.png' : 'success-icon.png',
                  subtitle: 'Ayer estuviste con:',
                  title: isBurnout ? 'Burnout' : 'Bien',
                );
              } else {
                return CardWidget(
                  heightDevice: heightBody,
                  iconCard: 'no-data-icon.png',
                  subtitle: 'Ayer estuviste con:',
                  title: 'Sin datos',
                  noData: 'Disponible en 1 dia',
                );
              }
            }
          ),
          FutureBuilder(
            future: utils.analyticsPerWeek(),
            builder: (BuildContext context, AsyncSnapshot<bool?> snapshot) {
              if(!snapshot.hasData) {
                /* final isBurnout = snapshot.data as bool; */
                final isBurnout = false;
                return CardWidget(
                  heightDevice: heightBody,
                  iconCard: isBurnout ? 'burnout-icon.png' : 'success-icon.png',
                  subtitle: 'La semana pasada',
                  title: isBurnout ? 'Burnout' : 'Bien',
                );
              } else {
                return CardWidget(
                  heightDevice: heightBody,
                  iconCard: 'no-data-icon.png',
                  subtitle: 'La semana pasada:',
                  title: 'Sin datos',
                  noData: 'Disponible en ${7 - DateTime.now().weekday} dia(s)',
                );
              }
            }
          ),
          FutureBuilder(
            future: utils.analyticsPerMonth(),
            builder: (BuildContext context, AsyncSnapshot<bool?> snapshot) {
              if(snapshot.hasData) {
                final isBurnout = snapshot.data as bool;
                return CardWidget(
                  heightDevice: heightBody,
                  iconCard: isBurnout ? 'burnout-icon.png' : 'success-icon.png',
                  subtitle: 'El mes pasado',
                  title: isBurnout ? 'Burnout' : 'Bien',
                );
              } else {
                return CardWidget(
                  heightDevice: heightBody,
                  iconCard: 'no-data-icon.png',
                  subtitle: 'El mes pasado',
                  title: 'Sin datos',
                  noData: 'Disponible el 1 de ${getNextMonth()}',
                );
              }
            }
          ),
        ],
      ),
    );
  }
  getNextMonth() {
    final now = DateTime.now();
    final nextMonth = now.month == 12 ? 1 : now.month + 1;
    DateTime nextMonthDate = DateTime(now.year, nextMonth, now.day);
    final dateFormat = DateFormat.MMMM('es');
    final nextMonthName = dateFormat.format(nextMonthDate);
    return nextMonthName.toUpperCase();
  }

  Widget _bottomNavigationBar(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Color(0xff141F6D),
      ),
      child: BottomNavigationBar(
        unselectedItemColor: Colors.white,
        selectedItemColor: Color(0xff4479FF),
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Examén',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_outlined),
            label: 'Mis datos'
          ),
        ],
        currentIndex: currentIndex
      ),
    );
  }
  
  Widget _fondoApp() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Color.fromRGBO(68, 121, 255, 0.4),
    );
  }
}