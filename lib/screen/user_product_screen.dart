import 'package:flutter/material.dart';

class UserProductScreen extends StatelessWidget {
  const UserProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.add))],
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
        itemcount :   ,
        itemBuilder: itemBuilder),
      ),
    );
  }
}
