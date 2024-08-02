import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:testas/data/utlity.dart';
import 'package:testas/widgets/chart.dart';

import '../data/model/add_date.dart';


class Statistics extends StatefulWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  State<Statistics> createState() => _StatisticsState();
}

ValueNotifier kj = ValueNotifier(0);

class _StatisticsState extends State<Statistics> {
  List<String> day = ['Ngày', 'Tuần', 'Tháng', 'Năm'];
  List<List<Add_data>> f = [
    today(),
    week(),
    month(),
    year(),
  ];
  List<Add_data> a = [];
  int index_color = 0;
  bool isAscending = true;

  String formatCurrency(String amountString) {
    int amount = int.parse(amountString);
    return amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: kj,
          builder: (BuildContext context, dynamic value, Widget? child) {
            a = f[value];
            return custom();
          },
        ),
      ),
    );
  }

  void sortData() {
    setState(() {
      if (isAscending) {
        a.sort((a, b) => num.parse(a.amount.toString()).compareTo(num.parse(b.amount.toString())));
      } else {
        a.sort((a, b) => num.parse(b.amount.toString()).compareTo(num.parse(a.amount.toString())));
      }
    });
  }

  CustomScrollView custom() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                'Thống kê',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ...List.generate(
                      4,
                      (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              index_color = index;
                              kj.value = index;
                            });
                          },
                          child: Container(
                            height: 40,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: index_color == index
                                  ? Color.fromARGB(255, 47, 125, 121)
                                  : Colors.white,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              day[index],
                              style: TextStyle(
                                color: index_color == index
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Chart(
                indexx: index_color,
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Danh sách chi tiêu',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
// Thêm IconButton vào phần AppBar hoặc nơi khác phù hợp trong Scaffold
                    IconButton(
                      icon: const Row(
                        children: [
                          Text(
                            'Giá ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),
                          ),
                          Icon(Icons.swap_vert, color: Colors.blue,),
                          SizedBox(width: 4), // Khoảng cách giữa biểu tượng và text
                        ],
                      ),
                      iconSize: 25,
                      onPressed: () {
                        setState(() {
                          isAscending = !isAscending; // Đảo ngược thứ tự sắp xếp
                          sortData(); // Sắp xếp lại dữ liệu
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SliverList(
            delegate: SliverChildBuilderDelegate(
          (context, index) {
            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.asset('images/${a[index].name}.png', height: 40),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${a[index].explain}',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  Text(
                    a[index].name,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue),
                  ),
                  Text(
                    '${a[index].datetime.day.toString().padLeft(2, '0')}/${a[index].datetime.month.toString().padLeft(2, '0')}/${a[index].datetime.year}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              trailing: Text(
                '${a[index].IN == 'Thu' ? '+' : '-'}${formatCurrency(a[index].amount)} đ',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 19,
                  color: a[index].IN == 'Thu' ? Colors.green : Colors.red,
                ),
              ),
            );
          },
          childCount: a.length,
        ))
      ],
    );
  }
}
