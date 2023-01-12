import 'package:burnout/src/models/TestModel.dart';
import 'package:burnout/src/providers/db_provider.dart';
import 'package:intl/intl.dart';

int isBurnOut(List<Result> results) {
  int cWithout = 0;
  int cWith = 0;
  results.forEach((element) {
    if(element.idQuestion != 4) { 
      if((element.idSelection as int) >= 4) { cWith++; } else { cWithout++; }
    } else {
      if((element.idSelection as int) >= 3) { cWith++; } else { cWithout++; }
    }
  });
  return cWithout > cWith ? 0 : 1;
}

Future<bool?> analyticsYesterday() async {
  final tests = await DBProvider.db.obtenerTestsAyer();
  if(tests.isNotEmpty) {
    int cBurnout = 0;
    int cNotBurn = 0;
    tests.forEach((el) {
      if(el.isBurnout == 1) { cBurnout++; } else { cNotBurn++; }
    });
    return (cBurnout >= cNotBurn) ? true : false;
  } else {
    return null;
  }
}

Future<bool?> analyticsPerWeek() async {
  final date = DateTime.now();
  final tests = await DBProvider.db.obtenerTestsUltimaSemana();
  if(tests.isNotEmpty && (date.weekday == 7)) {
    int cBurnout = 0;
    int cNotBurn = 0;
    tests.forEach((el) {
      if(el.isBurnout == 1) { cBurnout++; } else { cNotBurn++; }
    });
    return (cBurnout >= cNotBurn) ? true : false;
  } else {
    return null;
  }
}

Future<bool?> analyticsPerMonth() async {
  final date = DateTime.now();
  final tests = await DBProvider.db.obtenerTestsUltimoMes();
  if(tests.isNotEmpty && (date.day == 1)) {
    int cBurnout = 0;
    int cNotBurn = 0;
    tests.forEach((el) {
      if(el.isBurnout == 1) { cBurnout++; } else { cNotBurn++; }
    });
    return (cBurnout >= cNotBurn) ? true : false;
  } else {
    return null;
  }
}