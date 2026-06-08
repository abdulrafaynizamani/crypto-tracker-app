import 'package:hive/hive.dart';

part 'coin_model.g.dart';

@HiveType(typeId: 0)
class CoinModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String symbol;
  @HiveField(3)
  final String imageUrl;
  @HiveField(4)
  final double currentPrice;
  @HiveField(5)
  final double priceChange24h;
  @HiveField(6)
  final double marketCap;
  @HiveField(7)
  final double volume24h;
  @HiveField(8)
  final List<double> sparkline;

  CoinModel({
    required this.id,
    required this.name,
    required this.symbol,
    required this.imageUrl,
    required this.currentPrice,
    required this.priceChange24h,
    required this.marketCap,
    required this.volume24h,
    required this.sparkline,
  });

  factory CoinModel.fromJson(Map<String, dynamic> json) {
    return CoinModel(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      symbol: json['symbol']?.toString().toUpperCase() ?? "",
      imageUrl: json['image'] ?? "",
      currentPrice: (json['current_price'] ?? 0.0).toDouble(),
      priceChange24h: (json['price_change_percentage_24h'] ?? 0.0).toDouble(),
      marketCap: (json['market_cap'] ?? 0.0).toDouble(),
      volume24h: (json['total_volume'] ?? 0.0).toDouble(),
      sparkline:
          json['sparkline_in_7d'] != null &&
              json['sparkline_in_7d']['price'] != null
          ? List<double>.from(
              json['sparkline_in_7d']['price'].map((x) => x.toDouble()),
            )
          : [],
    );
  }
}
