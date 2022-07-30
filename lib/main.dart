import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
void main() {
  runApp(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    ));
}


enum Unity {
  uni,
  kg,
  g,
  L,
  mL
}

class Item {
  final String name;
  final String qtdd;
  final Unity unity;
  final String id;
  bool isChecked;

  Item({required this.name, required this.qtdd, required this.unity}) : id = const Uuid().v4(), isChecked = false;

  @override bool operator ==(covariant Item other) => id == other.id;
  
  @override int get hashCode => id.hashCode;
  
  void changeCheck() {
    isChecked = !isChecked;
  }

  @override
  String toString() {
    return "$qtdd $unity de $name";
  }

}

class ShopList extends ChangeNotifier{
  final List<Item> _itemList = [];
  UnmodifiableListView<Item> get list => UnmodifiableListView(_itemList);


  void addItem(Item item) {
    _itemList.add(item);
    notifyListeners();
  }

  void removeItem(Item item) {
    _itemList.remove(item);
    notifyListeners();
  }

  void clearList() {
    _itemList.clear();
    notifyListeners();
  }

}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
    );
  }
}