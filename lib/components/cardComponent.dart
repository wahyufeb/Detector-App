import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BuildCardApp extends StatelessWidget {
  IconData icon;
  String title;
  String desc;
  final page;

  BuildCardApp({
    Key key,
    this.icon,
    this.title,
    this.desc,
    this.page,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10, top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 8.0),
            blurRadius: 20.0,
            color: Color(0x7090B0).withAlpha(51),
            // spreadRadius: 2.0,
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Center(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Text(
                        desc,
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return page;
                            }),
                          );
                        },
                        child: Text(
                          "Coba",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        color: Colors.purple[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side:
                              BorderSide(color: Colors.purple[200], width: 2.0),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
