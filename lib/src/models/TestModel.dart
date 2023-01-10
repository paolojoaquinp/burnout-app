// To parse this JSON data, do
//
//     final testModel = testModelFromJson(jsonString);

import 'dart:convert';

TestModel testModelFromJson(String str) => TestModel.fromJson(json.decode(str));

String testModelToJson(TestModel data) => json.encode(data.toJson());

class TestModel {
    TestModel({
        this.id,
        this.date,
        this.isBurnout,
    });

    String? id;
    String? date;
    int? isBurnout;

    factory TestModel.fromJson(Map<String, dynamic> json) => TestModel(
        id: json["id"],
        date: json["date"],
        isBurnout: json["isBurnout"]
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "date": date,
        "isBurnout": isBurnout
    };

}

class Result {
    Result({
        this.id,
        this.idTest,
        this.idQuestion,
        this.idSelection,
    });

    String? id;
    String? idTest;
    int? idQuestion;
    int? idSelection;
    

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        idTest: json["idTest"],
        idQuestion: json["idQuestion"],
        idSelection: json["idSelection"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "idTest": idTest,
        "idQuestion": idQuestion,
        "idSelection": idSelection,
    };
}
