import 'package:burnout/src/models/QuestionModel.dart';
import 'package:flutter/material.dart';

typedef void handleParent(int? val);

class ItemQuestionWidget extends StatelessWidget {

  final double heightParent;
  final Option? option;
  final handleParent handleSelected;
  final int? opcSelected;
  const ItemQuestionWidget({
    required this.heightParent,
    required this.handleSelected,
    this.option,
    this.opcSelected
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.only(bottom:2.0,left: 6.0,right: 0,top: 6.0),
      ),
      key: UniqueKey(),
      onPressed: () {
        handleSelected(option?.id);
      },
      child: Container(
        height: heightParent * 0.073,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: (opcSelected == option?.id) ? Colors.white : Colors.transparent,
            width: 1.0
          )
        ),
        child: Row(
          children: <Widget>[
            _detailItem(context,option?.id),
            SizedBox(width: 15.0,),
            Text((option?.title).toString(),
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w300,
                color: Colors.white,
                decoration: TextDecoration.none,
                fontSize: 20.0
              ),
            )
          ],
        )
      ),
    );
  }
  
  Widget _detailItem(BuildContext context, int? numStep) {
    final widthWidget = MediaQuery.of(context).size.width;
    return Container(
      height: double.infinity,
      width: widthWidget * 0.1,
      alignment: Alignment.center,
      child: Text(numStep.toString(),
        style: TextStyle(
          fontSize: 20.0,
          color: Colors.white,
          decoration: TextDecoration.none
        ),
        textAlign: TextAlign.center,
      ),
      decoration: BoxDecoration(
        color: Color(0xff4479FF),
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}