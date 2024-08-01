import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
part 'add_date.g.dart';

@HiveType(typeId: 0)
class Add_data extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String explain;
  @HiveField(2)
  String amount;
  @HiveField(3)
  String IN;
  @HiveField(4)
  DateTime datetime;
  //Add_data(this.IN, this.amount, this.datetime, this.explain, this.name);
  Add_data(this.name, this.explain, this.amount, this.IN, this.datetime);
}
