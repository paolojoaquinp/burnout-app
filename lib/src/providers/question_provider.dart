
import 'dart:convert';

import 'package:burnout/src/models/QuestionModel.dart';
import 'package:flutter/services.dart';

class _QuestionProvider {

  List<dynamic> questions = [];
  
  
  Future<QuestionModel> loadQuestion(int numQuestion) async {
    final response = await rootBundle.loadString('data/initialData.json');
    final Map<String, dynamic> dataMap = json.decode(response);
    questions = dataMap['questions'];
    final List<QuestionModel> questionsList = [];
    if(dataMap == null) return QuestionModel();

    questions.forEach((question) {
      final questionTemp = QuestionModel.fromJson(question as Map<String, dynamic>);
      questionsList.add(questionTemp);
    });

    return questionsList[numQuestion];
  }
}


final questionProvider = new _QuestionProvider();