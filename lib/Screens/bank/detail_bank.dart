import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/bank/add_bank.dart';

class BankAccountDetailsScreen extends StatelessWidget {
  final Add_bank history;

  const BankAccountDetailsScreen({required this.history});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          margin: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 47, 125, 121),
            borderRadius: BorderRadius.circular(10),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0, left: 20, top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (history.image != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 0.0, left: 0, top: 10, bottom: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          history.image!,
                          height: 760,
                          width: 500,
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Container(
                      width: 500,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, top: 20.0, bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20, bottom: 0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.asset(
                                  'images/bank/${history.bank_name}.png',
                                  height: 90,
                                  width: 110,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 16.0),
                                  const Text('Số tài khoản'),
                                  const SizedBox(height: 0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        history.number,
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Transform(
                                        alignment: Alignment.centerLeft,
                                        transform: Matrix4.rotationY(pi),
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 16.0),
                                          child: IconButton(
                                            icon: const Icon(Icons.copy),
                                            color: Colors.blue,
                                            onPressed: () {
                                              Clipboard.setData(ClipboardData(text: history.number));
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  Future.delayed(const Duration(seconds: 2), () {
                                                    Navigator.of(context).pop();
                                                  });
                                                  return AlertDialog(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(16.0),
                                                    ),
                                                    backgroundColor: const Color(0xFF37474F),
                                                    elevation: 8.0,
                                                    content: ConstrainedBox(
                                                      constraints: const BoxConstraints(
                                                        maxHeight: 23.0, // Thiết lập chiều cao tối đa
                                                      ),
                                                      child: const Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            'Số tài khoản đã được sao chép',
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 16.0,
                                                            ),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10.0),
                                  const Text('Tên tài khoản'),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    history.username,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 20.0),
                                  const Text('Ngân hàng'),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    history.bank_name,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 20.0),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}