import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:testas/Screens/bank/add_bank.dart';
import 'dart:convert';
import 'dart:typed_data';

import '../../data/bank/add_bank.dart';
import '../../data/model/add_date.dart';
import 'detail_bank.dart';

class BankInfoForm extends StatefulWidget {
  const BankInfoForm({super.key});

  @override
  State<BankInfoForm> createState() => _BankInfoFormState();
}

class _BankInfoFormState extends State<BankInfoForm> {
  var history;

  //late Box<Add_bank> box = Hive.box<Add_bank>('bank');
  //late Box<Add_bank> box;
  final box = Hive.box<Add_bank>('bank');

  Future<String> imageToBase64(String imagePath) async {
    final ByteData byteData =
        await rootBundle.load('images/bank/$imagePath.png');
    final Uint8List list = byteData.buffer.asUint8List();
    return base64Encode(list);
  }

  int index_color = 0;

  // @override
  // Future<void> initState()  async {
  //   super.initState();
  //   Hive.registerAdapter(AddbankAdapter());
  //   openBox();
  // }
  // void openBox() async {
  //   await Hive.openBox<Add_bank>('bank');
  //   //box = Hive.box<Add_bank>('bank');
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   _loadBankInfo();
  // }
  //
  // void _loadBankInfo() {
  //   Future.microtask(() async {
  //     await Hive.openBox<Add_bank>('bank');
  //     box = Hive.box<Add_bank>('bank');
  //   });
  // }

  @override
  Widget getList(Add_bank history, int index) {
    return Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) {
          history.delete();
        },
        child: get(index, history));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: box.listenable(),
          builder: (context, value, child) {
            return CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Danh sách ngân hàng của bạn:',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 19,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final history = box.values.toList()[index];
                      return Dismissible(
                        key: UniqueKey(),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                        ),
                        confirmDismiss: (DismissDirection direction) async {
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Xác nhận xóa"),
                                content: const Text(
                                    "Bạn có chắc chắn muốn xóa dòng này không?"),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text("Hủy"),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text("Xác nhận"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        onDismissed: (direction) {
                          setState(() {
                            // Xóa dữ liệu tại chỉ số index khi được xác nhận
                            box.delete(history.key);
                          });
                        },
                        child: getList(history, index),
                      );
                    },
                    childCount: box.length,
                  ),
                )
              ],
            );
          },
        ),
      ),
      floatingActionButton: index_color == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const Add_Bank_Screen()));
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              backgroundColor: Color(0xff368983),
            )
          : null,
    );
  }

  Widget get(int index, Add_bank history) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.asset(
          'images/bank/${history.bank_name}.png',
          height: 50,
          width: 115,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '${history.bank_name}',
            style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 18
            ),
          ),
          Row(
            children: [
              const Text(
                'STK: ',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              Text(
                history.number,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 8.0),
            ],
          ),
          Text(
            history.username,
            style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.grey
            ),
          ),
          const SizedBox(height: 10.0)
        ],
      ),
      onTap: () {
        // Khi người dùng nhấn vào đối tượng, hãy điều hướng đến màn hình chi tiết
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BankAccountDetailsScreen(
              history: history,
            ),
          ),
        );
      },
    );
  }
}
