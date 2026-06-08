// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coin_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CoinModelAdapter extends TypeAdapter<CoinModel> {
  @override
  final int typeId = 0;

  @override
  CoinModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CoinModel(
      id: fields[0] as String,
      name: fields[1] as String,
      symbol: fields[2] as String,
      imageUrl: fields[3] as String,
      currentPrice: fields[4] as double,
      priceChange24h: fields[5] as double,
      marketCap: fields[6] as double,
      volume24h: fields[7] as double,
      sparkline: (fields[8] as List).cast<double>(),
    );
  }

  @override
  void write(BinaryWriter writer, CoinModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.symbol)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.currentPrice)
      ..writeByte(5)
      ..write(obj.priceChange24h)
      ..writeByte(6)
      ..write(obj.marketCap)
      ..writeByte(7)
      ..write(obj.volume24h)
      ..writeByte(8)
      ..write(obj.sparkline);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoinModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
