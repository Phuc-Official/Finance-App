import 'dart:io';

import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
part 'add_bank.g.dart';

@HiveType(typeId: 1)
class Add_bank extends HiveObject {
  @HiveField(0)
  String bank_name;
  @HiveField(1)
  String number;
  @HiveField(2)
  String username;
  @HiveField(3)
  File? image;
  Add_bank(this.bank_name, this.number, this.username,this.image);
  //Add_bank(this.name, this.number, this.username, this.image);
}
