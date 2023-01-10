import 'dart:convert';

import 'package:burnout/src/models/ArgumentsModel.dart';
import 'package:burnout/src/models/QuestionModel.dart';
import 'package:burnout/src/providers/db_provider.dart';
import 'package:flutter/material.dart';
import 'package:burnout/src/providers/question_provider.dart';

class ResumePage extends StatelessWidget {

  const ResumePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Arguments args = ModalRoute.of(context)?.settings.arguments as Arguments;
    final TestModel test = args.test;
    final List<Result> results = args.result;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            _fondoResults(),
            SingleChildScrollView(
              child: _bodyResults(results)
            )
          ],
        ),
        floatingActionButton: _submitButton(context,test, results)
      ),
    );
  }

  _submitButton(BuildContext context, TestModel testPrepared, List<Result> results) {
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      minimumSize: Size(88, 36),
      backgroundColor: Colors.green,
      padding: EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
    );
    return ElevatedButton(
      style: raisedButtonStyle,
      onPressed: () async {
          Navigator.pushReplacementNamed(context, 'result', arguments: ArgumentsResume(results, testPrepared.isBurnout as int));
          await DBProvider.db.nuevoTest(testPrepared);
          for (Result res in results) {
            await DBProvider.db.nuevoResult(res);
          }
      },
      child: Text('Ver Resultados'),
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
            Color(0xff4479FF),
          ]
        )
      ),
    );
    return gradiente;
  }
  
  Widget _bodyResults(List<Result> results) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _textTitle(),
          Column(
            children: _createList(results)
          ),
        ],
      ),
    );
  }

  List<Widget> _createList(List<Result> results) {
    return results.map((e) {
      return _listQuestions(e);
    }).toList();
  }
  
  Widget _textTitle() {
    return Text('Respuestas',
      textAlign: TextAlign.start,
      style: TextStyle(
        fontSize: 28.0,
        color: Colors.white,
        fontWeight: FontWeight.bold
      ),
    );
  }
  
  Widget _listQuestions(Result res) {
    return FutureBuilder(
      future: questionProvider.loadQuestion(res.idQuestion ?? 0),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        QuestionModel? question = snapshot.data;
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 8.0),
          margin: EdgeInsets.symmetric(vertical: 5.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xff141F6D),
            borderRadius: BorderRadius.circular(12.0)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${res.idQuestion}.- ${question?.title}',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white
                ),
              ),
              _obtenerRespuesta(res.idSelection, (question?.options ?? []))
            ],
          )
        );
      }
    );
  }
  
  Widget _obtenerRespuesta(int? selected, List<Option>? options) {
    final opc = options as List<Option>;
    String text = '';
    for (var option in opc) {
      if(option.id == selected) { text = option.title as String; }
    }
    return Text(text,
      style: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w300,
        color: Colors.white
      ),
    );
  }
  

}