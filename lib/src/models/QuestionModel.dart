// To parse this JSON data, do
//
//     final questionModel = questionModelFromJson(jsonString);

import 'dart:convert';

QuestionModel questionModelFromJson(String str) => QuestionModel.fromJson(json.decode(str));

String questionModelToJson(QuestionModel data) => json.encode(data.toJson());

class QuestionModel {
    QuestionModel({
        this.title,
        this.options,
    });

    String? title;
    List<Option>? options;

    factory QuestionModel.fromJson(Map<String, dynamic> json) => QuestionModel(
        title: json["title"],
        options: List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
    );

    Map<String, dynamic> toJson() {
      final opc = options as List<Option>;
      return {
          "title": title,
          "options": List<dynamic>.from(opc.map((x) => x.toJson())),
      };
    } 
}

class Option {
    Option({
        this.id,
        this.title,
    });

    int? id;
    String? title;

    factory Option.fromJson(Map<String, dynamic> json) => Option(
        id: json["id"],
        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
    };
}