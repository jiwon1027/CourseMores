import 'package:flutter/material.dart';
import './make2.dart';

class EditItemPage extends StatelessWidget {
  const EditItemPage({Key? key, required this.item}) : super(key: key);

  final ItemData item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item 수정하기'),
      ),
      body: Center(
        child: Text('수정할 Item: ${item.title}'),
      ),
    );
  }
}
