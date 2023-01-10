
import 'package:burnout/src/providers/db_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListResultsPage extends StatelessWidget {
  const ListResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 209, 218, 240),
        appBar: AppBar(
          backgroundColor: Color(0xff141F6D),
          title: Text('Resultados de Tests'),
        ),
        body: _listTests()                 
    );
  }
  
  
  Widget _listTests() {
    return FutureBuilder(
      future: DBProvider.db.obtenerTestsUltimoMes(),
      builder: (BuildContext context, AsyncSnapshot<List<TestModel>> snapshot) {
        if(snapshot.hasData) {
          final tests = snapshot.data as dynamic;
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: tests.length,
            itemBuilder: (context, i) => _buildItem(tests[i], context, i)
          );
        } else {
          return Center(child: CircularProgressIndicator(),);
        }
      }
    );
  }
  
  String getDate(String date) {
    DateTime dt = DateTime.parse(date);
    String formattedDate = DateFormat('MM-dd-yyyy HH:mm').format(dt);
    return formattedDate;
  }

  Widget _buildItem(TestModel test, BuildContext context, int index) {
    return Dismissible( 
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      onDismissed: (direction) async {
        DBProvider.db.deleteTest(test.id.toString());
      },
      child: Column(
        children: [
          ListTile(
            title: Text('${index+1}.- Test - ${(test.isBurnout==1) ? 'Con Burnout' : 'Sin Burnout'}'),
            subtitle: Text('Fecha: ${getDate(test.date as String)}'),
            trailing: Container(
              child: Image(
                image: (test.isBurnout==0) ? AssetImage('assets/success-icon.png') : AssetImage('assets/burnout-icon.png'),
              ),
              decoration: BoxDecoration(
                color: Color(0xff141F6D),
                borderRadius: BorderRadius.circular(10.0)
              ),
            )
          ),
          Divider()
        ],
      ),
    );
  }
} 