import 'package:burnout/src/models/ArgumentsModel.dart';
import 'package:burnout/src/models/QuestionModel.dart';
import 'package:burnout/src/providers/db_provider.dart';
import 'package:burnout/src/providers/question_provider.dart';
import 'package:burnout/src/utils/utils.dart' as utils;
import 'package:burnout/src/widgets/item_question.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  var uuid = Uuid();
  int indexQuestion = 0;
  bool isLoading = false;
  int? opcSelected;
  TestModel testModel = new TestModel();
  List<Result> resultsModel = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    setState(() {
      testModel.date = (DateTime.now()).toString();
      testModel.id = uuid.v4();
    });
  }

  void _handleSelected (int? newValue) {
    setState(() {
      opcSelected = newValue;
    });
  }

  void _clearSelected() {
    setState(() {
      opcSelected = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double widthDevice = MediaQuery.of(context).size.width;
    final double heightDevice = MediaQuery.of(context).size.height;

    return Stack(
      children: <Widget>[
        _fondoQuestion(),
        _titleQuestion(widthDevice, heightDevice),
        AnimatedOpacity(
          opacity: !isLoading ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: _bodyQuestion(widthDevice, heightDevice, context)
        ),
        Positioned(
          bottom: 0.0,
          child: Container(
            height: heightDevice * 0.2,
            width: widthDevice,
            padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 10.0),
            color: Color(0xff141F6D),  
            child: Column(children: <Widget>[
              _nextButton(context),
              SizedBox(height: 10.0),
              _prevButton(context)
            ]),
          ),
        )
      ],
    );
  }

  Widget _fondoQuestion() {
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

  Widget _bodyQuestion(double widthDevice, double heightDevice, BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(left: 24.0,right: 24.0, bottom: 20.0, top: 10.0),
        margin: EdgeInsets.only(top: heightDevice * 0.20),
        height: heightDevice * 0.6, 
        child: _lista(heightDevice)
      ),
    );
  }

  Widget _lista(double heightDevice) {
    return FutureBuilder(
      future: questionProvider.loadQuestion(indexQuestion),
      builder: (BuildContext context, AsyncSnapshot<QuestionModel> snapshot) {
        final opc = snapshot.data?.options; 
        return ListView.builder(
          itemCount: opc?.length,
          itemBuilder: (context, i) {
            return ItemQuestionWidget(
              heightParent: heightDevice,
              option: opc?[i],
              handleSelected: _handleSelected,
              opcSelected: opcSelected
            );
          },
        );
      },
    );
  }

  Widget _titleQuestion(double widthDevice, double heightDevice) {
    return FutureBuilder(
      future:questionProvider.loadQuestion(indexQuestion),
      builder: (BuildContext context, AsyncSnapshot<QuestionModel> snapshot) {
        final question = snapshot.data as dynamic;
        return _title(heightDevice,widthDevice, (question?.title).toString());
      },
    );
  }

  Widget _title(double heightDevice, double widthDevice, String title) {
    return Positioned(
      top: 0.0,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 20.0,bottom: 15.0, left: 24.0),
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: Color(0xff40DF9F),
                borderRadius: BorderRadius.circular(12.0)
              ),
              child: Text('$indexQuestion de 10',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.none,
                  fontSize: 16.0,
                ),
              ),
            ),
            Container(
              height: heightDevice * 0.1,
              width: widthDevice,
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              alignment: Alignment.center,
              child: Text(title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                  fontSize: 22.0,
                )
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nextButton(BuildContext context) {
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
      onPressed: (indexQuestion >= 10) ? 
        (opcSelected != null) ? () {
            final isBo = utils.isBurnOut(resultsModel);
            setState(() {
              testModel.isBurnout = isBo;
              final tempResult = new Result(
                id: uuid.v4(),
                idTest: testModel.id,
                idQuestion: indexQuestion,
                idSelection: opcSelected
              );
              resultsModel.add(tempResult);
            });
            Navigator.pushReplacementNamed(context, 'resume', arguments: Arguments(testModel, resultsModel));
          } : null
      : (opcSelected != null && !isLoading) ? () async {
        setState(() {
          isLoading = true;
        });
        print(isLoading);
        await Future.delayed(
          Duration(milliseconds: 500),
          _saveData
        );
        _clearSelected();
        print(resultsModel);
      } : null,
      child: Text((indexQuestion >= 10) ? 'Analizar respuestas' : 'Siguiente pregunta'),
    );
  }
  _saveData() {
    setState(() {
      final tempResult = new Result(
        id: uuid.v4(),
        idTest: testModel.id,
        idQuestion: indexQuestion,
        idSelection: opcSelected
      );
      resultsModel.add(tempResult);
      indexQuestion +=1;
      isLoading = false;
    });
    print(isLoading);
  }
  _prevButton(BuildContext context) {
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: Color(0xffDB5461),    
      minimumSize: Size(double.infinity, 46),
      padding: EdgeInsets.symmetric(horizontal: 26),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
    );
    return ElevatedButton(
      style: raisedButtonStyle,
      onPressed: (indexQuestion <= 0) ? () {
        Navigator.pop(context);
      } : !isLoading ? _handleBackButton : null,
      child: Text((indexQuestion <= 0) ? 'Volver a inicio' : 'Atras',
        style: TextStyle(color: Colors.white)
      ),
    );
  }
  _handleBackButton() async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(
      Duration(milliseconds: 500),
      () {
        setState(() {
          indexQuestion -=1;
          resultsModel.removeLast();
          _clearSelected();
          isLoading = false;
        });
      }
    );
  }
}
