// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_bank.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddbankAdapter extends TypeAdapter<Add_bank> {
  @override
  final int typeId = 1;

  @override
  Add_bank read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Add_bank(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as File,
    );
  }

  @override
  void write(BinaryWriter writer, Add_bank obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.bank_name)
      ..writeByte(1)
      ..write(obj.number)
      ..writeByte(2)
      ..write(obj.username)
      ..writeByte(3)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AddbankAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}
