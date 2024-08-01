import 'package:flutter/material.dart';
import 'package:testas/Screens/home.dart';
import 'package:testas/Screens/statistics.dart';
import 'package:testas/widgets/bottomnavigationbar.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '/data/bank/image_adapter.dart';
import 'data/model/add_date.dart';
import '/data/bank/add_bank.dart';

void main() async {

  await Hive.initFlutter();
  Hive.registerAdapter(AdddataAdapter());
  await Hive.openBox<Add_data>('data');

  await Hive.initFlutter();
  Hive.registerAdapter(AddbankAdapter());
  await Hive.openBox<Add_bank>('bank');

  Hive.registerAdapter(FileAdapter());
  await Hive.initFlutter();
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Bottom(),
    );
  }
}
