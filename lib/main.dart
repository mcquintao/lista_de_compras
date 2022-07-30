import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => ShopListProvider(),
    child: MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        '/new' :(context) => const NewItemPage(),
      },
    ),
  ));
}

enum Unity { uni, kg, g, L, mL }

class Item {
  final String name;
  final String id;
  bool isChecked;

  Item({required this.name})
      : id = const Uuid().v4(),
        isChecked = false;

  @override
  bool operator ==(covariant Item other) => id == other.id;

  @override
  int get hashCode => id.hashCode;

  void changeCheck() {
    isChecked = !isChecked;
  }

  @override
  String toString() {
    return name;
  }
}

class ShopListProvider extends ChangeNotifier {
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

class ShopListWidget extends StatelessWidget {
  final UnmodifiableListView<Item> shopList;
  const ShopListWidget({super.key, required this.shopList});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: shopList.map((item) => Card(child: Text(item.name),)).toList(),),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de compras'),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Consumer<ShopListProvider>(builder: (context, value, child) {
            return ShopListWidget(shopList: value.list,);
          },)
        ],
      )),
      floatingActionButton:
          FloatingActionButton(onPressed: () {
            Navigator.pushNamed(context, '/new');
          }, child: const Icon(Icons.add)),
    );
  }
}

class NewItemPage extends StatefulWidget {
  const NewItemPage({super.key});

  @override
  State<NewItemPage> createState() => _NewItemPageState();
}

class _NewItemPageState extends State<NewItemPage> {
  late final TextEditingController _controllerName;


  @override
  void initState() {
    _controllerName = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controllerName.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Novo item")),
      body: Column(children: [
        TextField(
          controller: _controllerName,
          decoration: const InputDecoration(hintText: "Nomde do item"),
        ),
        ElevatedButton(onPressed: () {
          if(_controllerName.value.text.isNotEmpty) {
            final Item item = Item(name: _controllerName.value.text);
          context.read<ShopListProvider>().addItem(item);
          print("clicou");
          Navigator.of(context).pop();
          }
        }, child: const Text("Adicionar"))
      ]),
    );
  }
}
