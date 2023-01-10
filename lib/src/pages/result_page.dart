import 'package:burnout/src/models/ArgumentsModel.dart';
import 'package:burnout/src/models/QuestionModel.dart';
import 'package:burnout/src/models/TestModel.dart';
import 'package:burnout/src/providers/db_provider.dart';
import 'package:burnout/src/providers/question_provider.dart';
import 'package:flutter/material.dart';


class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final advice = 'Es importante que busques ayuda profesional. Un psicólogo o un terapeuta pueden ayudarte a identificar las causas del burnout y a encontrar maneras de manejar el estrés y la fatiga. Además, es importante que tomes tiempo para descansar y relajarte, y que trates de encontrar un equilibrio entre tu vida laboral y personal.';
  
  @override
  Widget build(BuildContext context) {    
    final ArgumentsResume args = ModalRoute.of(context)?.settings.arguments as ArgumentsResume;
    final List<Result> results = args.results;
    final int isBurnout = args.isBurnout;
    final double heightDevice = MediaQuery.of(context).size.height;
    
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            _fondoResults(),
            _bodyResults(heightDevice, results, isBurnout),
          ],
        ),
        floatingActionButton: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.0),
          child: _submitButton()
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget _fondoResults() {
    final gradiente = Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: FractionalOffset(0.2,00),
          end: FractionalOffset(1.0,0.9),
          colors: [
            Color(0xff141F6D),
            Color(0xff000116),
          ]
        )
      ),
    );
    return gradiente;
  }

/*   Future<List<Result>> obtenerResults(String testId) async {
    results = await DBProvider.db.getResults(testId);
    return results;
  } */

  Widget _bodyResults(double heightDevice, List<Result> results, int isBurnout) {
    return Column(
        children: <Widget>[
          _assetResult(heightDevice, isBurnout),
          _infoResult(results, isBurnout),
          (isBurnout==1) ? Container(
            margin: EdgeInsets.only(top: 25.0),
            padding: EdgeInsets.symmetric(horizontal: 26.0),
            child: Text(advice,
              textAlign: TextAlign.justify,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            )
          ) : Container()
        ],
      );
  }

  Widget _assetResult(double heightDevice, int isBurnout) {
    return Container(
      width: double.infinity,
      height: heightDevice * 0.3,
      child: Image(
        image: (isBurnout==0) ? AssetImage('assets/success-icon.png') : AssetImage('assets/burnout-icon.png'),
      ),
    );
  }

  Widget _submitButton() {
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      minimumSize: Size(double.infinity, 36),
      backgroundColor: Colors.green,
      padding: EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
    );
    return ElevatedButton(
      style: raisedButtonStyle,
      onPressed: () {
        Navigator.pushReplacementNamed(context, 'list-results');
      },
      child: Text('Ir a inicio'),
    );
  }

  Widget _infoResult(List<Result> results, int isBurnout) {
    final styleText = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 20.0
    );
    return Column(
      children: [
        Text((isBurnout==0) ? 'No tienes Burnout!' : 'Tienes Burnout!',
          style: styleText
        ),
        Container(
          margin: EdgeInsets.only(top: 40.0),
          height: 45.0,
          child: _resultsBar(results)
        )
      ],
    );
  }
  

  Widget _resultsBar(List<Result> results) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) {
          return SizedBox(width: 6.0);
      },
      itemCount: results.length, 
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int i) {
        final result = results[i] as Result;
        if(result.idQuestion != 10) {
          return Container(
            color: (result.idSelection as int) >= 4 ? Colors.red : Colors.green,
            width: 24.0,
          );
        } else {
          return Container(
            color: (result.idSelection as int) >= 3 ? Colors.red : Colors.green,
            width: 24.0,
          );
        }
      },
    );
  }
}