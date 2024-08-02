import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testas/data/model/add_date.dart';
import 'package:testas/data/utlity.dart';

import 'add.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var history;
  final box = Hive.box<Add_data>('data');
  final List<String> day = ['Thứ 2', "Thứ 3", "Thứ 4", "Thứ 5", 'Thứ 6', 'Thứ 7', 'Chủ Nhật'];

  List<Add_data> a = [];
  int index_color = 0;
  bool isAscending = true;

  void sortData() {
    setState(() {
      if (isAscending) {
        a.sort((a, b) => num.parse(a.amount.toString()).compareTo(num.parse(b.amount.toString())));
      } else {
        a.sort((a, b) => num.parse(b.amount.toString()).compareTo(num.parse(a.amount.toString())));
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: box.listenable(),
          builder: (context, value, child) {
            final sortedTransactions = box.values.toList()
              ..sort((a, b) => b.datetime.compareTo(a.datetime));

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      SizedBox(height: 340, child: _head()),
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
                          'Lịch sử giao dịch',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 19,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final history = sortedTransactions[index];
                      return Dismissible(
                        key: UniqueKey(),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          child: const Padding(
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
                                content: const Text("Bạn có chắc chắn muốn xóa dòng này không?"),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: const Text("Hủy"),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: const Text("Xác nhận"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        onDismissed: (direction) {
                          setState(() {
                            box.delete(history.key);
                          });
                        },
                        child: getList(history, index),
                      );
                    },
                    childCount: sortedTransactions.length,
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget getList(Add_data history, int index) {
    return Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) {
          history.delete();
        },
        child: get(index, history));

  }

  ListTile get(int index, Add_data history) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.asset('images/${history.name}.png', height: 40),
      ),
      // Chỉ định 'subtitle' là một Column chứa cả giải thích và thông tin ngày tháng
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '${history.explain}',
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Text(
            history.name,
            style: const TextStyle(
                fontSize: 17, fontWeight: FontWeight.w600, color: Colors.blue),
          ),
          Text(
            '${day[history.datetime.weekday - 1]}  ${history.datetime.day.toString().padLeft(2, '0')}/${history.datetime.month.toString().padLeft(2, '0')}/${history.datetime.year}',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
          ),
        ],
      ),
      trailing: Text(
        '${history.IN == 'Thu' ? '+' : '-'}${formatCurrency(history.amount)} đ',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 19,
          color: history.IN == 'Thu' ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}

String formatCurrency(String amountString) {
  int amount = int.parse(amountString);
  return amount.toString().replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
  );
}
final NumberFormat numberFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
Widget _head() {
  return Stack(
    children: [
      Column(
        children: [
          Container(
            width: double.infinity,
            height: 240,
            decoration: const BoxDecoration(
              color: Color(0xff368983),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 40,
                  right: 32,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Container(
                      height: 40,
                      width: 40,
                      color: Color.fromRGBO(250, 250, 250, 0.1),
                      child: const Icon(
                        Icons.notification_add_outlined,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 35, left: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Một ngày mới tốt lành!',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Color.fromARGB(255, 224, 223, 223),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      Center(
        child: Container(
          margin: EdgeInsets.only(top: 130, right: 40, left: 40, bottom: 40),
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(47, 125, 121, 0.3),
                offset: Offset(0, 6),
                blurRadius: 12,
                spreadRadius: 6,
              ),
            ],
            color: Color.fromARGB(255, 47, 125, 121),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tổng số dư',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    Icon(
                      Icons.more_horiz,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Text(
                      'VND ${numberFormat.format(total())}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 13,
                          backgroundColor: Color.fromARGB(255, 85, 145, 141),
                          child: Icon(
                            Icons.arrow_downward,
                            color: Colors.white,
                            size: 19,
                          ),
                        ),
                        SizedBox(width: 7),
                        Text(
                          'Số tiền nhận',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Color.fromARGB(255, 216, 216, 216),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 13,
                          backgroundColor: Color.fromARGB(255, 85, 145, 141),
                          child: Icon(
                            Icons.arrow_upward,
                            color: Colors.white,
                            size: 19,
                          ),
                        ),
                        SizedBox(width: 7),
                        Text(
                          'Số tiền chi',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Color.fromARGB(255, 216, 216, 216),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 6),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${numberFormat.format(income())}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${numberFormat.format(expenses())}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      )
    ],
  );
}
Widget _bot(BuildContext context) {
  return Scaffold(
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Add_Screen()));
      },
      child: Icon(Icons.add),
      backgroundColor: Color(0xff368983),
    ),
  );
}
