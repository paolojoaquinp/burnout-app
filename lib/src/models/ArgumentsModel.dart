import 'package:burnout/src/models/TestModel.dart';

class Arguments {
  final TestModel test;
  final List<Result> result;

  Arguments(this.test, this.result);
}

class ArgumentsResume {
  final List<Result> results;
  final int isBurnout;

  ArgumentsResume(this.results, this.isBurnout);
}