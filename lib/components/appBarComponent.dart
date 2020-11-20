import 'package:flutter/material.dart';

class AppBarComponent extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  AppBarComponent({
    Key key,
    this.title,
  })  : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0
  @override
  _AppBarComponentState createState() => _AppBarComponentState();
}

class _AppBarComponentState extends State<AppBarComponent> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.title),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[600], Colors.purple[300]],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight
          ),
        ),
      ),
    );
  }
}
