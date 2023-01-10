import 'package:flutter/material.dart';


class CardWidget extends StatelessWidget {

  final double heightDevice;
  final String iconCard;
  final String title;
  final String subtitle;
  final String? noData;

  const CardWidget({
    required this.heightDevice,
    required this.iconCard,
    required this.title,
    required this.subtitle,
    this.noData
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: heightDevice * 0.26,
      decoration: BoxDecoration(
        color: Color(0xffFCFCFC),
        borderRadius: BorderRadius.circular(24.0)
      ),
      margin: EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(subtitle),
                Text(title,
                  style: TextStyle(fontWeight: FontWeight.bold,
                    fontSize: 28.0
                  ),
                ),
                (title == 'Sin datos') ? Text(noData.toString()) : Container()
              ],
            ),
          ),
          Image(
            image: AssetImage('assets/$iconCard'),
            width: 110.0,
            height: 110.0,
          )
        ],
      ),
    );
  }
}